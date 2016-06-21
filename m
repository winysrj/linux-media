Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:45440 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbcFURTs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2016 13:19:48 -0400
Subject: Re: [alsa-devel] [very-RFC 0/8] TSN driver for the kernel
To: Richard Cochran <richardcochran@gmail.com>
References: <1465686096-22156-1-git-send-email-henrik@austad.us>
 <20160613114713.GA9544@localhost.localdomain> <20160613195136.GC2441@netboy>
 <20160614121844.54a125a5@lxorguk.ukuu.org.uk> <5760C84C.40408@sakamocchi.jp>
 <20160615080602.GA13555@localhost.localdomain>
 <5764DA85.3050801@sakamocchi.jp>
 <20160618224549.GF32724@icarus.home.austad.us>
 <9a5abd48-4da3-945d-53c9-b6d37010ab0d@linux.intel.com>
 <20160620121838.GA5257@localhost.localdomain>
 <20160620123148.GA5846@localhost.localdomain>
Cc: Henrik Austad <henrik@austad.us>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	alsa-devel@alsa-project.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@linaro.org>,
	linux-media@vger.kernel.org
From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <8a0e9fad-846a-5924-3e6b-348c2d6c2aec@linux.intel.com>
Date: Tue, 21 Jun 2016 10:18:30 -0700
MIME-Version: 1.0
In-Reply-To: <20160620123148.GA5846@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 6/20/16 5:31 AM, Richard Cochran wrote:
> On Mon, Jun 20, 2016 at 02:18:38PM +0200, Richard Cochran wrote:
>> Documentation/sound/alsa/timestamping.txt says:
>
>    Examples of typestamping with HDaudio:
>
>    1. DMA timestamp, no compensation for DMA+analog delay
>    $ ./audio_time  -p --ts_type=1
>
> Where is this "audio_time" program of which you speak?

alsa-lib/test

