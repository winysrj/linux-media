Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15696 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588AbbIVLrb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 07:47:31 -0400
Date: Tue, 22 Sep 2015 13:47:22 +0200
From: Thierry Reding <treding@nvidia.com>
To: Bryan Wu <pengw@nvidia.com>
CC: <hansverk@cisco.com>, <linux-media@vger.kernel.org>,
	<ebrower@nvidia.com>, <jbang@nvidia.com>, <swarren@nvidia.com>,
	<davidw@nvidia.com>, <gfitzer@nvidia.com>, <bmurthyv@nvidia.com>
Subject: Re: [PATCH 1/3] [media] v4l: tegra: Add NVIDIA Tegra VI driver
Message-ID: <20150922114720.GB1417@ulmo.nvidia.com>
References: <1442861755-22743-1-git-send-email-pengw@nvidia.com>
 <1442861755-22743-2-git-send-email-pengw@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <1442861755-22743-2-git-send-email-pengw@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2015 at 11:55:53AM -0700, Bryan Wu wrote:
[...]
> +static int tegra_csi_s_stream(struct v4l2_subdev *subdev, int enable)
> +{
> +	struct tegra_csi_device *csi =3D to_csi(subdev);
> +	struct tegra_channel *chan =3D subdev->host_priv;
> +	enum tegra_csi_port_num port_num =3D (chan->port & 1) ? PORT_B : PORT_A;
> +	struct tegra_csi_port *port =3D &csi->ports[port_num];
> +	int ret;
> +
> +	if (enable) {
[...]
> +	} else {
> +		u32 val =3D pp_read(port, TEGRA_CSI_PIXEL_PARSER_STATUS);
> +		dev_dbg(csi->dev, "TEGRA_CSI_PIXEL_PARSER_STATUS 0x%08x\n", val);
> +
> +		val =3D cil_read(port, TEGRA_CSI_CIL_STATUS);
> +		dev_dbg(csi->dev, "TEGRA_CSI_CIL_STATUS 0x%08x\n", val);
> +
> +		val =3D cil_read(port, TEGRA_CSI_CILX_STATUS);
> +		dev_dbg(csi->dev, "TEGRA_CSI_CILX_STATUS 0x%08x\n", val);
> +=09

I was going to apply this and give it a spin, but then git am complained
about trailing whitespace above...

> +#ifdef DEBUG
> +		val =3D csi_read(csi, TEGRA_CSI_DEBUG_COUNTER_0);
> +		dev_err(&csi->dev, "TEGRA_CSI_DEBUG_COUNTER_0 0x%08x\n", val);
> +#endif
> +
> +		pp_write(port, TEGRA_CSI_PIXEL_STREAM_PP_COMMAND,
> +			 (0xF << CSI_PP_START_MARKER_FRAME_MAX_OFFSET) |
> +			 CSI_PP_DISABLE);
> +
> +		clk_disable_unprepare(csi->clk);
> +	}
> +=09

and here, ...

> +static int tegra_csi_probe(struct platform_device *pdev)
> +{
[...]
> +	for (i =3D 0; i < TEGRA_CSI_PORTS_NUM; i++) {
> +		/* Initialize the default format */
> +		csi->ports[i].format.code =3D TEGRA_VF_DEF;
> +		csi->ports[i].format.field =3D V4L2_FIELD_NONE;
> +		csi->ports[i].format.colorspace =3D V4L2_COLORSPACE_SRGB;
> +		csi->ports[i].format.width =3D TEGRA_DEF_WIDTH;
> +		csi->ports[i].format.height =3D TEGRA_DEF_HEIGHT;
> +
> +		/* Initialize port register bases */
> +		csi->ports[i].pixel_parser =3D csi->iomem +
> +					     (i & 1) * TEGRA_CSI_PORT_OFFSET;
> +		csi->ports[i].cil =3D csi->iomem + TEGRA_CSI_CIL_OFFSET +=20

here and...

> +				    (i & 1) * TEGRA_CSI_PORT_OFFSET;
> +		csi->ports[i].tpg =3D csi->iomem + TEGRA_CSI_TPG_OFFSET +=20

here.

Might be worth fixing those up if you'll respin anyway.

Thierry

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWAT/GAAoJEN0jrNd/PrOhf/AQAKN9Ekr/kebUmsfsKfUcfSfP
7sYd94YjGtSwFXV/Sjzaeeks33x4II0GqrfRx+f8XIg9snDM2EnSQL9nBPg2stS2
4x3h2Pri9GIgJaupQ+zYEI91NAeuh/8lGdP0cQS1HxZ6R22+kBgqPaXJIIwGC+gM
sjFWlR7770/01R8Pdr+MqtYWyRMWONHvqFNSPgH8BiR1XXz0k+0tN+OQH6HCGkqE
wztqD1DnzNNf9hzWpBjuzcY9VnHq/VeEq4Ip8X+p7lggcKuaRmjo1U0Xukg8wQ5i
lsqwGkG019m/kOIt8g9Oczh989stFSgxNatj9Hxf4pxthtBFCu7omYZHfm5fWmSO
Kq8d09ugdEvu7wBg5/MLblKBzjxc+CMVnHhVn/vBwRJRnCcsbxeUfy0ZxnoRMgfu
4UpvgUWhkUtUOj2u5KNJsvmGYUC7/v49y2RgBkzx0wYYGPZztYddCmMfKDlF3CS6
EaTKndaFXoEZ1ThPoU/AuUie9aoJpzS5PM5Wn5mPpmDIYfqUfQyNhFeAgSDe+m5G
DRaE4CFAG9yEmJEJXBJzvSBM7VI0nhRCrVF+aRWrXe1rGQ7/Qa/1foKVQ93jNzNg
CrSxY530JsVLY2MQvfh6coBoEdnBVWbVWWLTVgOwP9VX9ylx7W7MrJ0xc1HyxgDj
oR/ASoN99FOv5t8lxv68
=09zj
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
