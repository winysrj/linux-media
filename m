Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38142 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932354AbdCTSK3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 14:10:29 -0400
Date: Mon, 20 Mar 2017 17:59:57 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
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
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v5 38/39] media: imx: csi: fix crop rectangle reset in
 sink set_fmt
Message-ID: <20170320175957.GS21222@n2100.armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <1489121599-23206-39-git-send-email-steve_longerbeam@mentor.com>
 <20170319152233.GW21222@n2100.armlinux.org.uk>
 <327d67d9-68c1-7f74-0c0f-f6aee1c4b546@gmail.com>
 <1490010926.2917.59.camel@pengutronix.de>
 <20170320120855.GH21222@n2100.armlinux.org.uk>
 <1490018451.2917.86.camel@pengutronix.de>
 <20170320141705.GL21222@n2100.armlinux.org.uk>
 <1490031621.2917.110.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1490031621.2917.110.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 20, 2017 at 06:40:21PM +0100, Philipp Zabel wrote:
> On Mon, 2017-03-20 at 14:17 +0000, Russell King - ARM Linux wrote:
> > I have tripped over a bug in media-ctl when specifying both a crop and
> > compose rectangle - the --help output suggests that "," should be used
> > to separate them.  media-ctl rejects that, telling me the character at
> > the "," should be "]".  Replacing the "," with " " allows media-ctl to
> > accept it and set both rectangles, so it sounds like a parser bug - I've
> > not looked into this any further yet.
> 
> I can confirm this. I don't see any place in
> v4l2_subdev_parse_pad_format that handles the "," separator. There's
> just whitespace skipping between the v4l2-properties.

Maybe this is the easiest solution:

 utils/media-ctl/options.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
index 83ca1ca..8b97874 100644
--- a/utils/media-ctl/options.c
+++ b/utils/media-ctl/options.c
@@ -65,7 +65,7 @@ static void usage(const char *argv0)
 	printf("\tentity          = entity-number | ( '\"' entity-name '\"' ) ;\n");
 	printf("\n");
 	printf("\tv4l2            = pad '[' v4l2-properties ']' ;\n");
-	printf("\tv4l2-properties = v4l2-property { ',' v4l2-property } ;\n");
+	printf("\tv4l2-properties = v4l2-property { ' '* v4l2-property } ;\n");
 	printf("\tv4l2-property   = v4l2-mbusfmt | v4l2-crop | v4l2-interval\n");
 	printf("\t                | v4l2-compose | v4l2-interval ;\n");
 	printf("\tv4l2-mbusfmt    = 'fmt:' fcc '/' size ; { 'field:' v4l2-field ; } { 'colorspace:' v4l2-colorspace ; }\n");

;)

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
