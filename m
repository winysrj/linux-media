Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43653 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750730AbeDKHcg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Apr 2018 03:32:36 -0400
Date: Wed, 11 Apr 2018 09:32:29 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH 1/6] media: ov772x: allow i2c controllers without
 I2C_FUNC_PROTOCOL_MANGLING
Message-ID: <20180411073229.GH6436@w540>
References: <1523116090-13101-1-git-send-email-akinobu.mita@gmail.com>
 <1523116090-13101-2-git-send-email-akinobu.mita@gmail.com>
 <20180409065812.GT20945@w540>
 <CAC5umyjUpMUoT+7ms0WjWmtd7NF-jbAQBHwahR8YnsQxrWfBFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="smOfPzt+Qjm5bNGJ"
Content-Disposition: inline
In-Reply-To: <CAC5umyjUpMUoT+7ms0WjWmtd7NF-jbAQBHwahR8YnsQxrWfBFg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--smOfPzt+Qjm5bNGJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Akinobu,

On Wed, Apr 11, 2018 at 01:37:03AM +0900, Akinobu Mita wrote:
> 2018-04-09 15:58 GMT+09:00 jacopo mondi <jacopo@jmondi.org>:
> > Hello Akinobu,
> >     thank you for the patch.
> >
> > On which platform have you tested the series (just curious) ?
>
> I use Zynq-7000 development board with Xilinx Video IP driver and
> custom video pipeline design based on the example reference project.
>

That's interesting! I was just wondering if there were other
development boards around that ship with this sensor...

> > On Sun, Apr 08, 2018 at 12:48:05AM +0900, Akinobu Mita wrote:
> >> The ov772x driver only works when the i2c controller have
> >> I2C_FUNC_PROTOCOL_MANGLING.  However, many i2c controller drivers don't
> >> support it.
> >>
> >> The reason that the ov772x requires I2C_FUNC_PROTOCOL_MANGLING is that
> >> it doesn't support repeated starts.
> >>
> >> This change adds an alternative method for reading from ov772x register
> >> which uses two separated i2c messages for the i2c controllers without
> >> I2C_FUNC_PROTOCOL_MANGLING.
> >
> > Actually, and please correct me if I'm wrong, what I see here is that
> > an i2c_master_send+i2c_master_recv sequence is equivalent to a mangled
> > smbus transaction:
> >
> > i2c_smbus_read_byte_data | I2C_CLIENT_SCCB:
> > S Addr Wr [A] Comm [A] P S Addr Rd [A] [Data] NA P
> >
> > i2c_master_send() + i2c_master_recv():
> > S Addr Wr [A] Data [A] P
> > S Addr Rd [A] [Data] NA P
> >
> > I wonder if it is not worth to ditch the existing read() function in
> > favour of your new proposed one completely.
> >
> > I have tested it on the Migo-R board where I have an ov772x installed
> > and it works fine.
>
> I'll replace the read() function to the new implementation in the next
> version of this patchset. Although handling in the I2C core is fascinating,
> I feel the area of influence is a bit large.
>

Yep, i2c is huge and complex but fascinating, and the SCCB use case
should probably be handled with a master_send+master_read instead of
relying on the i2c adapter ability to send an additional stop bit
in between an smbus transaction, as Laurent suggested. I wonder why it
has not been implemented this way from day 1. I'm sure there are
reasons :)

I'll wait for v2.
Thanks
   j

> > Although I would like to have a confirmation this is fine by people
> > how has seen more i2c adapters in action than me :)
> >
> > Thanks
> >    j
> >
> >>
> >> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> >> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> >> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> >> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> >> ---
> >>  drivers/media/i2c/ov772x.c | 42 +++++++++++++++++++++++++++++++++---------
> >>  1 file changed, 33 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> >> index b62860c..283ae2c 100644
> >> --- a/drivers/media/i2c/ov772x.c
> >> +++ b/drivers/media/i2c/ov772x.c
> >> @@ -424,6 +424,7 @@ struct ov772x_priv {
> >>       /* band_filter = COM8[5] ? 256 - BDBASE : 0 */
> >>       unsigned short                    band_filter;
> >>       unsigned int                      fps;
> >> +     int (*reg_read)(struct i2c_client *client, u8 addr);
> >>  };
> >>
> >>  /*
> >> @@ -542,11 +543,34 @@ static struct ov772x_priv *to_ov772x(struct v4l2_subdev *sd)
> >>       return container_of(sd, struct ov772x_priv, subdev);
> >>  }
> >>
> >> -static inline int ov772x_read(struct i2c_client *client, u8 addr)
> >> +static int ov772x_read(struct i2c_client *client, u8 addr)
> >> +{
> >> +     struct v4l2_subdev *sd = i2c_get_clientdata(client);
> >> +     struct ov772x_priv *priv = to_ov772x(sd);
> >> +
> >> +     return priv->reg_read(client, addr);
> >> +}
> >> +
> >> +static int ov772x_reg_read(struct i2c_client *client, u8 addr)
> >>  {
> >>       return i2c_smbus_read_byte_data(client, addr);
> >>  }
> >>
> >> +static int ov772x_reg_read_fallback(struct i2c_client *client, u8 addr)
> >> +{
> >> +     int ret;
> >> +     u8 val;
> >> +
> >> +     ret = i2c_master_send(client, &addr, 1);
> >> +     if (ret < 0)
> >> +             return ret;
> >> +     ret = i2c_master_recv(client, &val, 1);
> >> +     if (ret < 0)
> >> +             return ret;
> >> +
> >> +     return val;
> >> +}
> >> +
> >>  static inline int ov772x_write(struct i2c_client *client, u8 addr, u8 value)
> >>  {
> >>       return i2c_smbus_write_byte_data(client, addr, value);
> >> @@ -1255,20 +1279,20 @@ static int ov772x_probe(struct i2c_client *client,
> >>               return -EINVAL;
> >>       }
> >>
> >> -     if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA |
> >> -                                           I2C_FUNC_PROTOCOL_MANGLING)) {
> >> -             dev_err(&adapter->dev,
> >> -                     "I2C-Adapter doesn't support SMBUS_BYTE_DATA or PROTOCOL_MANGLING\n");
> >> -             return -EIO;
> >> -     }
> >> -     client->flags |= I2C_CLIENT_SCCB;
> >> -
> >>       priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
> >>       if (!priv)
> >>               return -ENOMEM;
> >>
> >>       priv->info = client->dev.platform_data;
> >>
> >> +     if (i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA |
> >> +                                          I2C_FUNC_PROTOCOL_MANGLING))
> >> +             priv->reg_read = ov772x_reg_read;
> >> +     else
> >> +             priv->reg_read = ov772x_reg_read_fallback;
> >> +
> >> +     client->flags |= I2C_CLIENT_SCCB;
> >> +
> >>       v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
> >>       v4l2_ctrl_handler_init(&priv->hdl, 3);
> >>       v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
> >> --
> >> 2.7.4
> >>

--smOfPzt+Qjm5bNGJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJazboNAAoJEHI0Bo8WoVY8WLcQAIg4vewaM85egBMcf/W3APZZ
ps25/IsU5MolFI7jty8eK5qEv7AdqYc3tTMioLHRUv9wvADPy7rKDBGUjxXn2Y0d
r/9vpepUrzPySX31Osy2QHEyj0WhTHWQUVS/CklpuaQBO61mjpB/vFtV8arnfp9C
kkPHl28YoH6VkK2Qc4/R5IxXeLSD+zGdNAP2p+JIyYsbVLzx7MYpslxjzH0JwbVg
6qO4UtoQ+zaLxR7apo/TXcIjJyj3uevv/jsLax8rezWmswBzK20HgApxk7wj0TvU
EJPtZrVQra352pU4tWl9in18tm1Lkpxd3cE5gl+Pd33YK126pubD1P6K60IjUuyO
rGmZFLyNb08GdYi3gxe/LjgU8Etyb7uvsgxI7aJEFro5/zketLVgKJItSHZq3xVd
+jzQ0PXF+VVk4jeF42isVoHt10n/K4YzTKcq9FmOMQ3cXjhgUQGDsPqGgasOLpaJ
476zDZ6vFKiVXso5F7d72eNISpLXOeq0vksKQ6YN0gj8QC2SOw4IneibHEbJLx9i
q+TZkxlx+sfQyyOqCuoK/8wMplVH+kE4YC62sf+eVlABbHbrEQ/NbG6KkfPUUbsB
XD43AEOYPoIm7xbtEiDK8luTTMGvn5hadjh6adyH3dJzo0YWNHZdJP5NflLGu0J4
kNl48K7L6fltKBEz+HZq
=1ntI
-----END PGP SIGNATURE-----

--smOfPzt+Qjm5bNGJ--
