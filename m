Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62298 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932803Ab1FBKqv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 06:46:51 -0400
Received: by eyx24 with SMTP id 24so233248eyx.19
        for <linux-media@vger.kernel.org>; Thu, 02 Jun 2011 03:46:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1106021233560.4067@axis700.grange>
References: <1306942609-2440-1-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1106020946030.4067@axis700.grange>
	<BANLkTimMrUm58CN6W56N+MR9pKbzZS0DAQ@mail.gmail.com>
	<Pine.LNX.4.64.1106021233560.4067@axis700.grange>
Date: Thu, 2 Jun 2011 12:46:48 +0200
Message-ID: <BANLkTint422Yg5_sHU4D7LGQW7vb+wbYUQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] Add driver for Aptina (Micron) mt9p031 sensor.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	carlighting@yahoo.co.nz, beagleboard@googlegroups.com,
	mch_kot@yahoo.com.cn
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 2 June 2011 12:36, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> On Thu, 2 Jun 2011, javier Martin wrote:
>
>> OK Guennadi,
>> I'll fix those cosmetics issues in my next version where I will add
>> VFLIP and HFLIP control support (which I removed previously to make
>> the code less complex).
>
> Please, don't. Let's first get the simple version of your driver in the
> mainline, then it can be extended. Just, please, make sure to address all
> remaining issues without changing anything else:)

Ok, thanks.


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
