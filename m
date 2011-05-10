Return-path: <mchehab@gaivota>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43854 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab1EJJtL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 May 2011 05:49:11 -0400
Received: by gwaa18 with SMTP id a18so2071444gwa.19
        for <linux-media@vger.kernel.org>; Tue, 10 May 2011 02:49:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201105101132.11041.laurent.pinchart@ideasonboard.com>
References: <BANLkTi=pS07RymXLOFsRihd5Jso-y6OsHg@mail.gmail.com>
	<201105051855.32405.laurent.pinchart@ideasonboard.com>
	<BANLkTimhvxzn0cfZdAMYq=3Eg72eKgFx8Q@mail.gmail.com>
	<201105101132.11041.laurent.pinchart@ideasonboard.com>
Date: Tue, 10 May 2011 11:49:10 +0200
Message-ID: <BANLkTimLhOJstjpbxLSxS-qNPYhbfGxUNw@mail.gmail.com>
Subject: Re: Current status report of mt9p031.
From: javier Martin <javier.martin@vista-silicon.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Chris Rodley <carlighting@yahoo.co.nz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

> Please try replacing the media-ctl -f line with
>
> ./media-ctl -f '"mt9p031 2-0048":0[SGRBG12 320x240], \
>        "OMAP3 ISP CCDC":0[SGRBG8 320x240], \
>        "OMAP3 ISP CCDC":1[SGRBG8 320x240]'
>
> --
> Regards,
>
> Laurent Pinchart
>

Hi Laurent,
that didn't work either (Unable to start streaming: 32.)

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
