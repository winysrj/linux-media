Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35760 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635AbZCSODu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 10:03:50 -0400
Date: Thu, 19 Mar 2009 11:03:03 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [patch review] radio/Kconfig: introduce 3 groups: isa, pci, and
 others drivers
Message-ID: <20090319110303.7a53f9bb@pedra.chehab.org>
In-Reply-To: <1237467800.19717.37.camel@tux.localhost>
References: <1237467800.19717.37.camel@tux.localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 19 Mar 2009 16:03:20 +0300
Alexey Klimov <klimov.linux@gmail.com> wrote:

> Hello, all
> What do you think about such patch that makes selecting of radio drivers
> in menuconfig more comfortable ?

Frankly, I don't see any gain: If the user doesn't have ISA (or doesn't want to
have), it should have already unselected the ISA sub-menu. The remaining PCI
and USB drivers are few. So, creating menus for them seem overkill.

We could eventually reorganize the item order, and adding a few comments to
indicate the drivers that are ISA, PCI, PCIe and USB (something similar to what
was done at DVB frontend part of the menu), but still, I can't see much value.

Cheers,
Mauro
