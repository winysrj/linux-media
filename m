Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:39865 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab3FWP4Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Jun 2013 11:56:24 -0400
Received: by mail-we0-f174.google.com with SMTP id q58so7579058wes.19
        for <linux-media@vger.kernel.org>; Sun, 23 Jun 2013 08:56:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1371996095-24041-1-git-send-email-lars@metafoo.de>
References: <1371996095-24041-1-git-send-email-lars@metafoo.de>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sun, 23 Jun 2013 21:26:03 +0530
Message-ID: <CA+V-a8t5mkHLsEKA0nUyWJfxmhwF8pnX51PDOfcz7cKVesHSRQ@mail.gmail.com>
Subject: Re: [PATCH v2] [media] tvp514x: Fix init seqeunce
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 23, 2013 at 7:31 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> client->driver->id_table will always point to the first entry in the device id
> table. So all devices will use the same init sequence. Use the id table entry
> that gets passed to the driver's probe() function to get the right init
> sequence.
>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Tested-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
