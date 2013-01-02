Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:39348 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab3ABN3n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 08:29:43 -0500
Received: by mail-oa0-f44.google.com with SMTP id n5so13097409oag.31
        for <linux-media@vger.kernel.org>; Wed, 02 Jan 2013 05:29:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACKLOr2DB4-ag7v=csVySeeff9tRV7-_yRNwS6vHht9s6CL45g@mail.gmail.com>
References: <1351599395-16833-1-git-send-email-javier.martin@vista-silicon.com>
	<1351599395-16833-2-git-send-email-javier.martin@vista-silicon.com>
	<CAOMZO5C0yvvXs38B4zt46zsjphif-tg=FoEjBeoLx7iQUut62Q@mail.gmail.com>
	<Pine.LNX.4.64.1210301327090.29432@axis700.grange>
	<CACKLOr0r2w-=f=PUU-s7x302Jvp3urBZcRQa3pjArZYx0BSjtg@mail.gmail.com>
	<Pine.LNX.4.64.1210301547300.29432@axis700.grange>
	<CAOMZO5CbGz_OW6tx1gAGDrhrS4Mp4f4UrdvLVFS+sh4UVTG46A@mail.gmail.com>
	<CACKLOr1sn8E8qGJm1KriEEzPtFOH+2JXdpywY7o4yXe4vWQp2Q@mail.gmail.com>
	<CAOMZO5ACPWoM_SoDCf5JrU1iVt=qXOZz15r0H-Bkt1GLPY04mw@mail.gmail.com>
	<CACKLOr2DB4-ag7v=csVySeeff9tRV7-_yRNwS6vHht9s6CL45g@mail.gmail.com>
Date: Wed, 2 Jan 2013 11:29:42 -0200
Message-ID: <CAOMZO5BRLPObojEuYfksQ-nYVTrBzVjT28YndtYRhV0O3-aAyw@mail.gmail.com>
Subject: Re: [PATCH 1/4] media: mx2_camera: Remove i.mx25 support.
From: Fabio Estevam <festevam@gmail.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, fabio.estevam@freescale.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 2, 2013 at 10:35 AM, javier Martin
<javier.martin@vista-silicon.com> wrote:

> Sorry Fabio but IMHO that's not enough. The probe() callback may work
> properly but it doesn't mean that buffer and HW handling for i.MX25
> are functional.
> The condition to keep i.MX25 support in this file was that you were
> going to fix it but instead you have just added board support for a
> broken driver.
>
> I'd like to hear Guennadi's view on the matter but I think we've given
> plenty of time for this.

Sounds fair. Go ahead and remove mx25 camera support then.

I would not be able to further debug this driver.

Regards,

Fabio Estevam
