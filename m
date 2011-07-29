Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33705 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab1G2MbN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 08:31:13 -0400
Received: by iyb12 with SMTP id 12so3950829iyb.19
        for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 05:31:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201107291214.40779.laurent.pinchart@ideasonboard.com>
References: <CACKLOr1veNZ_6E3V_m1Tf+mxxUAKiRKDbboW-fMbRGUrLns_XA@mail.gmail.com>
	<201107271951.37601.laurent.pinchart@ideasonboard.com>
	<CACKLOr1iDXcftKqw14i4K6aoxWaR7iHSv0VHbSFEJcar1L62ug@mail.gmail.com>
	<201107291214.40779.laurent.pinchart@ideasonboard.com>
Date: Fri, 29 Jul 2011 14:31:12 +0200
Message-ID: <CACKLOr3VxSDUKzgWByH-qcWeA85QvY-0jY=bAogW8JZa3=v1nw@mail.gmail.com>
Subject: Re: [PATCH] mt9p031: Aptina (Micron) MT9P031 5MP sensor driver
From: javier Martin <javier.martin@vista-silicon.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	shotty317@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All right,
it works like a charm for me.

It took me a bit to figure out that binning and skipping is controlled
through ratio between cropping window size and actual format size but
it is clear now.

Just one thing; both VFLIP (this one is my fault) and HFLIP controls
change the pixel format of the image and it no longer is GRBG.

Given the following example image:

G R G R
B G B G

If we apply VFLIP we'll have:

B G B G
G R G R

And if we apply HFLIP we'll have:

R G R G
G B G B

I am not sure how we could solve this issue, maybe through adjusting
row and column start...

In any case the driver is OK for me and the issue with VFLIP and HFLIP
could be solved later on.
Thank you.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
