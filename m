Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:33546 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab3ABMZc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 07:25:32 -0500
Received: by mail-oa0-f45.google.com with SMTP id i18so13037986oag.18
        for <linux-media@vger.kernel.org>; Wed, 02 Jan 2013 04:25:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACKLOr1sn8E8qGJm1KriEEzPtFOH+2JXdpywY7o4yXe4vWQp2Q@mail.gmail.com>
References: <1351599395-16833-1-git-send-email-javier.martin@vista-silicon.com>
	<1351599395-16833-2-git-send-email-javier.martin@vista-silicon.com>
	<CAOMZO5C0yvvXs38B4zt46zsjphif-tg=FoEjBeoLx7iQUut62Q@mail.gmail.com>
	<Pine.LNX.4.64.1210301327090.29432@axis700.grange>
	<CACKLOr0r2w-=f=PUU-s7x302Jvp3urBZcRQa3pjArZYx0BSjtg@mail.gmail.com>
	<Pine.LNX.4.64.1210301547300.29432@axis700.grange>
	<CAOMZO5CbGz_OW6tx1gAGDrhrS4Mp4f4UrdvLVFS+sh4UVTG46A@mail.gmail.com>
	<CACKLOr1sn8E8qGJm1KriEEzPtFOH+2JXdpywY7o4yXe4vWQp2Q@mail.gmail.com>
Date: Wed, 2 Jan 2013 10:25:31 -0200
Message-ID: <CAOMZO5ACPWoM_SoDCf5JrU1iVt=qXOZz15r0H-Bkt1GLPY04mw@mail.gmail.com>
Subject: Re: [PATCH 1/4] media: mx2_camera: Remove i.mx25 support.
From: Fabio Estevam <festevam@gmail.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, fabio.estevam@freescale.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Wed, Jan 2, 2013 at 10:18 AM, javier Martin
<javier.martin@vista-silicon.com> wrote:

> That's great. Did you need to change anything in the mx2 camera driver
> for mx25 to work? Have you already submitted the patches?

I only touched board file code:
http://www.spinics.net/lists/arm-kernel/msg210216.html

,and have only verified that camera probe worked on mx25pdk.

Regards,

Fabio Estevam
