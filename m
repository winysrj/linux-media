Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36105 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbdIKNYR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 09:24:17 -0400
MIME-Version: 1.0
In-Reply-To: <d4fc91b4-4850-b756-d297-fcebdc8d7131@users.sourceforge.net>
References: <e980c48c-9525-4942-a58e-20af8a96e531@users.sourceforge.net> <d4fc91b4-4850-b756-d297-fcebdc8d7131@users.sourceforge.net>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Mon, 11 Sep 2017 14:23:45 +0100
Message-ID: <CA+V-a8sS4UjeFDsGa1bvG2nyLOoNVqCBg2Q18QuD6P3mu6FHJA@mail.gmail.com>
Subject: Re: [PATCH 2/3] [media] DaVinci-VPBE-Display: Improve a size
 determination in two functions
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 8, 2017 at 1:32 PM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 8 Sep 2017 10:50:32 +0200
>
> Replace the specification of data structures by pointer dereferences
> as the parameter for the operator "sizeof" to make the corresponding size
> determination a bit safer according to the Linux coding style convention.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
