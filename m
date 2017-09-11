Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:45470 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750842AbdIKNVO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 09:21:14 -0400
MIME-Version: 1.0
In-Reply-To: <9be97d7f-57bc-1c7e-fd86-187a38e0f994@users.sourceforge.net>
References: <e980c48c-9525-4942-a58e-20af8a96e531@users.sourceforge.net> <9be97d7f-57bc-1c7e-fd86-187a38e0f994@users.sourceforge.net>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Mon, 11 Sep 2017 14:20:42 +0100
Message-ID: <CA+V-a8u0_RD7k8Db=x6UUPyAaXADa3ouFk7v1N9hXDndf0zk8Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] [media] DaVinci-VPBE-Display: Delete an error message
 for a failed memory allocation in init_vpbe_layer()
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 8, 2017 at 1:31 PM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
>
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 7 Sep 2017 22:37:16 +0200
>
> Omit an extra message for a memory allocation failure in this function.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
