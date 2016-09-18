Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:29362 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754958AbcIRSr0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Sep 2016 14:47:26 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] [media] pxa_camera: make soc_mbus_xlate_by_fourcc() static
References: <8f05b34a8be23d483661de181aa77c07d8a1bd58.1473429632.git.mchehab@s-opensource.com>
Date: Sun, 18 Sep 2016 20:47:20 +0200
In-Reply-To: <8f05b34a8be23d483661de181aa77c07d8a1bd58.1473429632.git.mchehab@s-opensource.com>
        (Mauro Carvalho Chehab's message of "Fri, 9 Sep 2016 11:00:39 -0300")
Message-ID: <87wpi9dozr.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@s-opensource.com> writes:

> As warned by smatch:
>
> drivers/media/platform/pxa_camera.c:283:39: warning: no previous prototype for 'soc_mbus_xlate_by_fourcc' [-Wmissing-prototypes]
>  const struct soc_camera_format_xlate *soc_mbus_xlate_by_fourcc(
>                                        ^~~~~~~~~~~~~~~~~~~~~~~~
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

--
Robert
