Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932308AbbDWHnv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 03:43:51 -0400
Message-ID: <5538A26B.10302@redhat.com>
Date: Thu, 23 Apr 2015 09:42:35 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Arun Ramamurthy <arun.ramamurthy@broadcom.com>,
	Jonathan Corbet <corbet@lwn.net>, Tejun Heo <tj@kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Kishon Vijay Abraham I <kishon@ti.com>,
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
	Kevin Hao <haokexin@gmail.com>, Jean Delvare <jdelvare@suse.de>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-fbdev@vger.kernel.org, Dmitry Torokhov <dtor@google.com>,
	Anatol Pomazau <anatol@google.com>,
	Jonathan Richardson <jonathar@broadcom.com>,
	Scott Branden <sbranden@broadcom.com>,
	Ray Jui <rjui@broadcom.com>,
	bcm-kernel-feedback-list@broadcom.com
Subject: Re: [PATCHv3 0/4] add devm_of_phy_get_by_index and update platform
 drivers
References: <1429743853-10254-1-git-send-email-arun.ramamurthy@broadcom.com>
In-Reply-To: <1429743853-10254-1-git-send-email-arun.ramamurthy@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 23-04-15 01:04, Arun Ramamurthy wrote:
> This patch set adds a new API to get phy by index when multiple
> phys are present. This patch is based on discussion with Arnd Bergmann
> about dt bindings for multiple phys.
>
> History:
> v1:
>      - Removed null pointers on Dmitry's suggestion
>      - Improved documentation in commit messages
>      - Exported new phy api
> v2:
>      - EHCI and OHCI platform Kconfigs select Generic Phy
>        to fix build errors in certain configs.
> v3:
>      - Made GENERIC_PHY an invisible option so
>      that other configs can select it
>      - Added stubs for devm_of_phy_get_by_index
>      - Reformated code
>
> Arun Ramamurthy (4):
>    phy: phy-core: Make GENERIC_PHY an invisible option
>    phy: core: Add devm_of_phy_get_by_index to phy-core
>    usb: ehci-platform: Use devm_of_phy_get_by_index
>    usb: ohci-platform: Use devm_of_phy_get_by_index
>
>   Documentation/phy.txt                     |  7 +++-
>   drivers/ata/Kconfig                       |  1 -
>   drivers/media/platform/exynos4-is/Kconfig |  2 +-
>   drivers/phy/Kconfig                       |  4 +-
>   drivers/phy/phy-core.c                    | 32 ++++++++++++++
>   drivers/usb/host/Kconfig                  |  4 +-
>   drivers/usb/host/ehci-platform.c          | 69 +++++++++++--------------------
>   drivers/usb/host/ohci-platform.c          | 69 +++++++++++--------------------
>   drivers/video/fbdev/exynos/Kconfig        |  2 +-
>   include/linux/phy/phy.h                   |  8 ++++
>   10 files changed, 100 insertions(+), 98 deletions(-)
>

Patch set looks good to me:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans
