Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43587 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab1EaOBN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 10:01:13 -0400
Received: by wya21 with SMTP id 21so3324757wya.19
        for <linux-media@vger.kernel.org>; Tue, 31 May 2011 07:01:12 -0700 (PDT)
Subject: Re: [beagleboard] [PATCH v5 2/2] Add support for mt9p031 (LI-5M03 module) in Beagleboard xM.
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Koen Kooi <koen@beagleboard.org>
In-Reply-To: <BANLkTimNe8C73PEiP+LC+4tQhjJuixwdvQ@mail.gmail.com>
Date: Tue, 31 May 2011 16:01:09 +0200
Cc: beagleboard@googlegroups.com, linux-media@vger.kernel.org,
	g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	carlighting@yahoo.co.nz, mch_kot@yahoo.com.cn
Content-Transfer-Encoding: 8BIT
Message-Id: <6BEF1726-768F-45DC-BB9D-7D63127833B9@beagleboard.org>
References: <1306835210-1345-1-git-send-email-javier.martin@vista-silicon.com> <1306835210-1345-2-git-send-email-javier.martin@vista-silicon.com> <3F25E36F-2420-4D9A-BF5E-77278EB3E238@beagleboard.org> <BANLkTimNe8C73PEiP+LC+4tQhjJuixwdvQ@mail.gmail.com>
To: javier Martin <javier.martin@vista-silicon.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Op 31 mei 2011, om 15:42 heeft javier Martin het volgende geschreven:

> On 31 May 2011 15:34, Koen Kooi <koen@beagleboard.org> wrote:
>> root@beagleboardxMC:~# yavta -f SGRBG8 -s 320x240 -n 4 --capture=10 --skip 3 -F `media-ctl -e "OMAP3 ISP CCDC output"`
>> Device /dev/video2 opened.
>> Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
>> Video format set: SGRBG8 (47425247) 320x240 buffer size 76800
>> Video format: SGRBG8 (47425247) 320x240 buffer size 76800
>> 4 buffers requested.
>> length: 76800 offset: 0
>> Buffer 0 mapped at address 0x402cf000.
>> length: 76800 offset: 77824
>> Buffer 1 mapped at address 0x402fe000.
>> length: 76800 offset: 155648
>> Buffer 2 mapped at address 0x40362000.
>> length: 76800 offset: 233472
>> Buffer 3 mapped at address 0x40416000.
>> 0 (0) [-] 4294967295 76800 bytes 167.403289 1306829219.931121 0.002 fps
>> 1 (1) [-] 4294967295 76800 bytes 167.633148 1306829220.160980 4.350 fps
>> 2 (2) [-] 4294967295 76800 bytes 167.744506 1306829220.272308 8.980 fps
>> 3 (3) [-] 4294967295 76800 bytes 167.855865 1306829220.383667 8.980 fps
>> 4 (0) [-] 4294967295 76800 bytes 167.967193 1306829220.495025 8.982 fps
>> 5 (1) [-] 4294967295 76800 bytes 168.078552 1306829220.606384 8.980 fps
>> 6 (2) [-] 4294967295 76800 bytes 168.189910 1306829220.717742 8.980 fps
>> 7 (3) [-] 4294967295 76800 bytes 168.301269 1306829220.829071 8.980 fps
>> 8 (0) [-] 4294967295 76800 bytes 168.412597 1306829220.940429 8.982 fps
>> 9 (1) [-] 4294967295 76800 bytes 168.523956 1306829221.051788 8.980 fps
>> Captured 10 frames in 1.254212 seconds (7.973134 fps, 612336.670356 B/s).
>> 4 buffers released.
>> 
>> So that seems to be working! I haven't checked the frames yet, but is isn't throwing ISP errors anymore.
> 
> Great!
> Do you have a monochrome version of the same sensor?

I think I only have the colour version, I got it with my leopard355 board way back. 

So what can I do with an unpatched mediactl and unpatched yavta? Is it already possible to point something like mplayer or gstreamer to a v4l2 node and see something? I lost the track of which patch goes where :)

regards,

Koen