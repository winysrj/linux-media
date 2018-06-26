Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:40113 "EHLO
        homiemail-a125.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751980AbeFZUJ5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Jun 2018 16:09:57 -0400
Subject: Re: [PATCH] media: em28xx: fix a regression with HVR-950
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Brad Love <brad@nextdimension.cc>
References: <41857a8224110ed8044d5fbbdded8998129e5d7e.1520598094.git.mchehab@s-opensource.com>
From: Brad Love <brad@nextdimension.cc>
Message-ID: <89287fa5-a214-d86b-b991-84228b228280@nextdimension.cc>
Date: Tue, 26 Jun 2018 15:09:55 -0500
MIME-Version: 1.0
In-Reply-To: <41857a8224110ed8044d5fbbdded8998129e5d7e.1520598094.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

It turns out this patch breaks DualHD multiple tuner capability. When
alt mode is set in start_streaming it immediately kills the other tuners
stream. Essentially both tuners cannot be used together when this is
applied. I unfortunately don't have a HVR-950 to try and fix the
original regression better. Can you please take another look at this?
Until this is sorted, DualHD are effectively broken.

Cheers,

Brad




On 2018-03-09 06:21, Mauro Carvalho Chehab wrote:
> Changeset be7fd3c3a8c5 ("media: em28xx: Hauppauge DualHD second tuner
> functionality") removed the logic with sets the alternate for the DVB
> device. Without setting the right alternate, the device won't be
> able to submit URBs, and userspace fails with -EMSGSIZE:
>
> 	ERROR     DMX_SET_PES_FILTER failed (PID =3D 0x2000): 90 Message too l=
ong
>
> Tested with Hauppauge HVR-950 model A1C0.
>
> Cc: Brad Love <brad@nextdimension.cc>
> Fixes: be7fd3c3a8c5 ("media: em28xx: Hauppauge DualHD second tuner func=
tionality")
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/usb/em28xx/em28xx-dvb.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/=
em28xx/em28xx-dvb.c
> index a54cb8dc52c9..2ce7de1c7cce 100644
> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> @@ -199,6 +199,7 @@ static int em28xx_start_streaming(struct em28xx_dvb=
 *dvb)
>  	int rc;
>  	struct em28xx_i2c_bus *i2c_bus =3D dvb->adapter.priv;
>  	struct em28xx *dev =3D i2c_bus->dev;
> +	struct usb_device *udev =3D interface_to_usbdev(dev->intf);
>  	int dvb_max_packet_size, packet_multiplier, dvb_alt;
> =20
>  	if (dev->dvb_xfer_bulk) {
> @@ -217,6 +218,7 @@ static int em28xx_start_streaming(struct em28xx_dvb=
 *dvb)
>  		dvb_alt =3D dev->dvb_alt_isoc;
>  	}
> =20
> +	usb_set_interface(udev, dev->ifnum, dvb_alt);
>  	rc =3D em28xx_set_mode(dev, EM28XX_DIGITAL_MODE);
>  	if (rc < 0)
>  		return rc;
