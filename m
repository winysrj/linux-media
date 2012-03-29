Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61168 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab2C2JSm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Mar 2012 05:18:42 -0400
Received: by vbbff1 with SMTP id ff1so1317296vbb.19
        for <linux-media@vger.kernel.org>; Thu, 29 Mar 2012 02:18:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F742569.5020503@redhat.com>
References: <CAJu-Zix22G3WbCCJ1h7P7+9naEU0XkYNDELTk9hCzMQ8UYB-gQ@mail.gmail.com>
 <4F742569.5020503@redhat.com>
From: =?UTF-8?Q?Rafa=C5=82_Rzepecki?= <divided.mind@gmail.com>
Date: Thu, 29 Mar 2012 11:18:21 +0200
Message-ID: <CAJu-ZixgaED4r5+OZHvEtSD8fUVmYyi6ZvNmMtDyZrtSFFGAOw@mail.gmail.com>
Subject: Re: Startup delay needed for a Sonix camera
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/3/29 Hans de Goede <hdegoede@redhat.com>:
> Hi,
>
>
> On 03/29/2012 08:27 AM, Rafał Rzepecki wrote:
>>
>> Hi,
>>
>> I've tried to reach Jean-Francois with this a week ago, but I still
>> haven't received an answer, so I'm sending it to the mailing list. I'd
>> appreciate a CC of any follow-ups.
>>
>> I've been having problems with my ID 0c45:6128 Microdia PC Camera
>> (SN9C325 + OM6802) using driver gspca_sonixj. Specifically, launching
>> command:
>> $ gst-launch-0.10 v4l2src ! ffmpegcolorspace ! pngenc ! filesink \
>> location=/tmp/file.png
>> gave a file that is all black. This is problematic because at least
>> one program (odeskteam) uses a similar method to grab camshots.
>>
>> I thought it looked like as though the camera hasn't got enough time
>> to initialize, and indeed, adding an msleep(30) near the end of
>> sd_start() in sonixj.c solved the problem.
>
>
> The problem is that the above method to take a snapshot is simply
> wrong. Many cameras need to be streaming video data for "a while"
> before they give a (good) picture.
>
> Many cameras need some time for things like auto-gain, auto-exposure,
> auto-whitebalance and auto-focus to get to their correct setting for
> a proper picture. A black picture probably means that the auto-gain/
> auto-exposure for set camera still needs to jank up the gain and/or
> exposure. and you're simply not giving it time for this.

The fix already in the trunk (see my other message) proves that's not
the case in this instance.
(Also, I've checked whether it's really all black or just very dim.
Even aiming the camera at a bright halogen bulb gave black picture.)

> My high quality HD video microsoft studio pro camera also starts
> out with a close to black picture when I start streaming data from
> it in anything but bright sunlight, and then corrects the picture
> in 1-5 frames. This same camera takes like .5 seconds to gets it
> auto focus settled so your snapshot example would likely result
> in a too dark, unsharp picture. Note that this is all handled by
> the camera itself, the UVC driver it uses has no control over this.
>
> Why do you think digital compact (still photo) cameras take so much
> time from you pressing the take picture button to actually taking the
> picture? They are in essence doing the same. The only difference
> with webcams is that people want more then 1 picture / second so
> the camera cannot do all those corrections before sending a picture,
> instead it does them while it is streaming data, meaning that the
> first second or so of data can be quite useless.

While all true, at least with that camera (after applying either fix)
and one another I have laying around I've observed no discernible
difference between quality of pictures obtained with this method and
after a few seconds warm-up. I suspect most, if not all, 'web' cameras
are capable of giving satisfactory picture on such short notice,
especially given their automation is rather unsophisticated compared
to still photo cameras; of course in extreme conditions (low light,
etc.) all bets are off.

Anyhow, while I agree that the best solution would be for the app to
switch to a more sophisticated snapshot method, I don't really have
any bearing whatsoever on the app that exposed the problem; it's
proprietary and closed-source and I only use it, and although I have
filed a bugreport they haven't exactly been very responsive. OTOH, I
suppose that confirms that this method usually works sufficiently well
-- otherwise I expect they'd have known the problem and implemented
appropriate workarounds, if only as hidden debug options, which they
seemed not have done.

It's also worth noting that it this particular application the picture
doesn't have to be of great quality, so perhaps that's the reason for
the quick and dirty method chosen -- but it's important that at least
_something_ can be seen. As long as the hardware is basically capable
of that (as is true in this case), I think the driver should expose
this capability.
-- 
Rafał Rzepecki
