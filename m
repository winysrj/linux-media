Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f173.google.com ([209.85.160.173]:34979 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760081AbbKTMYI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2015 07:24:08 -0500
MIME-Version: 1.0
In-Reply-To: <6118451.vaLZWOZEF5@wuerfel>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
	<4533695.7ZVFN1S94o@wuerfel>
	<564EF502.6040708@ti.com>
	<6118451.vaLZWOZEF5@wuerfel>
Date: Fri, 20 Nov 2015 14:24:06 +0200
Message-ID: <CAHp75VdoHqPMNGFfz4mPhX+Lw+vxgiyqFS8j5+kQ9Z9CHt=OTA@mail.gmail.com>
Subject: Re: [PATCH 02/13] dmaengine: Introduce dma_request_slave_channel_compat_reason()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Vinod Koul <vinod.koul@intel.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Tony Lindgren <tony@atomide.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	dmaengine <dmaengine@vger.kernel.org>,
	"linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Linux MMC List <linux-mmc@vger.kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-spi <linux-spi@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	ALSA Development Mailing List <alsa-devel@alsa-project.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 20, 2015 at 12:58 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 20 November 2015 12:25:06 Peter Ujfalusi wrote:
>> On 11/19/2015 01:25 PM, Arnd Bergmann wrote:

> Another idea would be to remove the filter function from struct dma_chan_map
> and pass the map through platform data

Why not unified device properties?

-- 
With Best Regards,
Andy Shevchenko
