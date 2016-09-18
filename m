Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:56246 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754189AbcIRSsv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Sep 2016 14:48:51 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/2] [media] pxa_camera: remove an unused structure pointer
References: <8f05b34a8be23d483661de181aa77c07d8a1bd58.1473429632.git.mchehab@s-opensource.com>
        <8f05b34a8be23d483661de181aa77c07d8a1bd58.1473429632.git.mchehab@s-opensource.com>
        <ade50f4ff8029a182c16c6418995e6ec569ea9fc.1473429632.git.mchehab@s-opensource.com>
Date: Sun, 18 Sep 2016 20:48:48 +0200
In-Reply-To: <ade50f4ff8029a182c16c6418995e6ec569ea9fc.1473429632.git.mchehab@s-opensource.com>
        (Mauro Carvalho Chehab's message of "Fri, 9 Sep 2016 11:00:40 -0300")
Message-ID: <87shsxdoxb.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@s-opensource.com> writes:

> As reported by smatch:
>
> drivers/media/platform/pxa_camera.c: In function 'pxa_dma_start_channels':
> drivers/media/platform/pxa_camera.c:457:21: warning: variable 'active' set but not used [-Wunused-but-set-variable]
>   struct pxa_buffer *active;
>                      ^~~~~~
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

-- 
Robert
