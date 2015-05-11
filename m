Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:55961 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897AbbEKNqN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2015 09:46:13 -0400
Message-ID: <5550B255.3040404@ti.com>
Date: Mon, 11 May 2015 19:14:53 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>,
	Arun Ramamurthy <arun.ramamurthy@broadcom.com>
CC: Jonathan Corbet <corbet@lwn.net>, Tejun Heo <tj@kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
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
References: <Pine.LNX.4.44L0.1504231031170.1529-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1504231031170.1529-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Thursday 23 April 2015 08:01 PM, Alan Stern wrote:
> On Wed, 22 Apr 2015, Arun Ramamurthy wrote:
>
>> This patch set adds a new API to get phy by index when multiple
>> phys are present. This patch is based on discussion with Arnd Bergmann
>> about dt bindings for multiple phys.
>>
>> History:
>> v1:
>>      - Removed null pointers on Dmitry's suggestion
>>      - Improved documentation in commit messages
>>      - Exported new phy api
>> v2:
>>      - EHCI and OHCI platform Kconfigs select Generic Phy
>>        to fix build errors in certain configs.
>> v3:
>>      - Made GENERIC_PHY an invisible option so
>>      that other configs can select it
>>      - Added stubs for devm_of_phy_get_by_index
>>      - Reformated code
>>
>> Arun Ramamurthy (4):
>>    phy: phy-core: Make GENERIC_PHY an invisible option
>>    phy: core: Add devm_of_phy_get_by_index to phy-core
>>    usb: ehci-platform: Use devm_of_phy_get_by_index
>>    usb: ohci-platform: Use devm_of_phy_get_by_index
>
> For patches 3 and 4:
>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

merged this to linux-phy.

Thanks
Kishon
