Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54955 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab1ASQFm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 11:05:42 -0500
Received: by iyj18 with SMTP id 18so971464iyj.19
        for <linux-media@vger.kernel.org>; Wed, 19 Jan 2011 08:05:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110110021439.GA70495@io.frii.com>
References: <20101207190753.GA21666@io.frii.com>
	<20110110021439.GA70495@io.frii.com>
Date: Wed, 19 Jan 2011 07:59:13 -0800
Message-ID: <AANLkTingFP9ajGckXXy2wScHHGxhz+KTyOBa-mE7SUs5@mail.gmail.com>
Subject: Re: DViCO FusionHDTV7 Dual Express I2C write failed
From: VDR User <user.vdr@gmail.com>
To: Mark Zimmerman <markzimm@frii.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Jan 9, 2011 at 6:14 PM, Mark Zimmerman <markzimm@frii.com> wrote:
>> I have a DViCO FusionHDTV7 Dual Express card that works with 2.6.35 but
>> which fails to initialize with the latest 2.6.36 kernel. The firmware
>> fails to load due to an i2c failure. A search of the archives indicates
>> that this is not the first time this issue has occurred.
>>
>> What can I do to help get this problem fixed?
>>
>> Here is the dmesg from 2.6.35, for the two tuners:
>>
>> xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
>> xc5000: firmware read 12401 bytes.
>> xc5000: firmware uploading...
>> xc5000: firmware upload complete...
>> xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
>> xc5000: firmware read 12401 bytes.
>> xc5000: firmware uploading...
>> xc5000: firmware upload complete..
>>
>> and here is what happens with 2.6.36:
>>
>> xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
>> xc5000: firmware read 12401 bytes.
>> xc5000: firmware uploading...
>> xc5000: I2C write failed (len=3)
>> xc5000: firmware upload complete...
>> xc5000: Unable to initialise tuner
>> xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
>> xc5000: firmware read 12401 bytes.
>> xc5000: firmware uploading...
>> xc5000: I2C write failed (len=3)
>> xc5000: firmware upload complete...
>>
>
> More information about this: I tried 2.6.37 (vanilla source from
> kernel.org) and the problem persisted. So, I enabled these options:
> CONFIG_I2C_DEBUG_CORE=y
> CONFIG_I2C_DEBUG_ALGO=y
> CONFIG_I2C_DEBUG_BUS=y
> hoping to get more information but this time the firmware loaded
> successfully and the tuner works properly.
>
> This leads me to suspect a race condition somewhere, or maybe a
> tunable parameter that can be adjusted. The fact that the 'write
> failed' message occurs before the 'upload complete' message would tend
> to support this. Can anyone suggest something I might try?

Can someone please look into this and possibly provide a fix for the
bug?  I'm surprised it hasn't happened yet after all this time but
maybe it's been forgotten the bug existed.

Thanks.
