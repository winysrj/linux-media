Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43502 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932682Ab1FBKLn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 06:11:43 -0400
Received: by ewy4 with SMTP id 4so222952ewy.19
        for <linux-media@vger.kernel.org>; Thu, 02 Jun 2011 03:11:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1106020946030.4067@axis700.grange>
References: <1306942609-2440-1-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1106020946030.4067@axis700.grange>
Date: Thu, 2 Jun 2011 12:11:40 +0200
Message-ID: <BANLkTimMrUm58CN6W56N+MR9pKbzZS0DAQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] Add driver for Aptina (Micron) mt9p031 sensor.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	carlighting@yahoo.co.nz, beagleboard@googlegroups.com,
	mch_kot@yahoo.com.cn
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

OK Guennadi,
I'll fix those cosmetics issues in my next version where I will add
VFLIP and HFLIP control support (which I removed previously to make
the code less complex).

Now we talk about controls I have a question regarding controls
defined in video subdevices like mt9p031 or mt9v032:

What device node should I use to set these controls through an ioctl() ?
For instance, with mt9p031 + Beagleboard xM we have:

./media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3
ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
./media-ctl -f '"mt9p031 2-0048":0[SGRBG12 320x240], "OMAP3 ISP
CCDC":0[SGRBG8 320x240], "OMAP3 ISP CCDC":1[SGRBG8 320x240]'
./yavta --stdout -f SGRBG8 -s 320x240 -n 4 --capture=100 --skip 3 -F
`./media-ctl -e "OMAP3 ISP CCDC output"` | nc 192.168.0.42 3000

Where

root@beagleboard:~# ./media-ctl -e "OMAP3 ISP CCDC output"
/dev/video2

However, if I try to set sensor controls using /dev/video2 I get an
error (invalid argument).

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
