Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:56630
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752833AbaFYCaD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 22:30:03 -0400
Date: Wed, 25 Jun 2014 10:29:41 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Denis Carikli <denis@eukrea.com>, <arm@kernel.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
	<linux-arm-kernel@lists.infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<devel@driverdev.osuosl.org>,
	"Mauro Carvalho Chehab" <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	<dri-devel@lists.freedesktop.org>, David Airlie <airlied@linux.ie>
Subject: Re: [PATCH v14 05/10] ARM: dts: imx5*, imx6*: correct
 display-timings nodes.
Message-ID: <20140625022939.GA5732@dragon>
References: <1402913484-25910-1-git-send-email-denis@eukrea.com>
 <1402913484-25910-5-git-send-email-denis@eukrea.com>
 <20140624150158.GS32514@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140624150158.GS32514@n2100.arm.linux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 24, 2014 at 04:01:58PM +0100, Russell King - ARM Linux wrote:
> On Mon, Jun 16, 2014 at 12:11:19PM +0200, Denis Carikli wrote:
> > The imx-drm driver can't use the de-active and
> > pixelclk-active display-timings properties yet.
> > 
> > Instead the data-enable and the pixel data clock
> > polarity are hardcoded in the imx-drm driver.
> > 
> > So theses properties are now set to keep
> > the same behaviour when imx-drm will start
> > using them.
> > 
> > Signed-off-by: Denis Carikli <denis@eukrea.com>
> 
> This patch needs either an ack from the arm-soc/iMX maintainers, or
> they need to merge it.  As there's little positive agreement on the
> series, I can understand why there's reluctance to merge it.
> 
> So, can we start having some acks from people please, or at least
> commitments to merge this patch when the others are deemed to be
> acceptable.  If not, can we have explanations why this should not
> be merged.

I will be happy to merge dts change through IMX tree once the
binding/diver part gets accepted/applied.

Shawn
