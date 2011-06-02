Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46360 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab1FBGwx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 02:52:53 -0400
Received: by eyx24 with SMTP id 24so183530eyx.19
        for <linux-media@vger.kernel.org>; Wed, 01 Jun 2011 23:52:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <F6CCC3E5-67AF-4D22-9541-C31A91924DFE@beagleboard.org>
References: <1306942609-2440-1-git-send-email-javier.martin@vista-silicon.com>
	<1306942609-2440-2-git-send-email-javier.martin@vista-silicon.com>
	<F6CCC3E5-67AF-4D22-9541-C31A91924DFE@beagleboard.org>
Date: Thu, 2 Jun 2011 08:52:49 +0200
Message-ID: <BANLkTimDJG3xgwhKznQG0sHKKutmHQSOpw@mail.gmail.com>
Subject: Re: [beagleboard] [PATCH v6 2/2] Add support for mt9p031 sensor in
 Beagleboard XM.
From: javier Martin <javier.martin@vista-silicon.com>
To: Koen Kooi <koen@beagleboard.org>
Cc: beagleboard@googlegroups.com, linux-media@vger.kernel.org,
	g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	carlighting@yahoo.co.nz, mch_kot@yahoo.com.cn
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Koen,

On 1 June 2011 20:08, Koen Kooi <koen@beagleboard.org> wrote:
>
> Op 1 jun 2011, om 17:36 heeft Javier Martin het volgende geschreven:
>
>> New "version" and "vdd_io" flags have been added.
>>
>> A subtle change now prevents camera from being registered
>> in the wrong platform.
>
> I get a decent picture now with the following:
>
> media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> media-ctl -f '"mt9p031 2-0048":0[SGRBG12 320x240], "OMAP3 ISP CCDC":0[SGRBG8 320x240], "OMAP3 ISP CCDC":1[SGRBG8 320x240]'
>
> yavta-nc --stdout -f SGRBG8 -s 320x240 -n 4 --capture=10000 --skip 3 -F $(media-ctl -e "OMAP3 ISP CCDC output") | mplayer-bayer - -demuxer  rawvideo -rawvideo w=320:h=240:format=ba81:size=76800 -vo fbdev2 -vf ba81
>
> 720p also seems to work.
>
> It is really, really dark though. Is this due to missing controls or due to the laneshifting?

I suspect it is due to the patched mplayer.
I know this because I have enabled some custom patterns in the sensor,
thus generating pure red, blue and green pictures and they didn't seem
so when played through mplayer-bayer.

You could try the same if you want. Just to confirm.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
