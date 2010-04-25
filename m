Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:44162 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752980Ab0DYA7N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Apr 2010 20:59:13 -0400
Subject: Re: Problem with cx25840 and Terratec Grabster AV400
From: Andy Walls <awalls@md.metrocast.net>
To: Sven Barth <pascaldragon@googlemail.com>
Cc: Mike Isely <isely@isely.net>, linux-media@vger.kernel.org
In-Reply-To: <4BD35AA3.7070003@googlemail.com>
References: <4BD2EACA.5040005@googlemail.com>
	 <alpine.DEB.1.10.1004241212100.5135@ivanova.isely.net>
	 <4BD34E5A.40507@googlemail.com>
	 <alpine.DEB.1.10.1004241517320.5135@ivanova.isely.net>
	 <4BD35AA3.7070003@googlemail.com>
Content-Type: text/plain
Date: Sat, 24 Apr 2010 20:59:18 -0400
Message-Id: <1272157158.7341.56.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2010-04-24 at 22:54 +0200, Sven Barth wrote:

> 
> It would be interesting to know why the v4l devs disabled the audio 
> routing for cx2583x chips and whether it was intended that a cx25837 
> chip gets the same treatment as a e.g. cx25836.
> And those "implications" you're talking about is the reason why I wrote 
> here: I want to check whether there is a better or more correct way than 
> to disable those checks (it works here, because I have only that one 
> device that contains a cx2583x chip...).

The CX25836 and CX25837 do not have any audio functions.  They are video
only chips.

The only difference between the chips is that the CX25837 comes in two
different packages and has a version that is pin compatible with the
CX2584[0123] chips.

The public data sheet is here:

http://www.conexant.com/products/entry.jsp?id=77


Note that the CX2583x chip do have an AUX_PLL which can be output from
the chip as an audio clock.


> Just a thought: can it be that my chip's audio routing isn't set to the 
> correct value after initialization and thus it needs to be set at least 
> once, while all other chips default to a working routing after 
> initialization? Could be a design mistake done by Terratec...

No chip defaults are what they are, most people don't design a board to
match up with them.

I does look like Terratec saved themselves an external oscillator by
using the AUX_PLL in the CX2583x as an audio clock.


As for your changes.  They are wrong, but in a benign way I think.
There is no real penalty for writing to the "Merlin" audio core
registers that don't exist in this chip (0x800-0x9ff), as long as the
chip is decoding all the address bits properly and not wrapping them
back down to the "Thresher" video core registers at 0x000-0x1ff.  


As for your first change:

        @@ -849,10 +849,10 @@
         
                state->vid_input = vid_input;
                state->aud_input = aud_input;
        -       if (!is_cx2583x(state)) {
        +//     if (!is_cx2583x(state)) {
                        cx25840_audio_set_path(client);
                        input_change(client);
        -       }
        +//     }
         
                if (is_cx2388x(state)) {
                        /* Audio channel 1 src : Parallel 1 */

This is incomplete.  Along with removing the check, you need to "push
down" the is_cx2583x() check into input_change() and
cx25840_audio_set_path().  What you likely also need to do for a CX2583x
is:

a. Modify input_change() to add is_cx2583x() checks to avoid the
operations on registers in the 0x800-0x9ff range, but still let the
operations to registers in the 0x400-0x4ff range be performed.  These
are Chroma processing settings that may have some effect on your video.

b. Modify cx25840_audio_set_path() to add is_cx2583x() checks to avoid
the operations on registers in the 0x800-0x9ff range, but still let the
call to set_audclk_freq() go through.  From there
cx25836_set_audclk_freq() and cx25840_set_audclk_freq() will set up the
PLLs while avoiding writes to registers in the 0x800-0x9ff range for the
CX2583x chips.


Let's look at your second change:

        @@ -1504,8 +1504,8 @@
                struct cx25840_state *state = to_state(sd);
                struct i2c_client *client = v4l2_get_subdevdata(sd);
         
        -       if (is_cx2583x(state))
        -               return -EINVAL;
        +/*     if (is_cx2583x(state))
        +               return -EINVAL;*/
                return set_input(client, state->vid_input, input);
         }

If you made the proper changes to

	set_input()
		cx25840_audio_set_path()
			set_audclk_freq()
				cx25836_set_audclk_freq()
					cx25840_set_audclk_freq()
		input_change()

then you have already pushed this check down to several places and
allowed AUX_PLL reconfiguration to take place.  Thus it is then correct
to remove the check from here.




Well, that's my guess anyway.  Did it all make sense?

Regards,
Andy

