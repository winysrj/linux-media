Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:51919 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750820AbeEDO6F (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 10:58:05 -0400
Date: Fri, 4 May 2018 16:57:59 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v4 12/14] media: ov772x: avoid accessing registers under
 power saving mode
Message-ID: <20180504145759.GD27261@w540>
References: <1525021993-17789-1-git-send-email-akinobu.mita@gmail.com>
 <1525021993-17789-13-git-send-email-akinobu.mita@gmail.com>
 <20180503210333.GF19612@w540>
 <CAC5umyiVf8VorE8EKop+9cUYCvw1HGyRC_=P23igepaeScfCcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="4f28nU6agdXSinmL"
Content-Disposition: inline
In-Reply-To: <CAC5umyiVf8VorE8EKop+9cUYCvw1HGyRC_=P23igepaeScfCcA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--4f28nU6agdXSinmL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Akinobu,

On Fri, May 04, 2018 at 11:50:39PM +0900, Akinobu Mita wrote:
> 2018-05-04 6:03 GMT+09:00 jacopo mondi <jacopo@jmondi.org>:
> > Hi Akinobu,
> >   let me see if I got this right...
> >
> > On Mon, Apr 30, 2018 at 02:13:11AM +0900, Akinobu Mita wrote:
> >> The set_fmt() in subdev pad ops, the s_ctrl() for subdev control handler,
> >> and the s_frame_interval() in subdev video ops could be called when the
> >> device is under power saving mode.  These callbacks for ov772x driver
> >> cause updating H/W registers that will fail under power saving mode.
> >>
> >> This avoids it by not apply any changes to H/W if the device is not powered
> >> up.  Instead the changes will be restored right after power-up.
> >>
> >> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> >> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> >> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> >> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> >> ---
> >> * v4
> >> - No changes
> >>
> >>  drivers/media/i2c/ov772x.c | 79 +++++++++++++++++++++++++++++++++++++---------
> >>  1 file changed, 64 insertions(+), 15 deletions(-)
> >>
> >> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> >> index 3e6ca98..bd37169 100644
> >> --- a/drivers/media/i2c/ov772x.c
> >> +++ b/drivers/media/i2c/ov772x.c
> >> @@ -741,19 +741,30 @@ static int ov772x_s_frame_interval(struct v4l2_subdev *sd,
> >>       struct ov772x_priv *priv = to_ov772x(sd);
> >>       struct v4l2_fract *tpf = &ival->interval;
> >>       unsigned int fps;
> >> -     int ret;
> >> +     int ret = 0;
> >>
> >>       fps = ov772x_select_fps(priv, tpf);
> >>
> >> -     ret = ov772x_set_frame_rate(priv, fps, priv->cfmt, priv->win);
> >> -     if (ret)
> >> -             return ret;
> >> +     mutex_lock(&priv->lock);
> >> +     /*
> >> +      * If the device is not powered up by the host driver do
> >> +      * not apply any changes to H/W at this time. Instead
> >> +      * the frame rate will be restored right after power-up.
> >> +      */
> >> +     if (priv->power_count > 0) {
> >
> > If I'm not wrong this is not protected when the device is
> > streaming.
> >
> > Since Hans' series frame control is called by g/s_parm (until a new
> > ioctl is not introduced) and I've looked at the call stack and it
> > seems to me it does not check for active streaming[1]. I -think-
> > this is even worse when this is called on the subdev, as there is
> > no shared notion of active streaming. Am I wrong?
> >
> > If you have to check for active streaming here (I see some other
> > drivers doing that, eg ov5640), then I see two ways, or you just
> > return -EBUSY, or you save the desired FPS for later, but then it gets
> > messy as you won't be able to just restore paramters at power_on()
> > time, but you would need to do that also at start streaming time.
> >
> > My opinion is that you should check for streaming active (as you're
> > doing for the set_fmt() function in [13/14], do you agree?
>
> I agree.  I would like to make ov772x_s_frame_interval() return -EBUSY
> without saving the desired FPS for later when the device is streaming.
>
> I'm going to prepare v5 patches that address the above and other issues
> you found in v4 unless you prefer the incremental patch series.

Thank you. Please send v5, the incremental patches thing only applies
to new developments and fixes not already part of this series.

Thanks
   j

>
> > [1] This calls for a device wise 'streaming' state handler. Maybe it's
> > there but I failed to find checks for that.

--4f28nU6agdXSinmL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa7HT3AAoJEHI0Bo8WoVY8vHMQAK9AAEkNcUlVCv563e4t3HiE
TEvryIfTYJ7ZVDdw99Nax+j4X/YDbwoXV4A7LnoHBeGVEsZmW1gIaryvDoss/avI
4rzq2ov0cWNov+xlfQ2rkNdjTGupxX3s72qIuM/hkhsoY24eDzC+qxKocT1rdpO8
P+Hf50EdKmtwYB6oGAbvFtmJBTEwBMyNYgej4ixAMsMM562xvd9vgilb0CkH2/78
EUZ4+lwYj4yMDi5Gq45z2UOjqovI7mYbeDsCL9oAaXtLznyzLMMFZJ2aUEz8aRoX
rMXWei+Sd47ZfCMmWd4jasiHRsEvgQ6UfuAllF8XqfnbA+aBxzWQB1h6XxH16FkW
XmvxfPqcmDgqNlOGKECPK3p37jaYRGf1lM2sVLwUzQPFoF4+qrT6ymQnf2559afv
6qOU50AgEmAeVufjPLRLyPybGVBQFGiRC2xwwOttOCgxoi9JXY3GqHasFEsVbuyE
XdVDFCFx78rzUFVTWD1KzSOokvDE+TlmmsKtclkK85kUSNv5SXG6bSya5Onacaj/
W+wtCizENj5dQ1D2B1wePFf6jI8uN9awsgwZuLXFtJ+vIDn8DiwgdCP6iqQCBC5S
6VAeZd/tVriQpHBzukibBJ2MoOtIAZ6f+l5o7wpq3zsQm17tR/O2at8tlHcFYvYQ
gMvxZE/4vxqtbrmhySWg
=kP9C
-----END PGP SIGNATURE-----

--4f28nU6agdXSinmL--
