Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.wa.amnet.net.au ([203.161.124.52]:42193 "EHLO
	smtp3.wa.amnet.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbbJEQDt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2015 12:03:49 -0400
From: Richard Tresidder <rtresidd@tresar-electronics.com.au>
Subject: Re: Hauppauge WinTV-HVR2205 driver feedback
To: =?UTF-8?Q?Tycho_L=c3=bcrsen?= <tycholursen@gmail.com>,
	linux-media@vger.kernel.org
References: <5610B12B.8090201@tresar-electronics.com.au>
 <561270E1.1040707@gmail.com>
Message-ID: <56129F60.4020706@tresar-electronics.com.au>
Date: Tue, 6 Oct 2015 00:03:44 +0800
MIME-Version: 1.0
In-Reply-To: <561270E1.1040707@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sigh again

Did a module only build for the i2c-mux and got it into the currently 
running kernel with a force to bypass the no symbol version for 
module_layout error.. figured it was safe enough given it was the 
identical kernel config etc from the centos vault...

Anyway still failed.. though the module seemed to install and is showing 
with lsmod no dmesg barfs..
I'll try a full kernel build tomorrow..

Regards
   Richard Tresidder



On 05/10/15 20:45, Tycho Lürsen wrote:
> Hi, not sure if this is related.
> I had to recompile the centos7 stock kernel with:
> CONFIG_I2C_MUX=m
>
> It was not enabled in the kernel config.
>
> Op 04-10-15 om 06:55 schreef Richard Tresidder:
>> Sorry If I've posted this to the wrong section my first attempt..
>>
>> Hi
>>    I'm attempting to get an HVR2205 up and going.
>> CORE saa7164[1]: subsystem: 0070:f120, board: Hauppauge WinTV-HVR2205 
>> [card=13,autodetected]
>> Distribution is CentOS7 so I've pulled the v4l from media_build.git
>> Had to change a couple of things..  and another macro issue regarding 
>> clamp() ..
>> Seems the kzalloc(4 * 1048576, GFP_KERNEL) in saa7164-fw.c  was 
>> failing..
>> kept getting:  kernel: modprobe: page allocation failure: order:10, 
>> mode:0x10c0d0
>> Have plenty of RAM free so surprised about that one.. tried some of 
>> the tricks re increasing the vm.min_free_kbytes etc..
>>
>> Any way I modified the routine to only allocate a single chunk buffer 
>> based on dstsize and tweaked the chunk handling code..
>> seemed to fix that one.. fw downloaded and seemed to boot ok..
>>
>> Next I'm running into a problem with the saa7164_dvb_register() stage...
>>
>> saa7164[1]: Hauppauge eeprom: model=151609
>> saa7164_dvb_register() Frontend/I2C initialization failed
>> saa7164_initdev() Failed to register dvb adapters on porta
>>
>> I added some extra debug and identified that client_demod->dev.driver 
>> is null..
>>
>> However I'm now stuck as to what to tackle next..
>>
>> I can provide more info, just didn't want to spam the list for my 
>> first email..
>>
>> Regards
>>    Richard Tresidder
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>

