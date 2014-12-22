Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55884 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015AbaLVPYY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Dec 2014 10:24:24 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so8327917wiv.11
        for <linux-media@vger.kernel.org>; Mon, 22 Dec 2014 07:24:23 -0800 (PST)
Message-ID: <549837A4.2060605@vodalys.com>
Date: Mon, 22 Dec 2014 16:24:20 +0100
From: =?UTF-8?B?RnLDqWTDqXJpYyBTdXJlYXU=?= <frederic.sureau@vodalys.com>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	Fabio Estevam <festevam@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: Re: coda: Unable to use encoder video_bitrate
References: <54930468.6010007@vodalys.com> <1418921549.4212.57.camel@pengutronix.de>
In-Reply-To: <1418921549.4212.57.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Le 18/12/2014 17:52, Philipp Zabel a écrit :
> Hi Frédéric,
>
> Am Donnerstag, den 18.12.2014, 17:44 +0100 schrieb Frédéric Sureau:
>> Hi
>>
>> I am trying to use the coda encoder through Gstreamer on an iMX6-based
>> board.
>>
>> I use the (rebased and slightly modified) gstv4l2h264enc plugin from:
>> https://github.com/hizukiayaka/gst-plugins-good
>>
>> This pipeline works fine:
>> gst-launch-1.0 -vvv v4l2src device=/dev/video4 !
>> "video/x-raw,width=1280,height=720" ! videoconvert ! v4l2video0h264enc !
>> h264parse ! mp4mux ! filesink location=test.mp4
>>
>> When encoder has no bitrate param set (default=0), video encoding works
>> well, but bitrate reaches ~2.5Mbps
>>
>> When I try to set the bitrate with whatever value like 100,000 or
>> 1,000,000, the encoder produces video with bitrate around 480kbps and a
>> very poor quality.
>>
>> Here is the gstreamer pipeline I use with bitrate set:
>> gst-launch-1.0 -vvv v4l2src device=/dev/video4 !
>> "video/x-raw,width=1280,height=720" ! videoconvert ! v4l2video0h264enc
>> extra-controls="controls,video_bitrate=1000000;" ! h264parse ! mp4mux !
>> filesink location=test.mp4
>>
>> The video_bitrate control seems to be correctly passed to the driver by
>> GStreamer since I can see the VIDIOC_S_CTRL call.
>>
>> Any idea ?
> There is a bug in the register definitions that causes the driver to
> apply a wrong mask before writing the bitrate to the register.
> I've got a fix for this in the pipeline, sending it right now.
>
> regards
> Philipp
>
Thanks for the patch!
It works fine now after forcing framerate to 30fps (which seems to be 
hardcoded in the driver)

Fred
