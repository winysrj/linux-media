Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:15581 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbcFVMhi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2016 08:37:38 -0400
Subject: Re: [alsa-devel] [very-RFC 0/8] TSN driver for the kernel
To: Richard Cochran <richardcochran@gmail.com>
References: <20160613114713.GA9544@localhost.localdomain>
 <20160613195136.GC2441@netboy> <20160614121844.54a125a5@lxorguk.ukuu.org.uk>
 <5760C84C.40408@sakamocchi.jp> <20160615080602.GA13555@localhost.localdomain>
 <5764DA85.3050801@sakamocchi.jp>
 <20160618224549.GF32724@icarus.home.austad.us>
 <9a5abd48-4da3-945d-53c9-b6d37010ab0d@linux.intel.com>
 <20160620121838.GA5257@localhost.localdomain>
 <07283da9-f6d1-c3b1-7989-a6fce7ca0ee6@linux.intel.com>
 <20160621194001.GB2489@netboy>
Cc: alsa-devel@alsa-project.org, netdev@vger.kernel.org,
	Henrik Austad <henrik@austad.us>, linux-kernel@vger.kernel.org,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Arnd Bergmann <arnd@linaro.org>, linux-media@vger.kernel.org
From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <04675515-ff64-0acc-f0f0-7714e20c1485@linux.intel.com>
Date: Wed, 22 Jun 2016 05:36:42 -0700
MIME-Version: 1.0
In-Reply-To: <20160621194001.GB2489@netboy>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 6/21/16 12:40 PM, Richard Cochran wrote:
> On Tue, Jun 21, 2016 at 10:45:18AM -0700, Pierre-Louis Bossart wrote:
>> You can experiment with the 'dma' and 'link' timestamps today on any
>> HDaudio-based device. Like I said the synchronized part has not been
>> upstreamed yet (delays + dependency on ART-to-TSC conversions that made it
>> in the kernel recently)
>
> Can you point me to any open source apps using the dma/link
> timestamps?

Those timestamps are only used in custom applications at the moment, not 
'mainstream' open source.
It takes time for new kernel capabilities to trickle into userspace, 
applications usually align on the lowest hardware common denominator. In 
addition, most applications don't access the kernel directly but go 
through an audio server or HAL which needs to be updated as well so it's 
a two-level dependency. These timestamps can be directly mappped to the 
Android AudioTrack.getTimeStamp API though.

