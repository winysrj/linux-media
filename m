Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:11017 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab0DYP1e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Apr 2010 11:27:34 -0400
Received: by fg-out-1718.google.com with SMTP id d23so1997403fga.1
        for <linux-media@vger.kernel.org>; Sun, 25 Apr 2010 08:27:32 -0700 (PDT)
Message-ID: <4BD45F61.50904@googlemail.com>
Date: Sun, 25 Apr 2010 17:27:29 +0200
From: Sven Barth <pascaldragon@googlemail.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Mike Isely <isely@isely.net>, linux-media@vger.kernel.org
Subject: Re: Problem with cx25840 and Terratec Grabster AV400
References: <4BD2EACA.5040005@googlemail.com>	 <alpine.DEB.1.10.1004241212100.5135@ivanova.isely.net>	 <4BD34E5A.40507@googlemail.com>	 <alpine.DEB.1.10.1004241517320.5135@ivanova.isely.net>	 <4BD35AA3.7070003@googlemail.com> <1272157158.7341.56.camel@palomino.walls.org>
In-Reply-To: <1272157158.7341.56.camel@palomino.walls.org>
Content-Type: multipart/mixed;
 boundary="------------050002060306010206060903"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050002060306010206060903
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi!

On 25.04.2010 02:59, Andy Walls wrote:
> On Sat, 2010-04-24 at 22:54 +0200, Sven Barth wrote:
>
>>
>> It would be interesting to know why the v4l devs disabled the audio
>> routing for cx2583x chips and whether it was intended that a cx25837
>> chip gets the same treatment as a e.g. cx25836.
>> And those "implications" you're talking about is the reason why I wrote
>> here: I want to check whether there is a better or more correct way than
>> to disable those checks (it works here, because I have only that one
>> device that contains a cx2583x chip...).
>
> The CX25836 and CX25837 do not have any audio functions.  They are video
> only chips.
>
> The only difference between the chips is that the CX25837 comes in two
> different packages and has a version that is pin compatible with the
> CX2584[0123] chips.
>
> The public data sheet is here:
>
> http://www.conexant.com/products/entry.jsp?id=77
>
>
> Note that the CX2583x chip do have an AUX_PLL which can be output from
> the chip as an audio clock.
>

Well... that explains the is_cx2583x checks ^^

>
>> Just a thought: can it be that my chip's audio routing isn't set to the
>> correct value after initialization and thus it needs to be set at least
>> once, while all other chips default to a working routing after
>> initialization? Could be a design mistake done by Terratec...
>
> No chip defaults are what they are, most people don't design a board to
> match up with them.
>
> I does look like Terratec saved themselves an external oscillator by
> using the AUX_PLL in the CX2583x as an audio clock.
>

It seems as if that is the case...

>
> As for your changes.  They are wrong, but in a benign way I think.
> There is no real penalty for writing to the "Merlin" audio core
> registers that don't exist in this chip (0x800-0x9ff), as long as the
> chip is decoding all the address bits properly and not wrapping them
> back down to the "Thresher" video core registers at 0x000-0x1ff.
>

I never thought of those changes as a real solution, but merely as a 
work around or a first step for finding the real issue. ^^

>
> As for your first change:
>
>          @@ -849,10 +849,10 @@
>
>                  state->vid_input = vid_input;
>                  state->aud_input = aud_input;
>          -       if (!is_cx2583x(state)) {
>          +//     if (!is_cx2583x(state)) {
>                          cx25840_audio_set_path(client);
>                          input_change(client);
>          -       }
>          +//     }
>
>                  if (is_cx2388x(state)) {
>                          /* Audio channel 1 src : Parallel 1 */
>
> This is incomplete.  Along with removing the check, you need to "push
> down" the is_cx2583x() check into input_change() and
> cx25840_audio_set_path().  What you likely also need to do for a CX2583x
> is:
>
> a. Modify input_change() to add is_cx2583x() checks to avoid the
> operations on registers in the 0x800-0x9ff range, but still let the
> operations to registers in the 0x400-0x4ff range be performed.  These
> are Chroma processing settings that may have some effect on your video.
>
> b. Modify cx25840_audio_set_path() to add is_cx2583x() checks to avoid
> the operations on registers in the 0x800-0x9ff range, but still let the
> call to set_audclk_freq() go through.  From there
> cx25836_set_audclk_freq() and cx25840_set_audclk_freq() will set up the
> PLLs while avoiding writes to registers in the 0x800-0x9ff range for the
> CX2583x chips.
>
>
> Let's look at your second change:
>
>          @@ -1504,8 +1504,8 @@
>                  struct cx25840_state *state = to_state(sd);
>                  struct i2c_client *client = v4l2_get_subdevdata(sd);
>
>          -       if (is_cx2583x(state))
>          -               return -EINVAL;
>          +/*     if (is_cx2583x(state))
>          +               return -EINVAL;*/
>                  return set_input(client, state->vid_input, input);
>           }
>
> If you made the proper changes to
>
> 	set_input()
> 		cx25840_audio_set_path()
> 			set_audclk_freq()
> 				cx25836_set_audclk_freq()
> 					cx25840_set_audclk_freq()
> 		input_change()
>
> then you have already pushed this check down to several places and
> allowed AUX_PLL reconfiguration to take place.  Thus it is then correct
> to remove the check from here.
>
>

Ok... I've done those changes, so that only set_audclk_freq is called on 
cx2583x chips and guess what: it works! :D (see attached patch)

>
>
> Well, that's my guess anyway.  Did it all make sense?
>
> Regards,
> Andy
>

Well... your guess was right. And it made sense (so much, that it even 
works ^^).

Regards,
Sven

--------------050002060306010206060903
Content-Type: text/plain;
 name="cx25840.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cx25840.patch"

diff -aur v4l-src/linux/drivers/media/video/cx25840//cx25840-audio.c v4l-build/linux/drivers/media/video/cx25840//cx25840-audio.c
--- v4l-src/linux/drivers/media/video/cx25840//cx25840-audio.c	2009-10-18 21:08:26.497700904 +0200
+++ v4l-build/linux/drivers/media/video/cx25840//cx25840-audio.c	2010-04-25 17:16:00.205619872 +0200
@@ -438,41 +438,45 @@
 {
 	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
 
-	/* assert soft reset */
-	cx25840_and_or(client, 0x810, ~0x1, 0x01);
-
-	/* stop microcontroller */
-	cx25840_and_or(client, 0x803, ~0x10, 0);
-
-	/* Mute everything to prevent the PFFT! */
-	cx25840_write(client, 0x8d3, 0x1f);
-
-	if (state->aud_input == CX25840_AUDIO_SERIAL) {
-		/* Set Path1 to Serial Audio Input */
-		cx25840_write4(client, 0x8d0, 0x01011012);
-
-		/* The microcontroller should not be started for the
-		 * non-tuner inputs: autodetection is specific for
-		 * TV audio. */
-	} else {
-		/* Set Path1 to Analog Demod Main Channel */
-		cx25840_write4(client, 0x8d0, 0x1f063870);
-	}
+        if (!is_cx2583x(state)) {
+		/* assert soft reset */
+		cx25840_and_or(client, 0x810, ~0x1, 0x01);
+
+		/* stop microcontroller */
+		cx25840_and_or(client, 0x803, ~0x10, 0);
+
+		/* Mute everything to prevent the PFFT! */
+		cx25840_write(client, 0x8d3, 0x1f);
+
+		if (state->aud_input == CX25840_AUDIO_SERIAL) {
+			/* Set Path1 to Serial Audio Input */
+			cx25840_write4(client, 0x8d0, 0x01011012);
+
+			/* The microcontroller should not be started for the
+			 * non-tuner inputs: autodetection is specific for
+			 * TV audio. */
+		} else {
+			/* Set Path1 to Analog Demod Main Channel */
+			cx25840_write4(client, 0x8d0, 0x1f063870);
+		}
+        }
 
 	set_audclk_freq(client, state->audclk_freq);
 
-	if (state->aud_input != CX25840_AUDIO_SERIAL) {
-		/* When the microcontroller detects the
-		 * audio format, it will unmute the lines */
-		cx25840_and_or(client, 0x803, ~0x10, 0x10);
-	}
-
-	/* deassert soft reset */
-	cx25840_and_or(client, 0x810, ~0x1, 0x00);
-
-	/* Ensure the controller is running when we exit */
-	if (is_cx2388x(state) || is_cx231xx(state))
-		cx25840_and_or(client, 0x803, ~0x10, 0x10);
+        if (!is_cx2583x(state)) {
+		if (state->aud_input != CX25840_AUDIO_SERIAL) {
+			/* When the microcontroller detects the
+			 * audio format, it will unmute the lines */
+			cx25840_and_or(client, 0x803, ~0x10, 0x10);
+		}
+
+		/* deassert soft reset */
+		cx25840_and_or(client, 0x810, ~0x1, 0x00);
+
+		/* Ensure the controller is running when we exit */
+		if (is_cx2388x(state) || is_cx231xx(state))
+			cx25840_and_or(client, 0x803, ~0x10, 0x10);
+        }
 }
 
 static int get_volume(struct i2c_client *client)
Nur in v4l-build/linux/drivers/media/video/cx25840/: cx25840-audio.c.bak.
diff -aur v4l-src/linux/drivers/media/video/cx25840//cx25840-core.c v4l-build/linux/drivers/media/video/cx25840//cx25840-core.c
--- v4l-src/linux/drivers/media/video/cx25840//cx25840-core.c	2010-04-24 10:48:56.392367351 +0200
+++ v4l-build/linux/drivers/media/video/cx25840//cx25840-core.c	2010-04-25 17:12:37.448983292 +0200
@@ -691,6 +691,11 @@
 	}
 	cx25840_and_or(client, 0x401, ~0x60, 0);
 	cx25840_and_or(client, 0x401, ~0x60, 0x60);
+
+        /* Don't write into audio registers on cx2583x chips */
+        if (is_cx2583x(state))
+        	return;
+
 	cx25840_and_or(client, 0x810, ~0x01, 1);
 
 	if (state->radio) {
@@ -704,8 +709,7 @@
 		   To be precise: it affects cards with tuner models
 		   85, 99 and 112 (model numbers from tveeprom). */
 		int hw_fix = state->pvr150_workaround;
-
-		if (std == V4L2_STD_NTSC_M_JP) {
+			if (std == V4L2_STD_NTSC_M_JP) {
 			/* Japan uses EIAJ audio standard */
 			cx25840_write(client, 0x808, hw_fix ? 0x2f : 0xf7);
 		} else if (std == V4L2_STD_NTSC_M_KR) {
@@ -742,7 +746,6 @@
 			cx25840_write(client, 0x80b, 0x10);
 	       }
 	}
-
 	cx25840_and_or(client, 0x810, ~0x01, 0);
 }
 
@@ -849,10 +852,8 @@
 
 	state->vid_input = vid_input;
 	state->aud_input = aud_input;
-	if (!is_cx2583x(state)) {
-		cx25840_audio_set_path(client);
-		input_change(client);
-	}
+	cx25840_audio_set_path(client);
+	input_change(client);
 
 	if (is_cx2388x(state)) {
 		/* Audio channel 1 src : Parallel 1 */
@@ -1504,8 +1505,6 @@
 	struct cx25840_state *state = to_state(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (is_cx2583x(state))
-		return -EINVAL;
 	return set_input(client, state->vid_input, input);
 }
 
@@ -1514,8 +1513,7 @@
 	struct cx25840_state *state = to_state(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (!is_cx2583x(state))
-		input_change(client);
+	input_change(client);
 	return 0;
 }
 
Nur in v4l-build/linux/drivers/media/video/cx25840/: cx25840-core.c.bak.

--------------050002060306010206060903--
