Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36058 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbbJKHdZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Oct 2015 03:33:25 -0400
Received: by wicgb1 with SMTP id gb1so114589189wic.1
        for <linux-media@vger.kernel.org>; Sun, 11 Oct 2015 00:33:24 -0700 (PDT)
Received: from [192.168.1.5] (52484E89.cm-4-1b.dynamic.ziggo.nl. [82.72.78.137])
        by smtp.googlemail.com with ESMTPSA id x9sm5007950wjf.44.2015.10.11.00.33.24
        for <linux-media@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Sun, 11 Oct 2015 00:33:24 -0700 (PDT)
Message-ID: <561A10C1.2090102@gmail.com>
Date: Sun, 11 Oct 2015 09:33:21 +0200
From: =?UTF-8?B?VHljaG8gTMO8cnNlbg==?= <tycholursen@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Hauppauge WinTV-HVR2205 driver feedback
References: <5610B12B.8090201@tresar-electronics.com.au> <561270E1.1040707@gmail.com> <5619FF1C.1020605@tresar-electronics.com.au>
In-Reply-To: <5619FF1C.1020605@tresar-electronics.com.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Op 11-10-15 om 08:18 schreef Richard Tresidder:
> Hi Again
>   Yep that fixed pulling in the saa7164: si2168 frontends:
>
> [ 6778.591548] i2c i2c-15: Added multiplexed i2c bus 16
> [ 6778.591556] si2168 15-0064: Silicon Labs Si2168 successfully attached
> [ 6778.596252] si2157 13-0060: Silicon Labs Si2147/2148/2157/2158
> successfully attached
> [ 6778.597229] DVB: registering new adapter (saa7164)
> YAY!!
Bottoms up!
>
> What a painful process... first time I built the kernel from the rpm
> source I must have stuffed something up and the resultant installed
> rpm didn't have the module turned on.. aaarrrrggghhhhh...
> Trying to rebuild the srpm again after tweaking the .config file and
> copying it around to the various locations again just didn't work..
> Eventually gave up and had to rip it all out and start afresh..
It's not that hard once you get the hang of it. I had to recompile 
anyway, as I need saa716x, dvbloopback and backported drivers for DVBSky 
T982, plus I need more then 8 dvb adapters. Semi-automated this of course:
https://github.com/bas-t/centos7-kernel
>
> Well spotted on that one.. What a pain that the call to the i2c mux
> create didn't result in a error :/
>
> Now I just need to shutoff kernel updates..
> Really need to push this up into the centos config.. I've noted that
> it has been turned back on in other releases..
> Will submit a bug.
Excellent idea. But as stated, I'll have to recompile anyway...
>
> Regards
>    Richard Tresidder
>
> On 05/10/15 20:45, Tycho Lürsen wrote:
>> Hi, not sure if this is related.
>> I had to recompile the centos7 stock kernel with:
>> CONFIG_I2C_MUX=m
>>
>> It was not enabled in the kernel config.
>>
>> Op 04-10-15 om 06:55 schreef Richard Tresidder:
>>> Sorry If I've posted this to the wrong section my first attempt..
>>>
>>> Hi
>>>    I'm attempting to get an HVR2205 up and going.
>>> CORE saa7164[1]: subsystem: 0070:f120, board: Hauppauge
>>> WinTV-HVR2205 [card=13,autodetected]
>>> Distribution is CentOS7 so I've pulled the v4l from media_build.git
>>> Had to change a couple of things..  and another macro issue
>>> regarding clamp() ..
>>> Seems the kzalloc(4 * 1048576, GFP_KERNEL) in saa7164-fw.c was
>>> failing..
>>> kept getting:  kernel: modprobe: page allocation failure: order:10,
>>> mode:0x10c0d0
>>> Have plenty of RAM free so surprised about that one.. tried some of
>>> the tricks re increasing the vm.min_free_kbytes etc..
>>>
>>> Any way I modified the routine to only allocate a single chunk
>>> buffer based on dstsize and tweaked the chunk handling code..
>>> seemed to fix that one.. fw downloaded and seemed to boot ok..
>>>
>>> Next I'm running into a problem with the saa7164_dvb_register()
>>> stage...
>>>
>>> saa7164[1]: Hauppauge eeprom: model=151609
>>> saa7164_dvb_register() Frontend/I2C initialization failed
>>> saa7164_initdev() Failed to register dvb adapters on porta
>>>
>>> I added some extra debug and identified that
>>> client_demod->dev.driver is null..
>>>
>>> However I'm now stuck as to what to tackle next..
>>>
>>> I can provide more info, just didn't want to spam the list for my
>>> first email..
>>>
>>> Regards
>>>    Richard Tresidder
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>

