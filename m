Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:46128 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaGIL5m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jul 2014 07:57:42 -0400
Received: by mail-pd0-f180.google.com with SMTP id fp1so8775800pdb.25
        for <linux-media@vger.kernel.org>; Wed, 09 Jul 2014 04:57:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53BC342B.4070801@googlemail.com>
References: <CAB0d6EdzyiGFKbjPS4QSwLOvBaWaoRG43K=bwwKVLXyVHYZEmg@mail.gmail.com>
	<53BC342B.4070801@googlemail.com>
Date: Wed, 9 Jul 2014 08:57:41 -0300
Message-ID: <CAB0d6Efs=tB-Szr5yXfNppuWtSK1_c2LUny+sZdP2PJX91_r5A@mail.gmail.com>
Subject: Re: New v4l2 driver does not allow brightness/contrast control
From: Rafael Coutinho <rafael.coutinho@phiinnovations.com>
To: =?UTF-8?Q?Frank_Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yeah, tested on kernel 3.15 and it worked. The problem is that my
board doesn't have Android  HAL's compatible with that version, so i'm
trying to find where is the difference.

2014-07-08 15:10 GMT-03:00 Frank Schäfer <fschaefer.oss@googlemail.com>:
>
> Am 07.07.2014 19:58, schrieb Rafael Coutinho:
>> I have a v4l2 video capture board that using kernel 2.6 with v4l2
>> em28xx driver 3.0.36 allows me to control brightness, contrast etc...
>> However in kernel 3.2 with v4l2 em28xx driver version 3.2.0 it does not.
>>
>> This is what I get from the latest driver:
>> root@android:/ # v4l2-ctl --info
>> Driver Info (not using libv4l2):
>> Driver name   : em28xx
>> Card type     : EM2860/SAA711X Reference Design
>> Bus info      : usb-musb-hdrc.1-1
>> Driver version: 3.2.0
>> Capabilities  : 0x05020051
>> Video Capture
>> VBI Capture
>> Sliced VBI Capture
>> Audio
>> Read/Write
>> Streaming
>> root@android:/ # v4l2-ctl  -d 0 -l
>>                          volume (int)    : min=0 max=31 step=1
>> default=31 value=31 flags=slider
>>                            mute (bool)   : default=1 value=1
>>
>>
>> What could be wrong?
>
> Before kernel 3.10, the brightness (contrast, ...) controls are provided
> by the subdevice drivers.
> With kernel 3.10 I have introduced bridge level image controls, but they
> are currently only used/activated if the subdevice doesn't already
> provide them (as suggested by Mauro).
>
> Hth,
> Frank Schäfer
>



-- 
Regards,
Coutinho
www.phiinnovations.com
