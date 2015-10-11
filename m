Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.wa.amnet.net.au ([203.161.124.52]:37679 "EHLO
	smtp3.wa.amnet.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbbJKGSO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Oct 2015 02:18:14 -0400
Subject: Re: Hauppauge WinTV-HVR2205 driver feedback
To: =?UTF-8?Q?Tycho_L=c3=bcrsen?= <tycholursen@gmail.com>,
	linux-media@vger.kernel.org
References: <5610B12B.8090201@tresar-electronics.com.au>
 <561270E1.1040707@gmail.com>
From: Richard Tresidder <rtresidd@tresar-electronics.com.au>
Message-ID: <5619FF1C.1020605@tresar-electronics.com.au>
Date: Sun, 11 Oct 2015 14:18:04 +0800
MIME-Version: 1.0
In-Reply-To: <561270E1.1040707@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Again
   Yep that fixed pulling in the saa7164: si2168 frontends:

[ 6778.591548] i2c i2c-15: Added multiplexed i2c bus 16
[ 6778.591556] si2168 15-0064: Silicon Labs Si2168 successfully attached
[ 6778.596252] si2157 13-0060: Silicon Labs Si2147/2148/2157/2158 
successfully attached
[ 6778.597229] DVB: registering new adapter (saa7164)
YAY!!

What a painful process... first time I built the kernel from the rpm 
source I must have stuffed something up and the resultant installed rpm 
didn't have the module turned on.. aaarrrrggghhhhh...
Trying to rebuild the srpm again after tweaking the .config file and 
copying it around to the various locations again just didn't work.. 
Eventually gave up and had to rip it all out and start afresh..

Well spotted on that one.. What a pain that the call to the i2c mux 
create didn't result in a error :/

Now I just need to shutoff kernel updates..
Really need to push this up into the centos config.. I've noted that it 
has been turned back on in other releases..
Will submit a bug.

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

