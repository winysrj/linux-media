Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:36047 "EHLO
        mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751095AbcKITHg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 14:07:36 -0500
MIME-Version: 1.0
In-Reply-To: <CADDKRnD_+uhQc7GyK3FfnDSRUkL5WkZNV7F+TsEhhDdo6O=Vmw@mail.gmail.com>
References: <CADDKRnD6sQLsxwObi1Bo6k69P5ceqQHw7beT6C7TqZjUsDby+w@mail.gmail.com>
 <CA+55aFxXoc3GzAXWPZL=RB2xhmhP1acR3m2S_mdoiO97+80kDA@mail.gmail.com>
 <20161108182215.41f1f3d2@vento.lan> <CADDKRnD_+uhQc7GyK3FfnDSRUkL5WkZNV7F+TsEhhDdo6O=Vmw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 9 Nov 2016 11:07:35 -0800
Message-ID: <CA+55aFwsYHbXFimTL137Zwbc0bhOmR+XzDnUBmM=Pgn+8xBnWw@mail.gmail.com>
Subject: Re: [v4.9-rc4] dvb-usb/cinergyT2 NULL pointer dereference
To: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 9, 2016 at 3:09 AM, J=C3=B6rg Otte <jrg.otte@gmail.com> wrote:
>
> Tried patch with no success. Again a NULL ptr dereferece.

That patch was pure garbage, I think. Pretty much all the other
drivers that use the same approach will have the same issue. Adding
that init function just for the semaphore is crazy.

I suspect a much simpler approach is to just miove the "data_mutex"
away from the priv area and into "struct dvb_usb_device" and
"dvb_usb_adapter". Sure, that grows those structures a tiny bit, and
not every driver may need that mutex, but it simplifies things
enormously. Mauro?

             Linus
