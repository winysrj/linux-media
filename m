Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:46804 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab3ABMfd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 07:35:33 -0500
Received: by mail-we0-f177.google.com with SMTP id x48so6635832wey.22
        for <linux-media@vger.kernel.org>; Wed, 02 Jan 2013 04:35:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOMZO5ACPWoM_SoDCf5JrU1iVt=qXOZz15r0H-Bkt1GLPY04mw@mail.gmail.com>
References: <1351599395-16833-1-git-send-email-javier.martin@vista-silicon.com>
	<1351599395-16833-2-git-send-email-javier.martin@vista-silicon.com>
	<CAOMZO5C0yvvXs38B4zt46zsjphif-tg=FoEjBeoLx7iQUut62Q@mail.gmail.com>
	<Pine.LNX.4.64.1210301327090.29432@axis700.grange>
	<CACKLOr0r2w-=f=PUU-s7x302Jvp3urBZcRQa3pjArZYx0BSjtg@mail.gmail.com>
	<Pine.LNX.4.64.1210301547300.29432@axis700.grange>
	<CAOMZO5CbGz_OW6tx1gAGDrhrS4Mp4f4UrdvLVFS+sh4UVTG46A@mail.gmail.com>
	<CACKLOr1sn8E8qGJm1KriEEzPtFOH+2JXdpywY7o4yXe4vWQp2Q@mail.gmail.com>
	<CAOMZO5ACPWoM_SoDCf5JrU1iVt=qXOZz15r0H-Bkt1GLPY04mw@mail.gmail.com>
Date: Wed, 2 Jan 2013 13:35:32 +0100
Message-ID: <CACKLOr2DB4-ag7v=csVySeeff9tRV7-_yRNwS6vHht9s6CL45g@mail.gmail.com>
Subject: Re: [PATCH 1/4] media: mx2_camera: Remove i.mx25 support.
From: javier Martin <javier.martin@vista-silicon.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, fabio.estevam@freescale.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

On 2 January 2013 13:25, Fabio Estevam <festevam@gmail.com> wrote:
> Hi Javier,
>
> On Wed, Jan 2, 2013 at 10:18 AM, javier Martin
> <javier.martin@vista-silicon.com> wrote:
>
>> That's great. Did you need to change anything in the mx2 camera driver
>> for mx25 to work? Have you already submitted the patches?
>
> I only touched board file code:
> http://www.spinics.net/lists/arm-kernel/msg210216.html
>
> ,and have only verified that camera probe worked on mx25pdk.

Sorry Fabio but IMHO that's not enough. The probe() callback may work
properly but it doesn't mean that buffer and HW handling for i.MX25
are functional.
The condition to keep i.MX25 support in this file was that you were
going to fix it but instead you have just added board support for a
broken driver.

I'd like to hear Guennadi's view on the matter but I think we've given
plenty of time for this.

Regards.




-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
