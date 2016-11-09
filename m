Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:42537
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752397AbcKIUWE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 15:22:04 -0500
Date: Wed, 9 Nov 2016 18:21:13 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?UTF-8?B?SsO2cmc=?= Otte <jrg.otte@gmail.com>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [v4.9-rc4] dvb-usb/cinergyT2 NULL pointer dereference
Message-ID: <20161109182113.410aa996@vento.lan>
In-Reply-To: <CA+55aFwsYHbXFimTL137Zwbc0bhOmR+XzDnUBmM=Pgn+8xBnWw@mail.gmail.com>
References: <CADDKRnD6sQLsxwObi1Bo6k69P5ceqQHw7beT6C7TqZjUsDby+w@mail.gmail.com>
        <CA+55aFxXoc3GzAXWPZL=RB2xhmhP1acR3m2S_mdoiO97+80kDA@mail.gmail.com>
        <20161108182215.41f1f3d2@vento.lan>
        <CADDKRnD_+uhQc7GyK3FfnDSRUkL5WkZNV7F+TsEhhDdo6O=Vmw@mail.gmail.com>
        <CA+55aFwsYHbXFimTL137Zwbc0bhOmR+XzDnUBmM=Pgn+8xBnWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 9 Nov 2016 11:07:35 -0800
Linus Torvalds <torvalds@linux-foundation.org> escreveu:

> On Wed, Nov 9, 2016 at 3:09 AM, Jörg Otte <jrg.otte@gmail.com> wrote:
> >
> > Tried patch with no success. Again a NULL ptr dereferece.  
> 
> That patch was pure garbage, I think. Pretty much all the other
> drivers that use the same approach will have the same issue. Adding
> that init function just for the semaphore is crazy.
> 
> I suspect a much simpler approach is to just miove the "data_mutex"
> away from the priv area and into "struct dvb_usb_device" and
> "dvb_usb_adapter". Sure, that grows those structures a tiny bit, and
> not every driver may need that mutex, but it simplifies things
> enormously. Mauro?

Yeah, makes sense.

I'll work on moving data_mutex to struct dvb_usb_device.

Thanks,
Mauro
