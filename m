Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:34809 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab2BXTgz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 14:36:55 -0500
Date: Fri, 24 Feb 2012 22:38:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: mchehab@infradead.org, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, tomas.winkler@intel.com,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 9/9] staging: easycap: Split easycap_delete() into
 several pieces
Message-ID: <20120224193842.GD3649@mwanda>
References: <1330097062-31663-1-git-send-email-elezegarcia@gmail.com>
 <1330097062-31663-9-git-send-email-elezegarcia@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JwB53PgKC5A7+0Ej"
Content-Disposition: inline
In-Reply-To: <1330097062-31663-9-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--JwB53PgKC5A7+0Ej
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 24, 2012 at 12:24:22PM -0300, Ezequiel Garcia wrote:
> +	/* Free video urbs */
> +	free_video_urbs(peasycap);

These comments aren't redundant.  Could you remove them in a later
patch?

regards,
dan carpenter


--JwB53PgKC5A7+0Ej
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPR+dBAAoJEOnZkXI/YHqRw5oQAImjplaAMdQN6YQ+ppxR3POC
QqYwDqfewVpNVShG+7tLO/hZvbU86LoT2q8ZH/QWeSavFf8cy8SYgoAQlllEnMjs
uKDFGEth2xdh47+2YUREgzZWxmzNH4mi377ZUqeg6FKA/p3doyf3fddgqoz+bIxw
svxGPEEgMuesC7s2ECzbpo5Ta5Z/SMv5Anaw3DPcwqptwwJ9DsVCXa2+VMrZWJay
/A/6MQr4j+F2z8q82FLLPbUiTVcumYW9lc1d5TskZtNVTrzM2L63rizzSiYdT5Tf
rEyD6ovdjLuKZahTmj0KMPcNAqMwMC+IFu9Cr7zfTXcxXr6+nED9gn0JdojmLYh3
rw6o1PBway5LfgxhiI7+tEBkNOlG0DmRW3PzrPPfwvcWHAMUWcYzPt6Jb5XXnNDu
e0dZrMusFcv0wdxSADO5wyvjTR9SuLWNn7KlRHAAwGoTFAUDiqPd4yuhFIWJyYCo
T+4FWuFUfHRj/pavHPAz1nhVNfZZm9xo0uBdwF/nWj8a2YFuOC4J7K6U/JyuS1l7
YvLA/BqRTOW7z6BDBhGy5Dbw0umIGIleNwEZ+K3h7BN92L3vXYkArImdVlaXxwyL
WTpxKS7fkvCuFnGeexoLO9XoOY+CLVjhydz6Juy4PEWHLkO+nGXkJaT8PJpeKmn+
DK1Jmt3KOfSBtb98mtOX
=7hbh
-----END PGP SIGNATURE-----

--JwB53PgKC5A7+0Ej--
