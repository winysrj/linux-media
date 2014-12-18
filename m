Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:58593 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaLRRLM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 12:11:12 -0500
Received: by mail-oi0-f46.google.com with SMTP id h136so668934oig.19
        for <linux-media@vger.kernel.org>; Thu, 18 Dec 2014 09:11:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1418922570.4212.67.camel@pengutronix.de>
References: <54930468.6010007@vodalys.com> <1418921549.4212.57.camel@pengutronix.de>
 <CAL8zT=jjm9BXuUbk5RS-LZpC1EyyTwdGQRy-fQEUMdDfj4Ej7g@mail.gmail.com> <1418922570.4212.67.camel@pengutronix.de>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Thu, 18 Dec 2014 18:10:57 +0100
Message-ID: <CAL8zT=jL3psKQ7+K4avQp=tr58m-KXvqGGhXzYrafEuRB5hkcw@mail.gmail.com>
Subject: Re: coda: Unable to use encoder video_bitrate
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: =?UTF-8?B?RnLDqWTDqXJpYyBTdXJlYXU=?= <frederic.sureau@vodalys.com>,
	Fabio Estevam <festevam@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2014-12-18 18:09 GMT+01:00 Philipp Zabel <p.zabel@pengutronix.de>:
> Hi Jean-Michel,
>
> Am Donnerstag, den 18.12.2014, 17:55 +0100 schrieb Jean-Michel Hautbois:
>> Hi Philipp,
>>
>> 2014-12-18 17:52 GMT+01:00 Philipp Zabel <p.zabel@pengutronix.de>:
>> > Hi Frédéric,
>> >
>> > Am Donnerstag, den 18.12.2014, 17:44 +0100 schrieb Frédéric Sureau:
>> >> Hi
>> >>
>> >> I am trying to use the coda encoder through Gstreamer on an iMX6-based
>> >> board.
>> >>
>> >> I use the (rebased and slightly modified) gstv4l2h264enc plugin from:
>> >> https://github.com/hizukiayaka/gst-plugins-good
>> >>
>> >> This pipeline works fine:
>> >> gst-launch-1.0 -vvv v4l2src device=/dev/video4 !
>> >> "video/x-raw,width=1280,height=720" ! videoconvert ! v4l2video0h264enc !
>> >> h264parse ! mp4mux ! filesink location=test.mp4
>> >>
>> >> When encoder has no bitrate param set (default=0), video encoding works
>> >> well, but bitrate reaches ~2.5Mbps
>> >>
>> >> When I try to set the bitrate with whatever value like 100,000 or
>> >> 1,000,000, the encoder produces video with bitrate around 480kbps and a
>> >> very poor quality.
>> >>
>> >> Here is the gstreamer pipeline I use with bitrate set:
>> >> gst-launch-1.0 -vvv v4l2src device=/dev/video4 !
>> >> "video/x-raw,width=1280,height=720" ! videoconvert ! v4l2video0h264enc
>> >> extra-controls="controls,video_bitrate=1000000;" ! h264parse ! mp4mux !
>> >> filesink location=test.mp4
>> >>
>> >> The video_bitrate control seems to be correctly passed to the driver by
>> >> GStreamer since I can see the VIDIOC_S_CTRL call.
>> >>
>> >> Any idea ?
>> >
>> > There is a bug in the register definitions that causes the driver to
>> > apply a wrong mask before writing the bitrate to the register.
>> > I've got a fix for this in the pipeline, sending it right now.
>>
>> Where can we find the register definitions ? In order to look at it
>> before asking you :) ?
>
> Sorry, forgot to put all of you on Cc: for the "[media] coda: fix
> encoder rate control parameter masks" patch. The coda driver is in
> drivers/media/platform/coda, register definitions in coda_regs.h.
> The CODA_RATECONTROL_BITRATE_MASK is 0x7f, but it should be 0x7fff.
>

Well, I meant, the datasheet of the CODA960 because we don't know,
just by reading the coda_regs.h which register is where and does what.
But it may be confidential ?

JM
