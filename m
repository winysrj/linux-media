Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:51867 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756210AbbKSKg3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 05:36:29 -0500
Subject: Re: [PATCH 02/13] dmaengine: Introduce
 dma_request_slave_channel_compat_reason()
To: Andy Shevchenko <andy.shevchenko@gmail.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <1432646768-12532-3-git-send-email-peter.ujfalusi@ti.com>
 <20150529093317.GF3140@localhost>
 <CAMuHMdVJ0h9qXxBWH9L2y4O2KLkEq12KW_6k8rTgi+Lux=C0gw@mail.gmail.com>
 <20150529101846.GG3140@localhost> <55687892.7050606@ti.com>
 <20150602125535.GS3140@localhost> <5570758E.6030302@ti.com>
 <20150612125837.GJ28601@localhost> <5587F1F4.1060905@ti.com>
 <20150624162401.GP19530@localhost> <564C8966.9080406@ti.com>
 <CAHp75VdhKmTVjRQp9q_4CXBuqjKvkBjDvgXYRDGmhdHzCW9ADA@mail.gmail.com>
CC: Vinod Koul <vinod.koul@intel.com>,
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
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Message-ID: <564DA61E.2070004@ti.com>
Date: Thu, 19 Nov 2015 12:36:14 +0200
MIME-Version: 1.0
In-Reply-To: <CAHp75VdhKmTVjRQp9q_4CXBuqjKvkBjDvgXYRDGmhdHzCW9ADA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/18/2015 05:46 PM, Andy Shevchenko wrote:
> On Wed, Nov 18, 2015 at 4:21 PM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
>> Hi Vinod,
>>
>> bringing this old thread back to life as I just started to work on this.
> 
> What I remember we need to convert drivers to use new API meanwhile it
> is good to keep old one to avoid patch storm which does nothing useful
> (IIRC Russel's opinion).

I tend to agree. But we need to start converting the users at some point
either way.
Another issue is the fact that the current dmaengine API is using all the good
names I can think of ;)

> On the other hand there are a lot of drivers that are used on the set
> of platforms starting from legacy and abandoned ones (like AVR32) to
> relatively new and newest.
> 
> And I'm not a fan of those thousands of API calls either.
> 

-- 
Péter
