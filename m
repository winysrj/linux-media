Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56344 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031833Ab2COUfo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 16:35:44 -0400
Message-ID: <4F62529D.5020406@iki.fi>
Date: Thu, 15 Mar 2012 22:35:41 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Keith Edmunds <kae@midnighthax.com>
CC: linux-media@vger.kernel.org
Subject: Re: cxd2820r: i2c wr failed (PCTV Nanostick 290e)
References: <20120310142042.0f238d3a@ws.the.cage> <20120315201446.17f21639@ws.the.cage>
In-Reply-To: <20120315201446.17f21639@ws.the.cage>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have no idea. IIRC this is first time I see that kind of bug report. 
Seems like EM28174 starts failing I2C messages. -110 is ETIMEDOUT and is 
likely coming from the USB-stack.

Is there anyone have seen similar situations when em28xx driver is used?

Maybe overheat?

regards
Antti


On 15.03.2012 22:14, Keith Edmunds wrote:
> I posted the message below last week, but I've had no response.
>
> Is this the wrong list? Did I do something wrong in my posting?
>
> I would like fix this problem, and I have more information now, but I
> don't want to clutter this list if it's the wrong place.
>
> Guidance as to what I should do gratefully received: thanks.
>
>> Hi List
>>
>> I'm having lots of problems with my PCTV Nanostick 290e under MythTV. Is
>> this the best place to report these problems?
>>
>> I'm happy to provide whatever detail is needed, but in summary:
>>
>>   - every day or two, I get the error messages logged below. I need to
>>     reboot the back end to clear them.
>>
>>   - when the back end comes back up, 'lsusb' doesn't show the 290e. I have
>>     to unplug it, wait a few seconds, then plug it back in again
>>
>> This is extremely frustrating. When it works, it's great; when it
>> doesn't, recordings fail.
>>
>> The following errors are reported repeatedly:
>>
>> Mar  9 10:02:03 woodlands kernel: [ 6006.157991] cxd2820r: i2c wr failed
>> ret:-110 reg:85 len:1
>> Mar  9 10:02:05 woodlands kernel: [ 6008.511994] cxd2820r: i2c wr failed
>> ret:-110 reg:00 len:1
>> Mar  9 10:02:08 woodlands kernel: [ 6011.208909] cxd2820r: i2c wr failed
>> ret:-110 reg:85 len:1
>> Mar 9 10:02:10 woodlands kernel: [ 6013.566440] cxd2820r: i2c wr failed
>> ret:-110 reg:00 len:1
>>
>> MythTV backend details:
>>   - Debian v6.0.4 ("Squeeze")
>>   - Debian multimedia repository
>>   - Myth version 0.24.2-0.0squeeze1 (as packaged by repository)
>>   - Kernel: 2.6.32-5-686-bigmem (I've also tried 3.2.0-0.bpo.1-686-pae,
>>     both Debian-packaged)
>>   - Tuners: 2 x Hauppauge Nova-T Stick (USB) and 1 x PCTV Nanostick 290e
>>     (also USB)
>>   - no module load parameters specified
>>   - tuning delay 750mS for each tuner
>>   - drivers for the 290e built using the media_build scripts
>>     (http://git.linuxtv.org/media_build.git)
>>
>> Many thanks,
>> Keith
>
>


-- 
http://palosaari.fi/
