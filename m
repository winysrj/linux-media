Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43445 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387435AbeKMXyN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 18:54:13 -0500
Received: by mail-pg1-f194.google.com with SMTP id n10-v6so5723543pgv.10
        for <linux-media@vger.kernel.org>; Tue, 13 Nov 2018 05:55:58 -0800 (PST)
MIME-Version: 1.0
References: <1542038454-20066-1-git-send-email-akinobu.mita@gmail.com>
 <1542038454-20066-4-git-send-email-akinobu.mita@gmail.com> <20181113103653.hl7ukiiy4lcphoxj@kekkonen.localdomain>
In-Reply-To: <20181113103653.hl7ukiiy4lcphoxj@kekkonen.localdomain>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Tue, 13 Nov 2018 22:55:46 +0900
Message-ID: <CAC5umyiqtu+yCUmr48mCddJa_-wM+_bHFVWjLjr0rJu3kJZALQ@mail.gmail.com>
Subject: Re: [PATCH 3/7] media: ov2640: add V4L2_CID_TEST_PATTERN control
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018=E5=B9=B411=E6=9C=8813=E6=97=A5(=E7=81=AB) 19:37 Sakari Ailus <sakari.a=
ilus@linux.intel.com>:
>
> On Tue, Nov 13, 2018 at 01:00:50AM +0900, Akinobu Mita wrote:
> > The ov2640 has the test pattern generator features.  This makes use of
> > it through V4L2_CID_TEST_PATTERN control.
> >
> > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > ---
> >  drivers/media/i2c/ov2640.c | 14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
> > index 20a8853..4992d77 100644
> > --- a/drivers/media/i2c/ov2640.c
> > +++ b/drivers/media/i2c/ov2640.c
> > @@ -705,6 +705,11 @@ static int ov2640_reset(struct i2c_client *client)
> >       return ret;
> >  }
> >
> > +static const char * const ov2640_test_pattern_menu[] =3D {
> > +     "Disabled",
> > +     "Color bar",
>
> s/b/B/
>
> The smiapp driver uses "Eight Vertical Colour Bars", not sure if that'd f=
it
> here or not. FYI.

This test pattern shows eight vertical color bars with blending actual
sensor image, although the datasheet tells just 'Color bar'.

So either is fine for me.
