Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:43555 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750842AbdIKN1F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 09:27:05 -0400
MIME-Version: 1.0
In-Reply-To: <3331c4f8-a327-abc6-df00-09e67d3769fe@users.sourceforge.net>
References: <e980c48c-9525-4942-a58e-20af8a96e531@users.sourceforge.net> <3331c4f8-a327-abc6-df00-09e67d3769fe@users.sourceforge.net>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Mon, 11 Sep 2017 14:26:33 +0100
Message-ID: <CA+V-a8v6xCx_tc2GZnL-PbGqybG-7_4bo=cmzWtJ4hiq3uwCaA@mail.gmail.com>
Subject: Re: [PATCH 3/3] [media] DaVinci-VPBE-Display: Adjust 12 checks for
 null pointers
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 8, 2017 at 1:33 PM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 8 Sep 2017 14:00:20 +0200
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>
> The script =E2=80=9Ccheckpatch.pl=E2=80=9D pointed information out like t=
he following.
>
> Comparison to NULL could be written =E2=80=A6
>
> Thus fix the affected source code places.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
