Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56454 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbaIXTSx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 15:18:53 -0400
Message-ID: <5423190F.1040904@iki.fi>
Date: Wed, 24 Sep 2014 22:18:39 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Bimow.Chen@ite.com.tw, mchehab@osg.samsung.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] V4L/DVB: Add sleep for firmware ready
References: <20140923085039.51765665@recife.lan>	<542160F0.1000407@iki.fi> <20140923101103.224370bb@recife.lan> <FA28ACF9E7378C4E836BE776152E0E253AF5D5FF@TPEMAIL2.internal.ite.com.tw>
In-Reply-To: <FA28ACF9E7378C4E836BE776152E0E253AF5D5FF@TPEMAIL2.internal.ite.com.tw>
Content-Type: text/plain; charset=big5
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After looking it again, the 10ms delay seen in sniff is between boot
request and reply. Looks like it took 10ms from chip to reply boot
command. But there is no any other delays before nor after booth
command. If some small extra delay is really needed for Linux, but not
Windows, it indicates linux USB stack or driver is more optimal having
less delays.

regards
Antti

On 09/24/2014 06:47 AM, Bimow.Chen@ite.com.tw wrote:
> Hi all,
> 
> It's my mistake. Sleep after boot for firmware ready, not before.
> Please reject this patch.
> Thank you.
> 
> Best regards,
> Bimow
> -----Original Message-----
> From: Mauro Carvalho Chehab [mailto:mchehab@osg.samsung.com]
> Sent: Tuesday, September 23, 2014 9:11 PM
> To: Antti Palosaari
> Cc: linux-media@vger.kernel.org; Bimow Chen (³¯¤ßÀ·)
> Subject: Re: [PATCH 4/4] V4L/DVB: Add sleep for firmware ready
> 
> Em Tue, 23 Sep 2014 15:00:48 +0300
> Antti Palosaari <crope@iki.fi> escreveu:
> 
>> I am not sure as I cannot reproduce it. Also 30ms wait here is long as
>> hell, whilst it is not critical.
>>
>> When I look that firmware downloading from the 1-2 month old Hauppauge
>> driver sniffs, it is not there:
>>
>> That line is CMD_FW_BOOT, command 0x23 it is 3rd number:
>> #define CMD_FW_BOOT                 0x23
>> 000313:  OUT: 000000 ms 001490 ms BULK[00002] >>> 05 00 23 9a 65 dc
>>
>> Here is whole sequence:
>> 000311:  OUT: 000000 ms 001489 ms BULK[00002] >>> 15 00 29 99 03 01 00
>> 01 57 f7 09 02 6d 6c 02 4f 9f 02 4f a2 0b 16
>> 000312:  OUT: 000001 ms 001489 ms BULK[00081] <<< 04 99 00 66 ff
>> 000313:  OUT: 000000 ms 001490 ms BULK[00002] >>> 05 00 23 9a 65 dc
>> 000314:  OUT: 000011 ms 001490 ms BULK[00081] <<< 04 9a 00 65 ff
>> 000315:  OUT: 000000 ms 001501 ms BULK[00002] >>> 0b 00 00 9b 01 02 00
>> 00 12 22 40 ec
>> 000316:  OUT: 000000 ms 001501 ms BULK[00081] <<< 05 9b 00 02 62 ff
>>
>>
>> So windows driver waits 10ms after boot, not before.
>>
>> Due to these reasons, I would like to skip that patch until I see
>> error or get good explanation why it is needed and so.
> 
> Ok. I'll tag it as RFC then.
> 
>>
>>
>> regards
>> Antti
>>
>>
>> On 09/23/2014 02:50 PM, Mauro Carvalho Chehab wrote:
>>> Antti,
>>>
>>> After the firmware load changes, is this patch still applicable?
>>>
>>> Regards,
>>> Mauro
>>>
>>> Forwarded message:
>>>
>>> Date: Tue, 05 Aug 2014 13:48:03 +0800
>>> From: Bimow Chen <Bimow.Chen@ite.com.tw>
>>> To: linux-media@vger.kernel.org
>>> Subject: [PATCH 4/4] V4L/DVB: Add sleep for firmware ready
>>>
>>>
>>>   From b19fa868ce937a6ef10f1591a49b2a7ad14964a9 Mon Sep 17 00:00:00
>>> 2001
>>> From: Bimow Chen <Bimow.Chen@ite.com.tw>
>>> Date: Tue, 5 Aug 2014 11:20:53 +0800
>>> Subject: [PATCH 4/4] Add sleep for firmware ready.
>>>
>>>
>>> Signed-off-by: Bimow Chen <Bimow.Chen@ite.com.tw>
>>> ---
>>>    drivers/media/usb/dvb-usb-v2/af9035.c |    2 ++
>>>    1 files changed, 2 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c
>>> b/drivers/media/usb/dvb-usb-v2/af9035.c
>>> index 7b9b75f..a450cdb 100644
>>> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
>>> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
>>> @@ -602,6 +602,8 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
>>>    	if (ret < 0)
>>>    		goto err;
>>>
>>> +	msleep(30);
>>> +
>>>    	/* firmware loaded, request boot */
>>>    	req.cmd = CMD_FW_BOOT;
>>>    	ret = af9035_ctrl_msg(d, &req);
>>>
>>

-- 
http://palosaari.fi/
