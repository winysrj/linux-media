Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39181 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbeIZLhv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 07:37:51 -0400
MIME-Version: 1.0
References: <20180921085450.19224-1-ricardo.ribalda@gmail.com>
 <20180921092833.c3bznrhc3yyarmq4@kekkonen.localdomain> <CAPybu_2J4b8C_AQu5trH6fLG3FAkSvFiUOYt-HFwG+YXK9PkkQ@mail.gmail.com>
 <20180924203252.wxeclgjc7zvepyhb@kekkonen.localdomain>
In-Reply-To: <20180924203252.wxeclgjc7zvepyhb@kekkonen.localdomain>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 26 Sep 2018 07:26:24 +0200
Message-ID: <CAPybu_3WF3x42k814dvEwqrMMfaxt2s4OpuK3BGMobBfmsgQ5Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] [media] imx214: Add imx214 camera sensor driver
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sakari
On Mon, Sep 24, 2018 at 10:32 PM Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
>
> Hi Ricardo,
>
> On Fri, Sep 21, 2018 at 12:15:55PM +0200, Ricardo Ribalda Delgado wrote:
> ...
> > > > +static struct reg_8 mode_1920x1080[];
> > > > +static struct reg_8 mode_4096x2304[];
> > >
> > > Const. Could you rearrange the bits to avoid the forward declarations=
?
> > Const done, but I prefer to keep the forward declaration. Otherwise
> > the long tables will "hide" the mode declaration.
>
> Well, I guess the long tables do "hide" a bunch of other stuff, too. :-)
> But... I agree there's no trivial way around those tables either.
>
> It appears I'm not the only one who's commented on the matter of the
> forward declaration.

Ok, I will change it, Eppur si muove  ;)
>
> ...
>
> > > > +static int imx214_probe(struct i2c_client *client)
> > > > +{
> > > > +     struct device *dev =3D &client->dev;
> > > > +     struct imx214 *imx214;
> > > > +     struct fwnode_handle *endpoint;
> > > > +     int ret;
> > > > +     static const s64 link_freq[] =3D {
> > > > +             (IMX214_DEFAULT_PIXEL_RATE * 10LL) / 8,
> > >
> > > You should check the link frequency matches with that from the firmwa=
re.
> >
> > I am not sure what you mean here sorry.
>
> The system firmware holds safe frequencies for the CSI-2 bus on that
> particular system; you should check that the register lists are valid for
> that frequency.
>
> ...
>
> > > > +     imx214->pixel_rate =3D v4l2_ctrl_new_std(&imx214->ctrls, NULL=
,
> > > > +                                            V4L2_CID_PIXEL_RATE, 0=
,
> > > > +                                            IMX214_DEFAULT_PIXEL_R=
ATE, 1,
> > > > +                                            IMX214_DEFAULT_PIXEL_R=
ATE);
> > > > +     imx214->link_freq =3D v4l2_ctrl_new_int_menu(&imx214->ctrls, =
NULL,
> > > > +                                                V4L2_CID_LINK_FREQ=
,
> > > > +                                                ARRAY_SIZE(link_fr=
eq) - 1,
> > > > +                                                0, link_freq);
> > >
> > > Do I understand this correctly that the driver does not support setti=
ng
> > > e.g. exposure time or gain? Those are very basic features...
> >
> >
> > Yep :), this is just a first step. I do not have the register set from
> > the device :(. So I am reverse engineering a lot of things.
> > I will add more controls as I am done with them.
>
> Looking at the registers you have in the register list, the sensor's
> registers appear similar to those used by the smiapp driver (the old SMIA
> standard).
>
> I'd guess the same register would work for setting the exposure time. I'm
> less certain about the limits though.

Thanks for the pointer! I will try this out and probably add it as a patch.

>
> >
> > >
> > > You'll also need to ensure the s_ctrl() callback works without s_powe=
r()
> > > being called. My suggestion is to switch to PM runtime; see e.g. the =
ov1385
> > > driver in the current media tree master.
> >
> >
> > There is one limitation with this chip on the dragonboard. I2c only
> > works if the camss is ON. Therefore whatever s_ctrl needs to be
> > cached and written at streamon.
>
> That's something that doesn't belong to this driver. It's the I=E6=B6=8E =
adapter
> driver / camss issue, and not necessarily related to drivers only. Is the
> I=E6=B6=8E controller part of the camss btw.?

I am with you here. The i2c controller is a different driver but is
integrated with camss. Checkout
https://patchwork.kernel.org/patch/10569961/ I am interacting with
Todor and Vinod to enable the i2c port indepently with camss. At least
now it does not kill the port after an i2c timeout :)

Will fix the fwd declaration and the csi-2 register. Then I wll upload
it to my github, try it on real hw next monday and send back to the
mailing list

Thanks!

>
> --
> Regards,
>
> Sakari Ailus
> sakari.ailus@linux.intel.com



--=20
Ricardo Ribalda
