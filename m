Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:36500 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbbE2NJo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2015 09:09:44 -0400
Date: Fri, 29 May 2015 09:09:39 -0400
From: Tejun Heo <tj@kernel.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Arun Ramamurthy <arun.ramamurthy@broadcom.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Tony Prisk <linux@prisktech.co.nz>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Arnd Bergmann <arnd@arndb.de>, Felipe Balbi <balbi@ti.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Paul Bolle <pebolle@tiscali.nl>,
	Thomas Pugliese <thomas.pugliese@gmail.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Masanari Iida <standby24x7@gmail.com>,
	David Mosberger <davidm@egauge.net>,
	Peter Griffin <peter.griffin@linaro.org>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kevin Hao <haokexin@gmail.com>,
	Jean Delvare <jdelvare@suse.de>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-fbdev@vger.kernel.org, Dmitry Torokhov <dtor@google.com>,
	Anatol Pomazau <anatol@google.com>,
	Jonathan Richardson <jonathar@broadcom.com>,
	Scott Branden <sbranden@broadcom.com>,
	Ray Jui <rjui@broadcom.com>,
	bcm-kernel-feedback-list@broadcom.com, maxime.coquelin@st.com
Subject: Re: [PATCHv3 1/4] phy: phy-core: Make GENERIC_PHY an invisible option
Message-ID: <20150529130939.GG27479@htj.duckdns.org>
References: <1429743853-10254-1-git-send-email-arun.ramamurthy@broadcom.com>
 <1429743853-10254-2-git-send-email-arun.ramamurthy@broadcom.com>
 <55685D7E.9000700@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55685D7E.9000700@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 29, 2015 at 06:07:18PM +0530, Kishon Vijay Abraham I wrote:
> Tejun, Maxime, Sylwester, Kyungmin
> 
> On Thursday 23 April 2015 04:34 AM, Arun Ramamurthy wrote:
> >Most of the phy providers use "select" to enable GENERIC_PHY. Since select
> >is only recommended when the config is not visible, GENERIC_PHY is changed
> >an invisible option. To maintain consistency, all phy providers are changed
> >to "select" GENERIC_PHY and all non-phy drivers use "depends on" when the
> >phy framework is explicity required. USB_MUSB_OMAP2PLUS has a cyclic
> >dependency, so it is left as "select".
> >
> >Signed-off-by: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
> 
> Need your ACK for this patch.

For ATA part,

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
