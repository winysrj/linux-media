Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58901 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbbHTVvE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2015 17:51:04 -0400
Subject: Re: [PATCH 00/18] Export SPI and OF module aliases in missing drivers
To: Brian Norris <computersforpeace@gmail.com>
References: <1440054451-1223-1-git-send-email-javier@osg.samsung.com>
 <20150820211152.GI74600@google.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
	linux-fbdev@vger.kernel.org,
	Michael Hennerich <Michael.Hennerich@analog.com>,
	linux-iio@vger.kernel.org, linux-wireless@vger.kernel.org,
	Lee Jones <lee.jones@linaro.org>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	linux-mtd@lists.infradead.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	=?UTF-8?Q?S=c3=b8ren_Andersen?= <san@rosetechnology.dk>,
	devel@driverdev.osuosl.org, Randy Dunlap <rdunlap@infradead.org>,
	Masanari Iida <standby24x7@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Devendra Naga <devendra.aaru@gmail.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Stephen Warren <swarren@nvidia.com>,
	=?UTF-8?Q?Urs_F=c3=a4ssler?= <urs.fassler@bytesatwork.ch>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>,
	George McCollister <george.mccollister@gmail.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Manfred Schlaegl <manfred.schlaegl@gmx.at>,
	linux-omap@vger.kernel.org, Hartmut Knaack <knaack.h@gmx.de>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Antonio Borneo <borneo.antonio@gmail.com>,
	Andrea Galbusera <gizero@gmail.com>,
	Michael Welling <mwelling@ieee.org>,
	Fabian Frederick <fabf@skynet.be>,
	Mark Brown <broonie@kernel.org>, linux-mmc@vger.kernel.org,
	linux-spi@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
	David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org,
	linux-media@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>
Message-ID: <55D64BBA.7070802@osg.samsung.com>
Date: Thu, 20 Aug 2015 23:50:50 +0200
MIME-Version: 1.0
In-Reply-To: <20150820211152.GI74600@google.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Brian,

On 08/20/2015 11:11 PM, Brian Norris wrote:
> On Thu, Aug 20, 2015 at 09:07:13AM +0200, Javier Martinez Canillas wrote:
>> Patches #1 and #2 solves a), patches #3 to #8 solves b) and patches
> 
> ^^^ I'm dying to know how this sentence ends :)
>

Sigh, I did some last minute restructuring of the cover letter and
seems I missed a sentence. I meant to said:

"and patches #9 to #17 solves c)."
 
>> Patch #18 changes the logic of spi_uevent() to report an OF modalias if
>> the device was registered using OF. But this patch is included in the
>> series only as an RFC for illustration purposes since changing that
>> without first applying all the other patches in this series, will break
>> module autoloading for the drivers of devices registered using OF but
>> that lacks an of_match_table. I'll repost patch #18 once all the patches
>> in this series have landed.
> 
> On a more productive note, the patches I've looked at look good to me.
> The missing aliases are a problem enough that should be fixed (i.e.,
> part (b)). I'll leave the SPI framework changes to others to comment on.
>

Great, thanks a lot for your feedback.
 
> Brian
> 

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
