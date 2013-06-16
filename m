Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:56394 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899Ab3FPKLc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jun 2013 06:11:32 -0400
Received: by mail-wi0-f176.google.com with SMTP id ey16so1460639wid.15
        for <linux-media@vger.kernel.org>; Sun, 16 Jun 2013 03:11:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1371306876-8596-1-git-send-email-lars@metafoo.de>
References: <1371306876-8596-1-git-send-email-lars@metafoo.de>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sun, 16 Jun 2013 15:41:11 +0530
Message-ID: <CA+V-a8uUEcoh2bbpUP=Oo8Pj-1yX8VWS7z9m_kOgyzxfMwQ-Ow@mail.gmail.com>
Subject: Re: [PATCH] [media] tvp514x: Fix init seqeunce
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lars-Peter,

Thanks for the patch.

On Sat, Jun 15, 2013 at 8:04 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> client->driver->id_table will always point to the first entry in the device id
> table. So all devices will use the same init sequence. Use the id table entry
> that gets passed to the driver's probe() function to get the right init
> sequence.
>
The patch looks OK, but it causes following two warnings,

drivers/media/i2c/tvp514x.c: In function 'tvp514x_s_stream':
drivers/media/i2c/tvp514x.c:868: warning: unused variable 'client'
drivers/media/i2c/tvp514x.c: In function 'tvp514x_probe':
drivers/media/i2c/tvp514x.c:1092: warning: assignment makes pointer
from integer without a cast

With the above fixed you can add my,

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Tested-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
