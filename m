Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:54870 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755754AbcJNVCU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 17:02:20 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geunyoung Kim <nenggun.kim@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 54/57] [media] platform: don't break long lines
References: <cover.1476475770.git.mchehab@s-opensource.com>
        <cover.1476475770.git.mchehab@s-opensource.com>
        <68fc2da43db37e66ec6a3e1ff0e750b73c3b0f42.1476475771.git.mchehab@s-opensource.com>
Date: Fri, 14 Oct 2016 23:02:11 +0200
In-Reply-To: <68fc2da43db37e66ec6a3e1ff0e750b73c3b0f42.1476475771.git.mchehab@s-opensource.com>
        (Mauro Carvalho Chehab's message of "Fri, 14 Oct 2016 17:20:42 -0300")
Message-ID: <871szi7igc.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@s-opensource.com> writes:

> Due to the 80-cols checkpatch warnings, several strings
> were broken into multiple lines. This is not considered
> a good practice anymore, as it makes harder to grep for
> strings at the source code. So, join those continuation
> lines.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/platform/mx2_emmaprp.c | 3 +--
>  drivers/media/platform/pxa_camera.c  | 6 ++----
>  drivers/media/platform/via-camera.c  | 7 ++-----
>  3 files changed, 5 insertions(+), 11 deletions(-)
For pxa_camera, FWIW:
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

--
Robert
