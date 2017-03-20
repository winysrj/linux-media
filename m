Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:36702 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755678AbdCTQgo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 12:36:44 -0400
Date: Mon, 20 Mar 2017 16:35:47 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
Message-ID: <20170320163547.GP21222@n2100.armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <20170318192258.GL21222@n2100.armlinux.org.uk>
 <aef6c412-5464-726b-42f6-a24b7323aa9c@mentor.com>
 <20170319121402.GS21222@n2100.armlinux.org.uk>
 <1490016016.2917.68.camel@pengutronix.de>
 <20170320154339.GN21222@n2100.armlinux.org.uk>
 <1490027347.2917.97.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1490027347.2917.97.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 20, 2017 at 05:29:07PM +0100, Philipp Zabel wrote:
> According to the documentation [1], you are doing the right thing:
> 
>     The struct v4l2_subdev_frame_interval pad references a non-existing
>     pad, or the pad doesn’t support frame intervals.
> 
> But v4l2_subdev_call returns -ENOIOCTLCMD if the g_frame_interval op is
> not implemented at all, which is turned into -ENOTTY by video_usercopy.
> 
> [1] https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/vidioc-subdev-g-frame-interval.html#return-value

Thanks for confirming.

> > Maybe something like the following would be a better idea?
> > 
> >  utils/media-ctl/media-ctl.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/utils/media-ctl/media-ctl.c b/utils/media-ctl/media-ctl.c
> > index f61963a..a50a559 100644
> > --- a/utils/media-ctl/media-ctl.c
> > +++ b/utils/media-ctl/media-ctl.c
> > @@ -81,22 +81,22 @@ static void v4l2_subdev_print_format(struct media_entity *entity,
> >  	struct v4l2_mbus_framefmt format;
> >  	struct v4l2_fract interval = { 0, 0 };
> >  	struct v4l2_rect rect;
> > -	int ret;
> > +	int ret, err_fi;
> >  
> >  	ret = v4l2_subdev_get_format(entity, &format, pad, which);
> >  	if (ret != 0)
> >  		return;
> >  
> > -	ret = v4l2_subdev_get_frame_interval(entity, &interval, pad);
> > -	if (ret != 0 && ret != -ENOTTY)
> > -		return;
> > +	err_fi = v4l2_subdev_get_frame_interval(entity, &interval, pad);
> 
> Not supporting frame intervals doesn't warrant a visible error message,
> I think -EINVAL should also be ignored above, if the spec is to be
> believed.
> 
> >  
> >  	printf("\t\t[fmt:%s/%ux%u",
> >  	       v4l2_subdev_pixelcode_to_string(format.code),
> >  	       format.width, format.height);
> >  
> > -	if (interval.numerator || interval.denominator)
> > +	if (err_fi == 0 && (interval.numerator || interval.denominator))
> >  		printf("@%u/%u", interval.numerator, interval.denominator);
> > +	else if (err_fi != -ENOTTY)
> > +		printf("@<error: %s>", strerror(-err_fi));
> 
> Or here.

I don't mind which - I could change this to:

	else if (err_fi != -ENOTTY && err_fi != -EINVAL)

Or an alternative would be to print an error (ignoring ENOTTY and EINVAL)
to stderr at the "v4l2_subdev_get_frame_interval" callsite and continue
on (ensuring that interval is zeroed).

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
