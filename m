Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:32793 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbcFWN2K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jun 2016 09:28:10 -0400
Date: Thu, 23 Jun 2016 15:28:05 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Henrik Austad <henrik@austad.us>
Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	alsa-devel@alsa-project.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@linaro.org>,
	linux-media@vger.kernel.org
Subject: Re: [alsa-devel] [very-RFC 0/8] TSN driver for the kernel
Message-ID: <20160623132805.GC7122@localhost.localdomain>
References: <20160613195136.GC2441@netboy>
 <20160614121844.54a125a5@lxorguk.ukuu.org.uk>
 <5760C84C.40408@sakamocchi.jp>
 <20160615080602.GA13555@localhost.localdomain>
 <5764DA85.3050801@sakamocchi.jp>
 <20160618224549.GF32724@icarus.home.austad.us>
 <9a5abd48-4da3-945d-53c9-b6d37010ab0d@linux.intel.com>
 <20160620121838.GA5257@localhost.localdomain>
 <07283da9-f6d1-c3b1-7989-a6fce7ca0ee6@linux.intel.com>
 <20160623103848.GG32724@icarus.home.austad.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160623103848.GG32724@icarus.home.austad.us>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 23, 2016 at 12:38:48PM +0200, Henrik Austad wrote:
> Richard: is it fair to assume that if ptp4l is running and is part of a PTP 
> domain, ktime_get() will return PTP-adjusted time for the system?

No.

> Or do I also need to run phc2sys in order to sync the system-time
> to PTP-time?

Yes, unless you are using SW time stamping, in which case ptp4l will
steer the system clock directly.

HTH,
Richard



