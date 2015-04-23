Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52920 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754778AbbDWObp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 10:31:45 -0400
Date: Thu, 23 Apr 2015 10:31:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
cc: Jonathan Corbet <corbet@lwn.net>, Tejun Heo <tj@kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Kishon Vijay Abraham I <kishon@ti.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
	Jean Delvare <jdelvare@suse.de>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
	<linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
	<linux-fbdev@vger.kernel.org>, Dmitry Torokhov <dtor@google.com>,
	Anatol Pomazau <anatol@google.com>,
	Jonathan Richardson <jonathar@broadcom.com>,
	Scott Branden <sbranden@broadcom.com>,
	Ray Jui <rjui@broadcom.com>,
	<bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCHv3 0/4] add devm_of_phy_get_by_index and update platform
 drivers
In-Reply-To: <1429743853-10254-1-git-send-email-arun.ramamurthy@broadcom.com>
Message-ID: <Pine.LNX.4.44L0.1504231031170.1529-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 22 Apr 2015, Arun Ramamurthy wrote:

> This patch set adds a new API to get phy by index when multiple 
> phys are present. This patch is based on discussion with Arnd Bergmann
> about dt bindings for multiple phys.
> 
> History:
> v1:
>     - Removed null pointers on Dmitry's suggestion
>     - Improved documentation in commit messages
>     - Exported new phy api
> v2:
>     - EHCI and OHCI platform Kconfigs select Generic Phy
>       to fix build errors in certain configs.
> v3:
>     - Made GENERIC_PHY an invisible option so 
>     that other configs can select it
>     - Added stubs for devm_of_phy_get_by_index
>     - Reformated code
> 
> Arun Ramamurthy (4):
>   phy: phy-core: Make GENERIC_PHY an invisible option
>   phy: core: Add devm_of_phy_get_by_index to phy-core
>   usb: ehci-platform: Use devm_of_phy_get_by_index
>   usb: ohci-platform: Use devm_of_phy_get_by_index

For patches 3 and 4:

Acked-by: Alan Stern <stern@rowland.harvard.edu>

