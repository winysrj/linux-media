Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:54639 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754014AbeDZSLt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 14:11:49 -0400
Date: Thu, 26 Apr 2018 20:11:43 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v3 01/11] media: dt-bindings: ov772x: add device tree
 binding
Message-ID: <20180426181143.GI17088@w540>
References: <1524412577-14419-1-git-send-email-akinobu.mita@gmail.com>
 <CAC5umyiG+=nFyj31XQBNnwH_Ts130xWymH-kCinEoRDu3iFbWQ@mail.gmail.com>
 <CAC5umyj1m18UgKjWYfhFhz0mj0N2_koATU3bev81FiOYgk6AZQ@mail.gmail.com>
 <2085532.oxbmo4GB4v@avalon>
 <CAC5umyhR=VKxhtQwegceczvQyjpV5zaJ-E8+RscTuveS=9Em+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7SrMUQONj8Rl9QNG"
Content-Disposition: inline
In-Reply-To: <CAC5umyhR=VKxhtQwegceczvQyjpV5zaJ-E8+RscTuveS=9Em+g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--7SrMUQONj8Rl9QNG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello Mita-san,

On Fri, Apr 27, 2018 at 01:17:55AM +0900, Akinobu Mita wrote:
> 2018-04-26 7:40 GMT+09:00 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> > Hi Mita-san,
> >
> > On Wednesday, 25 April 2018 19:19:11 EEST Akinobu Mita wrote:
> >> 2018-04-24 0:54 GMT+09:00 Akinobu Mita <akinobu.mita@gmail.com>:
> >> > 2018-04-23 18:17 GMT+09:00 Laurent Pinchart:
> >> >> On Sunday, 22 April 2018 18:56:07 EEST Akinobu Mita wrote:
> >> >>> This adds a device tree binding documentation for OV7720/OV7725 sensor.
> >> >>>
> >> >>> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >> >>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >> >>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> >> >>> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> >> >>> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> >> >>> Cc: Rob Herring <robh+dt@kernel.org>
> >> >>> Reviewed-by: Rob Herring <robh@kernel.org>
> >> >>> Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
> >> >>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> >> >>> ---
> >> >>> * v3
> >> >>> - Add Reviewed-by: lines
> >> >>>
> >> >>>  .../devicetree/bindings/media/i2c/ov772x.txt       | 42 +++++++++++++++
> >> >>>  MAINTAINERS                                        |  1 +
> >> >>>  2 files changed, 43 insertions(+)
> >> >>>  create mode 100644
> >> >>>  Documentation/devicetree/bindings/media/i2c/ov772x.txt
> >> >>>
> >> >>> diff --git a/Documentation/devicetree/bindings/media/i2c/ov772x.txt
> >> >>> b/Documentation/devicetree/bindings/media/i2c/ov772x.txt new file mode
> >> >>> 100644
> >> >>> index 0000000..b045503
> >> >>> --- /dev/null
> >> >>> +++ b/Documentation/devicetree/bindings/media/i2c/ov772x.txt
> >> >>> @@ -0,0 +1,42 @@
> >> >>> +* Omnivision OV7720/OV7725 CMOS sensor
> >> >>> +
> >> >>> +The Omnivision OV7720/OV7725 sensor supports multiple resolutions
> >> >>> output,
> >> >>> +such as VGA, QVGA, and any size scaling down from CIF to 40x30. It also
> >> >>> can +support the YUV422, RGB565/555/444, GRB422 or raw RGB output
> >> >>> formats. +
> >> >>> +Required Properties:
> >> >>> +- compatible: shall be one of
> >> >>> +     "ovti,ov7720"
> >> >>> +     "ovti,ov7725"
> >> >>> +- clocks: reference to the xclk input clock.
> >> >>> +- clock-names: shall be "xclk".
> >> >>
> >> >> As there's a single clock we could omit clock-names, couldn't we ?
> >> >
> >> > Sounds good.
> >> >
> >> > I'll prepare another patch that replaces the clock consumer ID argument
> >> > of clk_get() from "xclk" to NULL, and remove the above line in this
> >> > bindings.
> >>
> >> I thought it's easy to do.  However, there is a non-DT user
> >> (arch/sh/boards/mach-migor/setup.c) that defines a clock with "xclk" ID.
> >>
> >> This can be resolved by retrying clk_get() with NULL if no entry
> >> with "xclk".  But should we do so or leave as is?
> >
> > How about patching the board code to register the clock alias with
> >
> >         clk_add_alias(NULL, "0-0021", "video_clk", NULL);
>
> Sounds good.
>
> But I'm a bit worried about whether clk_add_alias() can be called with
> alias == NULL.  I couldn't find such use case.
>
> Probably Jacopo can verify whether it works or not with v4 patchset.

Yes, you can use NULL to register a clock alias. Just make sure to drop the
clock name in ov772x driver (I have just verified the following works :)

diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
index 3d7d004..2deee53 100644
--- a/arch/sh/boards/mach-migor/setup.c
+++ b/arch/sh/boards/mach-migor/setup.c
@@ -592,7 +592,7 @@ static int __init migor_devices_setup(void)
        }

        /* Add a clock alias for ov7725 xclk source. */
-       clk_add_alias("xclk", "0-0021", "video_clk", NULL);
+       clk_add_alias(NULL, "0-0021", "video_clk", NULL);

        /* Register GPIOs for video sources. */
        gpiod_add_lookup_table(&ov7725_gpios);
diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index b62860c..e1f4076 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -1281,7 +1281,7 @@ static int ov772x_probe(struct i2c_client *client,
        if (priv->hdl.error)
                return priv->hdl.error;

-       priv->clk = clk_get(&client->dev, "xclk");
+       priv->clk = clk_get(&client->dev, NULL);
        if (IS_ERR(priv->clk)) {
                dev_err(&client->dev, "Unable
Thanks
   j

--7SrMUQONj8Rl9QNG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa4hZeAAoJEHI0Bo8WoVY87qsP/08yDWuX3uhuf7Jb301yD9MK
LtRT/Vs5P3VHohXudDeBCLYea2TzXlZrjWxFcEz3XyhjC4uJ4h/3y6+fg/6nZVhF
A4XjSFRCVdcUsv4KaxPcVFoisnZ6jhObtArrPOBRwlvVrto+uF3iEM24XxemYoUp
MgXVkkrslDSiguSvTrostxS//yoIXumIa9fLxzQ8mpG5khA3DZn78MHklGxzTD49
mx/Z3WfvL9f5URHsXmoG7axdH94rHiDR3X1lbia5v82+295M4GdmRHyzYOzsLUV/
ewcHKyjdAp/3ITdZ1lCe8NvE409RfZYvaWr21e/mIdXyamSybGeBFxPRrEYyMAFA
jrPj9+kKH4cJHBDUduvW9f3PTZNy4Qv7j742S6X4F4Cj33YiEFa1lIhFhfP1Wirr
S08UhrQFNWexZOc0YgYw/9HcBspD/bgw0rPyeGAenztTcOww+HQh3OwHuLhDgbsG
pEMcl9dapIWE/o9l1gUw+kcjn700Mf176yAuY/YzhS1bARzJ92cOM1OH0EIIYR+d
2SjRtRumUCxvx04dGw5iU084BOdsN0ZWCXKIBzEZsgvvl5Z8MGAbo42ZXvC4RLzV
d5KOM8dmGaONQ5KnxsqXX9kBnXHAmeBf4Jl9H9hwasMfDNiPJJdhielKBwQ9RAhe
z8Nnu2EGPB30Gx4zweGG
=K/2M
-----END PGP SIGNATURE-----

--7SrMUQONj8Rl9QNG--
