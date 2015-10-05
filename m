Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:38657 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbbJEMpW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2015 08:45:22 -0400
Received: by wiclk2 with SMTP id lk2so112791763wic.1
        for <linux-media@vger.kernel.org>; Mon, 05 Oct 2015 05:45:20 -0700 (PDT)
Message-ID: <561270E1.1040707@gmail.com>
Date: Mon, 05 Oct 2015 14:45:21 +0200
From: =?UTF-8?B?VHljaG8gTMO8cnNlbg==?= <tycholursen@gmail.com>
MIME-Version: 1.0
To: Richard Tresidder <rtresidd@tresar-electronics.com.au>,
	linux-media@vger.kernel.org
Subject: Re: Hauppauge WinTV-HVR2205 driver feedback
References: <5610B12B.8090201@tresar-electronics.com.au>
In-Reply-To: <5610B12B.8090201@tresar-electronics.com.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, not sure if this is related.
I had to recompile the centos7 stock kernel with:
CONFIG_I2C_MUX=m

It was not enabled in the kernel config.

Op 04-10-15 om 06:55 schreef Richard Tresidder:
> Sorry If I've posted this to the wrong section my first attempt..
>
> Hi
>    I'm attempting to get an HVR2205 up and going.
> CORE saa7164[1]: subsystem: 0070:f120, board: Hauppauge WinTV-HVR2205 
> [card=13,autodetected]
> Distribution is CentOS7 so I've pulled the v4l from media_build.git
> Had to change a couple of things..  and another macro issue regarding 
> clamp() ..
> Seems the kzalloc(4 * 1048576, GFP_KERNEL) in saa7164-fw.c  was failing..
> kept getting:  kernel: modprobe: page allocation failure: order:10, 
> mode:0x10c0d0
> Have plenty of RAM free so surprised about that one.. tried some of 
> the tricks re increasing the vm.min_free_kbytes etc..
>
> Any way I modified the routine to only allocate a single chunk buffer 
> based on dstsize and tweaked the chunk handling code..
> seemed to fix that one.. fw downloaded and seemed to boot ok..
>
> Next I'm running into a problem with the saa7164_dvb_register() stage...
>
> saa7164[1]: Hauppauge eeprom: model=151609
> saa7164_dvb_register() Frontend/I2C initialization failed
> saa7164_initdev() Failed to register dvb adapters on porta
>
> I added some extra debug and identified that client_demod->dev.driver 
> is null..
>
> However I'm now stuck as to what to tackle next..
>
> I can provide more info, just didn't want to spam the list for my 
> first email..
>
> Regards
>    Richard Tresidder
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

