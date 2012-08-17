Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:56697 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698Ab2HQJDI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 05:03:08 -0400
Received: by lagv3 with SMTP id v3so1837921lag.6
        for <linux-media@vger.kernel.org>; Fri, 17 Aug 2012 02:03:05 -0700 (PDT)
Message-ID: <1345194182.3158.66.camel@deskari>
Subject: Re: [RFC 3/5] video: panel: Add MIPI DBI bus support
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	Bryan Wu <bryan.wu@canonical.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	Sumit Semwal <sumit.semwal@ti.com>,
	Archit Taneja <archit@ti.com>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Inki Dae <inki.dae@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Date: Fri, 17 Aug 2012 12:03:02 +0300
In-Reply-To: <1345164583-18924-4-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
	 <1345164583-18924-4-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-azfIOgoauAcBVz36ZlR3"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-azfIOgoauAcBVz36ZlR3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-08-17 at 02:49 +0200, Laurent Pinchart wrote:

> +/* ---------------------------------------------------------------------=
--------
> + * Bus operations
> + */
> +
> +void panel_dbi_write_command(struct panel_dbi_device *dev, unsigned long=
 cmd)
> +{
> +	dev->bus->ops->write_command(dev->bus, cmd);
> +}
> +EXPORT_SYMBOL_GPL(panel_dbi_write_command);
> +
> +void panel_dbi_write_data(struct panel_dbi_device *dev, unsigned long da=
ta)
> +{
> +	dev->bus->ops->write_data(dev->bus, data);
> +}
> +EXPORT_SYMBOL_GPL(panel_dbi_write_data);
> +
> +unsigned long panel_dbi_read_data(struct panel_dbi_device *dev)
> +{
> +	return dev->bus->ops->read_data(dev->bus);
> +}
> +EXPORT_SYMBOL_GPL(panel_dbi_read_data);

I'm not that familiar with how to implement bus drivers, can you
describe in pseudo code how the SoC's DBI driver would register these?


I think write/read data functions are a bit limited. Shouldn't they be
something like write_data(const u8 *buf, int size) and read_data(u8
*buf, int len)?

Something that's totally missing is configuring the DBI bus. There are a
bunch of timing related values that need to be configured. See
include/video/omapdss.h struct rfbi_timings. While the struct is OMAP
specific, if I recall right most of the values match to the MIPI DBI
spec.

And this makes me wonder, you use DBI bus for SYS-80 panel. The busses
may look similar in operation, but are they really so similar when you
take into account the timings (and perhaps something else, it's been
years since I read the MIPI DBI spec)?


Then there's the start_transfer. This is something I'm not sure what is
the best way to handle it, but the same problems that I mentioned in the
previous post related to enable apply here also. For example, what if
the panel needs to be update in two parts? This is done in Nokia N9.
=46rom panel's perspective, it'd be best to handle it somewhat like this
(although asynchronously, probably):

write_update_area(0, 0, xres, yres / 2);
write_memory_start()
start_pixel_transfer();

wait_transfer_done();

write_update_area(0, yres / 2, xres, yres / 2);
write_memory_start()
start_pixel_transfer();

Why I said I'm not sure about this is that it does complicate things, as
the actual pixel data often comes from the display subsystem hardware,
which should probably be controlled by the display driver.


I think there also needs to be some kind of transfer_done notifier, for
both the display driver and the panel driver. Although if the display
driver handles starting the actual pixel transfer, then it'll get the
transfer_done via whatever interrupt the SoC has.


Also as food for thought, videomode timings does not really make sense
for DBI panels, at least when you just consider the DBI side. There's
really just the resolution of the display, and then the DBI timings. No
pck, syncs, etc. Of course in the end there's the actual panel, which
does have these video timings. But often they cannot be configured, and
often you don't even know them as the specs don't tell them.

 Tomi


--=-azfIOgoauAcBVz36ZlR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQLgjGAAoJEPo9qoy8lh717NgQAKJED+wpjXUYDJadgOVEXY9Y
ElayA8VvMFCGuJhVWtWITpa/cfO3dyk8F7l4FxKpmqW5WTTL30lNBQS8uYcBFFHu
Sss/D4f/1S5dqbxYeJmLOPS5FXJ8xE53uJNCbPmp7XFfmcdl6xme/klHGfKx7Pff
RxsRZcgmVSngU37t24Bg4X7sC2XGgsUKCRUvluvfsgwpgM1G+UsL5tRtjkE5p4Hp
qdAM4eMSCkty4EweiBs16eD3QiF52mINHi5lTX6E27Dmhl2y1bcGWJqhrqx4qGaA
vYdOMNbyJfu2DoSNdzd9F8AnsplDz4jqM1catKIi1dorDnc22WloSQsSDrQ8wbei
NV0QyadEw6u/Twx6pRdgMhXMcZWELYXg50V2puSQOLKrmn4AovtR6FFFsajhhOei
TZsWiH4mYRTzs+6NxFhVOw8SypxBO1WDcXflfhIWq5otvri+vgkv+DJB57O9okdH
FYNrQBwPK2Zqv/wcF0ZrIYwJwlt7DOOJhGgi/mxdEcMjFVCasxXxecb3PoEOEzk0
O3W0l/ujrFPaeXgpXTf1g+8A368VMuX08WBUyefVcJEWzEDQvQFPYLNQ+mmoaaKF
U1gWq+VDaKkfZu1cKxNgMne8uCX1rm6cn41SDKD1naYLP2z4WoFX0GZkTXQmWr4m
SNfEhxUMaz4g3waT4etN
=yjXA
-----END PGP SIGNATURE-----

--=-azfIOgoauAcBVz36ZlR3--

