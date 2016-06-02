Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45366 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932383AbcFBV1u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Jun 2016 17:27:50 -0400
Date: Fri, 3 Jun 2016 00:27:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	pali.rohar@gmail.com, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH] device tree description for AD5820 camera auto-focus coil
Message-ID: <20160602212746.GT26360@valkosipuli.retiisi.org.uk>
References: <20160524090433.GA1277@amd>
 <20160524091746.GA14536@amd>
 <20160525212659.GK26360@valkosipuli.retiisi.org.uk>
 <20160527205140.GA26767@amd>
 <20160531212222.GP26360@valkosipuli.retiisi.org.uk>
 <20160531213437.GA28397@amd>
 <20160601152439.GQ26360@valkosipuli.retiisi.org.uk>
 <20160601220840.GA21946@amd>
 <20160602074544.GR26360@valkosipuli.retiisi.org.uk>
 <20160602193027.GB7984@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160602193027.GB7984@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 02, 2016 at 09:30:27PM +0200, Pavel Machek wrote:
> 
> Add documentation for ad5820 device tree binding.
> 
> Signed-off-by: Pavel Machek <pavel@denx.de>

Thanks, Pavel!!

Can I pick the two patches (this one + the driver) or would you like to send
a pull request? In the latter case you can add:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
