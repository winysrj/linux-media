Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:52709 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054Ab3ICP0x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Sep 2013 11:26:53 -0400
Message-ID: <5225FF63.6080608@ti.com>
Date: Tue, 3 Sep 2013 20:55:23 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
MIME-Version: 1.0
To: <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
CC: <balbi@ti.com>, <kyungmin.park@samsung.com>, <jg1.han@samsung.com>,
	<s.nawrocki@samsung.com>, <kgene.kim@samsung.com>,
	<stern@rowland.harvard.edu>, <broonie@kernel.org>,
	<tomasz.figa@gmail.com>, <arnd@arndb.de>,
	<grant.likely@linaro.org>, <tony@atomide.com>,
	<swarren@nvidia.com>, <devicetree@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<linux-fbdev@vger.kernel.org>, <akpm@linux-foundation.org>,
	<balajitk@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
	<linux@arm.linux.org.uk>
Subject: Re: [PATCH v11 0/8] PHY framework
References: <1377063973-22044-1-git-send-email-kishon@ti.com> <521B0E79.6060506@ti.com> <20130827192059.GZ3005@radagast>
In-Reply-To: <20130827192059.GZ3005@radagast>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Greg,

On Wednesday 28 August 2013 12:50 AM, Felipe Balbi wrote:
> Hi,
> 
> On Mon, Aug 26, 2013 at 01:44:49PM +0530, Kishon Vijay Abraham I wrote:
>> On Wednesday 21 August 2013 11:16 AM, Kishon Vijay Abraham I wrote:
>>> Added a generic PHY framework that provides a set of APIs for the PHY drivers
>>> to create/destroy a PHY and APIs for the PHY users to obtain a reference to
>>> the PHY with or without using phandle.
>>>
>>> This framework will be of use only to devices that uses external PHY (PHY
>>> functionality is not embedded within the controller).
>>>
>>> The intention of creating this framework is to bring the phy drivers spread
>>> all over the Linux kernel to drivers/phy to increase code re-use and to
>>> increase code maintainability.
>>>
>>> Comments to make PHY as bus wasn't done because PHY devices can be part of
>>> other bus and making a same device attached to multiple bus leads to bad
>>> design.
>>>
>>> If the PHY driver has to send notification on connect/disconnect, the PHY
>>> driver should make use of the extcon framework. Using this susbsystem
>>> to use extcon framwork will have to be analysed.
>>>
>>> You can find this patch series @
>>> git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git testing
>>
>> Looks like there are not further comments on this series. Can you take this in
>> your misc tree?
> 
> Do you want me to queue these for you ? There are quite a few users for
> this framework already and I know of at least 2 others which will show
> up for v3.13.

Can you queue this patch series? There are quite a few users already for this
framework.

Thanks
Kishon
