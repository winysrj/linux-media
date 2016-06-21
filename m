Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:35475 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbcFUGjH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2016 02:39:07 -0400
Date: Tue, 21 Jun 2016 08:38:57 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	alsa-devel@alsa-project.org, netdev@vger.kernel.org,
	Henrik Austad <henrik@austad.us>, linux-kernel@vger.kernel.org,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Arnd Bergmann <arnd@linaro.org>, linux-media@vger.kernel.org
Subject: Re: [alsa-devel] [very-RFC 0/8] TSN driver for the kernel
Message-ID: <20160621063856.GA1828@netboy>
References: <20160614121844.54a125a5@lxorguk.ukuu.org.uk>
 <5760C84C.40408@sakamocchi.jp>
 <20160615080602.GA13555@localhost.localdomain>
 <5764DA85.3050801@sakamocchi.jp>
 <20160618224549.GF32724@icarus.home.austad.us>
 <9a5abd48-4da3-945d-53c9-b6d37010ab0d@linux.intel.com>
 <20160620121838.GA5257@localhost.localdomain>
 <20160620123148.GA5846@localhost.localdomain>
 <20160620152126.GA12638@localhost.localdomain>
 <s5hoa6vxf1j.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hoa6vxf1j.wl-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 21, 2016 at 07:54:32AM +0200, Takashi Iwai wrote:
> > I still would appreciate an answer to my other questions, though...
> 
> Currently HD-audio (both ASoC and legacy ones) are the only drivers
> providing the link timestamp.  In the recent code, it's PCM
> get_time_info ops, so you can easily grep it.

Yes, I found that myself, thanks.
 
> HTH,

No it doesn't help me, because I asked three questions, and none were
about the link timestamp.

Thanks,
Richard
