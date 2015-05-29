Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:65415 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbbE2NN7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2015 09:13:59 -0400
Message-id: <55686606.1010701@samsung.com>
Date: Fri, 29 May 2015 15:13:42 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>,
	Arun Ramamurthy <arun.ramamurthy@broadcom.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Tejun Heo <tj@kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
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
References: <1429743853-10254-1-git-send-email-arun.ramamurthy@broadcom.com>
 <1429743853-10254-2-git-send-email-arun.ramamurthy@broadcom.com>
 <55685D7E.9000700@ti.com>
In-reply-to: <55685D7E.9000700@ti.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29/05/15 14:37, Kishon Vijay Abraham I wrote:
> Tejun, Maxime, Sylwester, Kyungmin
> 
> On Thursday 23 April 2015 04:34 AM, Arun Ramamurthy wrote:
>> Most of the phy providers use "select" to enable GENERIC_PHY. Since select
>> is only recommended when the config is not visible, GENERIC_PHY is changed
>> an invisible option. To maintain consistency, all phy providers are changed
>> to "select" GENERIC_PHY and all non-phy drivers use "depends on" when the
>> phy framework is explicity required. USB_MUSB_OMAP2PLUS has a cyclic
>> dependency, so it is left as "select".
>>
>> Signed-off-by: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
> 
> Need your ACK for this patch.

For
	drivers/media/platform/exynos4-is/Kconfig
	drivers/video/fbdev/exynos/Kconfig

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--
Thanks,
Sylwester
