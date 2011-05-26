Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65346 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094Ab1EZJkb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 05:40:31 -0400
Received: by wwa36 with SMTP id 36so553748wwa.1
        for <linux-media@vger.kernel.org>; Thu, 26 May 2011 02:40:30 -0700 (PDT)
Subject: Re: [beagleboard] [PATCH] Second RFC version of mt9p031 sensor with power managament.
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Koen Kooi <koen@beagleboard.org>
In-Reply-To: <BANLkTikon2uw4DWcsXLCnLD1crfbV7HP_Q@mail.gmail.com>
Date: Thu, 26 May 2011 11:40:27 +0200
Cc: beagleboard@googlegroups.com, linux-media@vger.kernel.org,
	g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	carlighting@yahoo.co.nz
Content-Transfer-Encoding: 8BIT
Message-Id: <D9AEF5C4-C0FE-4CBA-B124-0C3C0EC4F5EA@beagleboard.org>
References: <1306322212-26879-1-git-send-email-javier.martin@vista-silicon.com> <F50AF7E4-DCBA-4FC9-971A-ADF01F342FEF@beagleboard.org> <BANLkTiksN_+12hdQFOQ9+bS5LBU+QSR4cA@mail.gmail.com> <07EF42D6-0587-4F35-8431-E03B9994F9B5@beagleboard.org> <BANLkTikon2uw4DWcsXLCnLD1crfbV7HP_Q@mail.gmail.com>
To: javier Martin <javier.martin@vista-silicon.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Op 26 mei 2011, om 11:27 heeft javier Martin het volgende geschreven:

> On 26 May 2011 10:51, Koen Kooi <koen@beagleboard.org> wrote:
>> 
>> Op 26 mei 2011, om 09:24 heeft Javier Martin het volgende geschreven:
>> 
>>> Hi Koen,
>>> 
>>> On 25 May 2011 15:38, Koen Kooi <koen@beagleboard.org> wrote:
>>>> 
>>>> Op 25 mei 2011, om 13:16 heeft Javier Martin het volgende geschreven:
>>>> 
>>>>> It includes several fixes pointed out by Laurent Pinchart. However,
>>>>> the BUG which shows artifacts in the image (horizontal lines) still
>>>>> persists. It won't happen if 1v8 regulator is not disabled (i.e.
>>>>> comment line where it is disabled in function "mt9p031_power_off").
>>>>> I know there can be some other details to fix but I would like someone
>>>>> could help in the power management issue.
>>>> 
>>>> I tried this + your beagle patch on 2.6.39 and both ISP and sensor being builtin to the kernel, I get the following:
>>>> 
>>>> root@beagleboardxMC:~# media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1 ], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
>>>> Resetting all links to inactive
>>>> Setting up link 16:0 -> 5:0 [1]
>>>> Setting up link 5:1 -> 6:0 [1]
>>>> 
>>>> root@beagleboardxMC:~# media-ctl -f '"mt9p031 2-0048":0[SGRBG12 320x240], "OMAP3  ISP CCDC":0[SGRBG8 320x240], "OMAP3 ISP CCDC":1[SGRBG8 320x240]'
>>>> Setting up format SGRBG12 320x240 on pad mt9p031 2-0048/0
>>>> Format set: SGRBG12 320x240
>>>> Setting up format SGRBG12 320x240 on pad OMAP3 ISP CCDC/0
>>>> Format set: SGRBG12 320x240
>>>> Setting up format SGRBG8 320x240 on pad OMAP3 ISP CCDC/0
>>>> Format set: SGRBG8 320x240
>>>> Setting up format SGRBG8 320x240 on pad OMAP3 ISP CCDC/1
>>>> Format set: SGRBG8 320x240
>>>> 
>>>> oot@beagleboardxMC:~# yavta -f SGRBG8 -s 320x240 -n 4 --capture=10 --skip 3 -F  `media-ctl -e "OMAP3 ISP CCDC output"`
>>>> Device /dev/video2 opened.
>>>> Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
>>>> Video format set: SGRBG8 (47425247) 320x240 buffer size 76800
>>>> Video format: SGRBG8 (47425247) 320x240 buffer size 76800
>>>> 4 buffers requested.
>>>> length: 76800 offset: 0
>>>> Buffer 0 mapped at address 0x4030d000.
>>>> length: 76800 offset: 77824
>>>> Buffer 1 mapped at address 0x40330000.
>>>> length: 76800 offset: 155648
>>>> Buffer 2 mapped at address 0x4042d000.
>>>> length: 76800 offset: 233472
>>>> Buffer 3 mapped at address 0x40502000.
>>>> [ 4131.459930] omap3isp omap3isp: CCDC won't become idle!
>>> 
>>> Please, test it again using new RFC v3 I've just submitted.
>> 
>> Slightly better:
>> 
>> Video format: SGRBG8 (47425247) 320x240 buffer size 76800
>> 4 buffers requested.
>> length: 76800 offset: 0
>> Buffer 0 mapped at address 0x401d1000.
>> length: 76800 offset: 77824
>> Buffer 1 mapped at address 0x40266000.
>> length: 76800 offset: 155648
>> Buffer 2 mapped at address 0x402c6000.
>> length: 76800 offset: 233472
>> Buffer 3 mapped at address 0x4036e000.
>> 0 (0) [-] 4294967295 76800 bytes 110.899139 1306398890.364593 0.001 fps
>> 1 (1) [-] 4294967295 76800 bytes 111.128997 1306398890.594421 4.351 fps
>> [  111.214019] omap3isp omap3isp: CCDC won't become idle!
>> 
>> 
>>> I have personally tested it against kernel 2.6.39 with the following
>>> .config file:
>> 
>> And with that config:
>> 
>> [    4.250244] VFS: Cannot open root device "mmcblk0p2" or unknown-block(179,2)
>> [    4.257720] Please append a correct "root=" boot option; here are the available partitions:
>> [    4.266540] b300         7977472 mmcblk0  driver: mmcblk
>> [    4.272125]   b301           72261 mmcblk0p1 00000000-0000-0000-0000-000000000mmcblk0p1
>> [    4.280578]   b302         7903980 mmcblk0p2 00000000-0000-0000-0000-000000000mmcblk0p2
>> [    4.289031] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(179,2)
>> 
>> Which is the good old kernel-mux-is-broken problem again, after turning off kernel-mux:
>> 
>> 0 (0) [-] 4294967295 76800 bytes 29.186920 1306399517.283752 0.001 fps
>> 1 (1) [-] 4294967295 76800 bytes 29.416778 1306399517.513580 4.351 fps
>> 2 (2) [-] 4294967295 76800 bytes 29.528137 1306399517.624938 8.980 fps
>> [   29.616943] omap3isp omap3isp: CCDC won't become idle!
>> 
> 
> Are you using a LI-5M03 module?
> (https://www.leopardimaging.com/Beagle_Board_xM_Camera.html)

Yes, I also have the vga and 3M module to test with.

> I also added pull ups to the I2C2 line so that I could communicate with mt9p031.

Uboot enables the on-chip pullups, which worked for me when using the 2.6.32 kernel.

>> So that seems to be the same as with my config. How do I view the files yavta dumps?
> 
> I use a patched version of yavta and Mplayer to see video
> (http://download.open-technology.de/BeagleBoard_xM-MT9P031/)
> 
> Then in my PC:
> nc -l 3000 | ./mplayer - -demuxer rawvideo -rawvideo
> w=320:h=240:format=ba81:size=76800 -vf ba81 -vo x11
> 
> In the Beagleboard:
> 
> ./media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3
> ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> ./media-ctl -f '"mt9p031 2-0048":0[SGRBG12 320x240], "OMAP3 ISP
> CCDC":0[SGRBG8 320x240], "OMAP3 ISP CCDC":1[SGRBG8 320x240]'
> ./yavta --stdout -f SGRBG8 -s 320x240 -n 4 --capture=100 --skip 3 -F
> `./media-ctl -e "OMAP3 ISP CCDC output"` | nc 192.168.0.42 3000

I'll give that a try later today.

regards,

Koen

> 
> 
> -- 
> Javier Martin
> Vista Silicon S.L.
> CDTUC - FASE C - Oficina S-345
> Avda de los Castros s/n
> 39005- Santander. Cantabria. Spain
> +34 942 25 32 60
> www.vista-silicon.com

