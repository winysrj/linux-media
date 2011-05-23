Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33141 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab1EWGyu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 02:54:50 -0400
Received: by iyb14 with SMTP id 14so4413402iyb.19
        for <linux-media@vger.kernel.org>; Sun, 22 May 2011 23:54:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <180987.84653.qm@web112003.mail.gq1.yahoo.com>
References: <180987.84653.qm@web112003.mail.gq1.yahoo.com>
Date: Mon, 23 May 2011 08:54:49 +0200
Message-ID: <BANLkTim2gdVEwLO5P4XgMueCKHFp_1KZag@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] MT9P031: Add support for Aptina mt9p031 sensor.
From: javier Martin <javier.martin@vista-silicon.com>
To: Chris Rodley <carlighting@yahoo.co.nz>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 23 May 2011 05:01, Chris Rodley <carlighting@yahoo.co.nz> wrote:
> Error when using media-ctl as below with v2 mt9p031 driver from Javier and latest media-ctl version.
> Is there a patch I missed to add different formats - or maybe my command is wrong?
>
> # ./media-ctl -v -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> Opening media device /dev/media0
> Enumerating entities
> Found 16 entities
> Enumerating pads and links
> Resetting all links to inactive
> Setting up link 16:0 -> 5:0 [1]
> Setting up link 5:1 -> 6:0 [1]
>
> # ./media-ctl -v -f '"mt9p031 2-0048":0[SGRBG8 320x240], "OMAP3 ISP CCDC":1[SGRBG8 320x240]'
> Opening media device /dev/media0
> Enumerating entities
> Found 16 entities
> Enumerating pads and links
> Setting up format SGRBG8 320x240 on pad mt9p031 2-0048/0
> Unable to set format: Invalid argument (-22)
>
> I also tried:
> ./media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> ./media-ctl -f '"mt9p031 2-0048":0[SGRBG10 752x480 (1,5)/752x480], "OMAP3 ISP CCDC":0[SGRBG8 752x480], "OMAP3 ISP CCDC":1[SGRBG8 752x480]'
>
> With the same result.
>
> Cheers,
> Chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Please, try the following:

./media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3
ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
./media-ctl -f '"mt9p031 2-0048":0[SGRBG12 320x240], "OMAP3 ISP
CCDC":0[SGRBG8 320x240], "OMAP3 ISP CCDC":1[SGRBG8 320x240]'

Thanks.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
