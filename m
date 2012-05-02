Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36322 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab2EBIzu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2012 04:55:50 -0400
Received: by obbtb18 with SMTP id tb18so691938obb.19
        for <linux-media@vger.kernel.org>; Wed, 02 May 2012 01:55:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120502084318.GA21181@kipc2.localdomain>
References: <20120424122156.GA16769@kipc2.localdomain> <20120502084318.GA21181@kipc2.localdomain>
From: Paulo Assis <pj.assis@gmail.com>
Date: Wed, 2 May 2012 09:55:29 +0100
Message-ID: <CAPueXH4-VSxHYjryO8kN5R-hG6seFrwCu3Kjrq4TXV=XFKLETg@mail.gmail.com>
Subject: Re: logitech quickcam 9000 uvcdynctrl broken since kernel 3.2 - PING
To: Karl Kiniger <karl.kiniger@med.ge.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Karl Hi,
I'm using a 3.2 kernel and I haven't notice this problem, can you
check the exact version that causes it.

Regards,
Paulo

2012/5/2 Karl Kiniger <karl.kiniger@med.ge.com>:
> Please can someone shed a little light on this?
>
> Greatly appreciated,
> Karl
>
> On Tue 120424, Karl Kiniger wrote:
>> Dear all,
>>
>> guvcview does not display the extra controls (focus, led etc)
>> any more since kernel 3.2 an higher (Fedora 16, x86_64).
>>
>> after the various video modes it says:
>>
>> vid:046d
>> pid:0990
>> driver:uvcvideo
>> Adding control for Pan (relative)
>> UVCIOC_CTRL_ADD - Error: Inappropriate ioctl for device
>> checking format: 1196444237
>> VIDIOC_G_COMP:: Inappropriate ioctl for device
>> fps is set to 1/25
>> drawing controls
>>
>> Checking video mode 640x480@32bpp : OK
>>
>> ----------
>>
>> /usr/bin/uvcdynctrl -i /usr/share/uvcdynctrl/data/046d/logitech.xml
>> [libwebcam] Unsupported V4L2_CID_EXPOSURE_AUTO control with a non-contiguous range of choice IDs found
>> [libwebcam] Invalid or unsupported V4L2 control encountered: ctrl_id = 0x009A0901, name = 'Exposure, Auto'
>> Importing dynamic controls from file /usr/share/uvcdynctrl/data/046d/logitech.xml.
>> ERROR: Unable to import dynamic controls: Invalid device or device cannot be opened. (Code: 5)
>> /usr/share/uvcdynctrl/data/046d/logitech.xml: error: device 'video0' \
>>     skipped because the driver 'uvcvideo' behind it does not seem to support \
>>         dynamic controls.
>>
>> ----------
>>
>> Is there work in progess to get the missing functionality back?
>>
>> Can I help somehow?
>>
>> Greetings,
>> Karl
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
