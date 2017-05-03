Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36836 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754354AbdECUY3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 May 2017 16:24:29 -0400
Date: Wed, 3 May 2017 22:24:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCHv2] omap3isp: add support for CSI1 bus
Message-ID: <20170503202427.GA18616@amd>
References: <10545906.Gxg3yScdu4@avalon>
 <20170215094228.GA8586@amd>
 <2414221.XNA4JCFMRx@avalon>
 <20170302090143.GB27818@amd>
 <20170302101603.GE27818@amd>
 <20170302112401.GF3220@valkosipuli.retiisi.org.uk>
 <20170302123848.GA28230@amd>
 <20170304130318.GU3220@valkosipuli.retiisi.org.uk>
 <db549a81-0c1f-3ff0-6293-050ec2e0af84@iki.fi>
 <20170503195039.GB12396@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <20170503195039.GB12396@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> It seems they don't compile. Hmmm. Did I do something wrong? "struct
> fwnode_endpoint" seems to be only used in v4l2-fwnode.h; that can't be ri=
ght...?

Next problem is missing dev_fwnode; fixed. Next problem is

pavel@duo:/data/l/linux-n900$ git grep fwnode_graph_get_next_endpoint
=2E
drivers/media/i2c/smiapp/smiapp-core.c: ep =3D
fwnode_graph_get_next_endpoint(fwnode, NULL);
drivers/media/platform/omap3isp/isp.c:  while ((fwnode =3D
fwnode_graph_get_next_endpoint(dev_fwnode(dev),

So sorry, I guess I should wait for version that compiles ;-).
									Pavel

diff --git a/drivers/base/property.c b/drivers/base/property.c
index c458c63..f52a260 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -182,11 +182,6 @@ static int pset_prop_read_string(struct property_set *=
pset,
 	return 0;
 }
=20
-static inline struct fwnode_handle *dev_fwnode(struct device *dev)
-{
-	return IS_ENABLED(CONFIG_OF) && dev->of_node ?
-		&dev->of_node->fwnode : dev->fwnode;
-}
=20
 /**
  * device_property_present - check if a property of a device is present
diff --git a/include/linux/fwnode.h b/include/linux/fwnode.h
index 8bd28ce..9215e23 100644
--- a/include/linux/fwnode.h
+++ b/include/linux/fwnode.h
@@ -27,4 +27,10 @@ struct fwnode_handle {
 	struct fwnode_handle *secondary;
 };
=20
+static inline struct fwnode_handle *dev_fwnode(struct device *dev)
+{
+	return IS_ENABLED(CONFIG_OF) && dev->of_node ?
+		&dev->of_node->fwnode : dev->fwnode;
+}
+
 #endif
diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index d762a55..9e9cfbc 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -80,7 +80,7 @@ struct v4l2_fwnode_bus_mipi_csi1 {
  * @nr_of_link_frequencies: number of elements in link_frequenccies array
  */
 struct v4l2_fwnode_endpoint {
-	struct fwnode_endpoint base;
+	/*struct fwnode_endpoint base; */
 	/*
 	 * Fields below this line will be zeroed by
 	 * v4l2_fwnode_parse_endpoint()




--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkKPHsACgkQMOfwapXb+vIaHACfSgiXwk3jq4RWUPgHt2kgFjrE
HxkAnj9ZAjaKW70+NqbfkVbwYpAR+K53
=OvKk
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
