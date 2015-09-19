Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:33791 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbbISVsQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Sep 2015 17:48:16 -0400
Received: by lamp12 with SMTP id p12so47364956lam.0
        for <linux-media@vger.kernel.org>; Sat, 19 Sep 2015 14:48:14 -0700 (PDT)
Subject: Re: Terratec H7 Rev. 4 is DVBSky
To: Erik Andresen <erik@vontaene.de>, linux-media@vger.kernel.org
References: <55F2ED67.3030306@vontaene.de> <55FDD604.1040003@gmail.com>
From: =?UTF-8?Q?Roger_M=c3=a5rtensson?= <roger.martensson@gmail.com>
Message-ID: <55FDD817.6090904@gmail.com>
Date: Sat, 19 Sep 2015 23:48:07 +0200
MIME-Version: 1.0
In-Reply-To: <55FDD604.1040003@gmail.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Den 2015-09-19 kl. 23:39, skrev Roger Mårtensson:
> Den 2015-09-11 kl. 17:04, skrev Erik Andresen:
>> Hi,
>>
>> I recently got a Terratec H7 in Revision 4 and turned out that it is not
>> just a new revision, but a new product with USB ProductID 0x10a5.
>> Previous revisions have been AZ6007, but this revision does not work
>> with this driver [1].
>>
>> Output of lsusb (extended output attached):
>> Bus 001 Device 011: ID 0ccd:10a5 TerraTec Electronic GmbH
>>
>> The revision 4 seems to a DVBSky variant, adding its Product ID to
>> dvbsky.c with the attached patch enabled me to scan for channels and
>> watch DVB-C and DVB-T.
>>
>> greetings,
>> Erik
>>
>> [1] 
>> https://www.mail-archive.com/linux-media@vger.kernel.org/msg70934.html
> Do I feel lucky or what..
> Just got my H7 devices delivered and noticed the lack of supported 
> driver and some quick searches gave me this e-mail.
> Maybe should take a trip to the race track. :)
>
> I have tried this driver and it works wonderfully. I have noticed a 
> freeze or two when handling the device (powering off, ripping USB etc) 
> but I'm not sure it is the driver that is causing this.
>
> I do notice something weird. The remote doesn't seem to work.
> Found /sys/class/rc/rc0/ (/dev/input/event14) with:
>         Driver dvb_usb_dvbsky, table rc-tt-1500
>         Supported protocols: RC-5
>         Enabled protocols:
>         Name: Terratec H7 Rev.4
>         bus: 3, vendor/product: 0ccd:10a5, version: 0x0000
>         Repeat delay = 500 ms, repeat period = 125 ms
>
> I'm not able to enable any protocols. Nothing happens when running 
> ir-keytable with "-p rc-5". Nothing shows in the row "Enabled 
> protocols" and nothing happens when testing with "ir-keytable -t".
>
> I've tested on a Ubuntu 14.04 (Mythbuntu) with Linux Kernel 4.2 that I 
> have to compile myself. (Don't know in which kernel dvbsky was released)
> Tested using both Kaffeine and MythTV and it works like a charm (with 
> the exception of missing IR).
> I tested using DVB-C with CI for encrypted channels
One more this..
Is there a possibility that Signal strength support could be added to 
the driver?
MythTV uses this and I think Kaffeine also uses it (not sure). Currently 
the logs are filling up with "Operation not supported".

