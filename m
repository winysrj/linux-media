Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:65430 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab1EaNm0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 09:42:26 -0400
Received: by ewy4 with SMTP id 4so1623581ewy.19
        for <linux-media@vger.kernel.org>; Tue, 31 May 2011 06:42:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3F25E36F-2420-4D9A-BF5E-77278EB3E238@beagleboard.org>
References: <1306835210-1345-1-git-send-email-javier.martin@vista-silicon.com>
	<1306835210-1345-2-git-send-email-javier.martin@vista-silicon.com>
	<3F25E36F-2420-4D9A-BF5E-77278EB3E238@beagleboard.org>
Date: Tue, 31 May 2011 15:42:25 +0200
Message-ID: <BANLkTimNe8C73PEiP+LC+4tQhjJuixwdvQ@mail.gmail.com>
Subject: Re: [beagleboard] [PATCH v5 2/2] Add support for mt9p031 (LI-5M03
 module) in Beagleboard xM.
From: javier Martin <javier.martin@vista-silicon.com>
To: Koen Kooi <koen@beagleboard.org>
Cc: beagleboard@googlegroups.com, linux-media@vger.kernel.org,
	g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	carlighting@yahoo.co.nz, mch_kot@yahoo.com.cn
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 31 May 2011 15:34, Koen Kooi <koen@beagleboard.org> wrote:
> root@beagleboardxMC:~# yavta -f SGRBG8 -s 320x240 -n 4 --capture=10 --skip 3 -F `media-ctl -e "OMAP3 ISP CCDC output"`
> Device /dev/video2 opened.
> Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
> Video format set: SGRBG8 (47425247) 320x240 buffer size 76800
> Video format: SGRBG8 (47425247) 320x240 buffer size 76800
> 4 buffers requested.
> length: 76800 offset: 0
> Buffer 0 mapped at address 0x402cf000.
> length: 76800 offset: 77824
> Buffer 1 mapped at address 0x402fe000.
> length: 76800 offset: 155648
> Buffer 2 mapped at address 0x40362000.
> length: 76800 offset: 233472
> Buffer 3 mapped at address 0x40416000.
> 0 (0) [-] 4294967295 76800 bytes 167.403289 1306829219.931121 0.002 fps
> 1 (1) [-] 4294967295 76800 bytes 167.633148 1306829220.160980 4.350 fps
> 2 (2) [-] 4294967295 76800 bytes 167.744506 1306829220.272308 8.980 fps
> 3 (3) [-] 4294967295 76800 bytes 167.855865 1306829220.383667 8.980 fps
> 4 (0) [-] 4294967295 76800 bytes 167.967193 1306829220.495025 8.982 fps
> 5 (1) [-] 4294967295 76800 bytes 168.078552 1306829220.606384 8.980 fps
> 6 (2) [-] 4294967295 76800 bytes 168.189910 1306829220.717742 8.980 fps
> 7 (3) [-] 4294967295 76800 bytes 168.301269 1306829220.829071 8.980 fps
> 8 (0) [-] 4294967295 76800 bytes 168.412597 1306829220.940429 8.982 fps
> 9 (1) [-] 4294967295 76800 bytes 168.523956 1306829221.051788 8.980 fps
> Captured 10 frames in 1.254212 seconds (7.973134 fps, 612336.670356 B/s).
> 4 buffers released.
>
> So that seems to be working! I haven't checked the frames yet, but is isn't throwing ISP errors anymore.

Great!
Do you have a monochrome version of the same sensor?

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
