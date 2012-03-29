Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab2C2JBg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Mar 2012 05:01:36 -0400
Message-ID: <4F742569.5020503@redhat.com>
Date: Thu, 29 Mar 2012 11:03:37 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIFJ6ZXBlY2tp?= <divided.mind@gmail.com>
CC: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>
Subject: Re: Startup delay needed for a Sonix camera
References: <CAJu-Zix22G3WbCCJ1h7P7+9naEU0XkYNDELTk9hCzMQ8UYB-gQ@mail.gmail.com>
In-Reply-To: <CAJu-Zix22G3WbCCJ1h7P7+9naEU0XkYNDELTk9hCzMQ8UYB-gQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/29/2012 08:27 AM, Rafał Rzepecki wrote:
> Hi,
>
> I've tried to reach Jean-Francois with this a week ago, but I still
> haven't received an answer, so I'm sending it to the mailing list. I'd
> appreciate a CC of any follow-ups.
>
> I've been having problems with my ID 0c45:6128 Microdia PC Camera
> (SN9C325 + OM6802) using driver gspca_sonixj. Specifically, launching
> command:
> $ gst-launch-0.10 v4l2src ! ffmpegcolorspace ! pngenc ! filesink \
> location=/tmp/file.png
> gave a file that is all black. This is problematic because at least
> one program (odeskteam) uses a similar method to grab camshots.
>
> I thought it looked like as though the camera hasn't got enough time
> to initialize, and indeed, adding an msleep(30) near the end of
> sd_start() in sonixj.c solved the problem.

The problem is that the above method to take a snapshot is simply
wrong. Many cameras need to be streaming video data for "a while"
before they give a (good) picture.

Many cameras need some time for things like auto-gain, auto-exposure,
auto-whitebalance and auto-focus to get to their correct setting for
a proper picture. A black picture probably means that the auto-gain/
auto-exposure for set camera still needs to jank up the gain and/or
exposure. and you're simply not giving it time for this.

My high quality HD video microsoft studio pro camera also starts
out with a close to black picture when I start streaming data from
it in anything but bright sunlight, and then corrects the picture
in 1-5 frames. This same camera takes like .5 seconds to gets it
auto focus settled so your snapshot example would likely result
in a too dark, unsharp picture. Note that this is all handled by
the camera itself, the UVC driver it uses has no control over this.

Why do you think digital compact (still photo) cameras take so much
time from you pressing the take picture button to actually taking the
picture? They are in essence doing the same. The only difference
with webcams is that people want more then 1 picture / second so
the camera cannot do all those corrections before sending a picture,
instead it does them while it is streaming data, meaning that the
first second or so of data can be quite useless.

Regards,

Hans
