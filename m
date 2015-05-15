Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55147 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934169AbbEOLUs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2015 07:20:48 -0400
Message-ID: <5555D68E.4090708@iki.fi>
Date: Fri, 15 May 2015 14:20:46 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH RFCv1] v4l2: add support for SDR transmitter
References: <1431625907-7562-1-git-send-email-crope@iki.fi> <5555BB9C.8070605@xs4all.nl>
In-Reply-To: <5555BB9C.8070605@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!

On 05/15/2015 12:25 PM, Hans Verkuil wrote:
> Hi Antti,
>
> Looks good, but the DocBook updates are missing. You probably planned to do that in
> RFCv2 or similar.

Yep, first code then doc.

> Which device will have sdr_out? What's the cheapest device and where can I buy it? I'd
> like to be able to test it (and add qv4l2 support),

I used HackRF One, it is likely 150-250e used one.

Currently I have implemented almost all radio features it has, only 
option to enable antenna power supply is missing (and firmware upgrade, 
but it is not radio feature).

Device is half-duplex - only RX or TX could be used at the time. Driver 
creates two device nodes, one for receiver and another for transmitter.

There is:
2 x struct video_device
2 x struct v4l2_device
2 x struct vb2_queue
2 x struct v4l2_ctrl_handler

Locking is still missing. I am not sure how it should be done, but 
likely I try add lock to start/stop streaming. When start streaming is 
called it sets some flag/lock and if another device node tries start 
streaming at same time error is returned.

Device uses Complex S8 format for both receiver and transmitter. I will 
add that format to vivid and then it should be possible generate beep 
using vivid and transmit it using HackRF (cat /dev/swradio0 > 
/dev/swradio1), where swradio0 is vivid and swradio1 is HackRF.

regards
Antti

-- 
http://palosaari.fi/
