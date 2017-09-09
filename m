Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:45483 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753632AbdIIMmA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Sep 2017 08:42:00 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Petr Cvek <petr.cvek@tul.cz>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] [media] pxa_camera: Delete an error message for a failed memory allocation in pxa_camera_probe()
References: <c7f8c07d-3cbd-c705-a8e5-d0c6941cd09e@users.sourceforge.net>
Date: Sat, 09 Sep 2017 14:41:54 +0200
In-Reply-To: <c7f8c07d-3cbd-c705-a8e5-d0c6941cd09e@users.sourceforge.net> (SF
        Markus Elfring's message of "Fri, 8 Sep 2017 22:14:59 +0200")
Message-ID: <87wp58niwd.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SF Markus Elfring <elfring@users.sourceforge.net> writes:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 8 Sep 2017 22:05:14 +0200
>
> Omit an extra message for a memory allocation failure in this function.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

--
Robert
