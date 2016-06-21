Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39068 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbcFUFyf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2016 01:54:35 -0400
Date: Tue, 21 Jun 2016 07:54:32 +0200
Message-ID: <s5hoa6vxf1j.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	alsa-devel@alsa-project.org, netdev@vger.kernel.org,
	Henrik Austad <henrik@austad.us>, linux-kernel@vger.kernel.org,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Arnd Bergmann <arnd@linaro.org>, linux-media@vger.kernel.org
Subject: Re: [alsa-devel] [very-RFC 0/8] TSN driver for the kernel
In-Reply-To: <20160620152126.GA12638@localhost.localdomain>
References: <20160613114713.GA9544@localhost.localdomain>
	<20160613195136.GC2441@netboy>
	<20160614121844.54a125a5@lxorguk.ukuu.org.uk>
	<5760C84C.40408@sakamocchi.jp>
	<20160615080602.GA13555@localhost.localdomain>
	<5764DA85.3050801@sakamocchi.jp>
	<20160618224549.GF32724@icarus.home.austad.us>
	<9a5abd48-4da3-945d-53c9-b6d37010ab0d@linux.intel.com>
	<20160620121838.GA5257@localhost.localdomain>
	<20160620123148.GA5846@localhost.localdomain>
	<20160620152126.GA12638@localhost.localdomain>
MIME-Version: 1.0 (generated by SEMI 1.14.6 - "Maruoka")
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 20 Jun 2016 17:21:26 +0200,
Richard Cochran wrote:
> 
> On Mon, Jun 20, 2016 at 02:31:48PM +0200, Richard Cochran wrote:
> > Where is this "audio_time" program of which you speak?
> 
> Never mind, found it in alsa-lib.
> 
> I still would appreciate an answer to my other questions, though...

Currently HD-audio (both ASoC and legacy ones) are the only drivers
providing the link timestamp.  In the recent code, it's PCM
get_time_info ops, so you can easily grep it.


HTH,

Takashi
