Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:38401 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbaFPOi5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 10:38:57 -0400
Received: by mail-lb0-f173.google.com with SMTP id s7so2895163lbd.4
        for <linux-media@vger.kernel.org>; Mon, 16 Jun 2014 07:38:56 -0700 (PDT)
Message-ID: <539F017C.90408@gmail.com>
Date: Mon, 16 Jun 2014 20:38:52 +0600
From: "Alexander E. Patrakov" <patrakov@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Clemens Ladisch <clemens@ladisch.de>
CC: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH 1/3] sound: Add a quirk to enforce period_bytes
References: <1402762571-6316-1-git-send-email-m.chehab@samsung.com> <1402762571-6316-2-git-send-email-m.chehab@samsung.com> <539E9F25.7030504@ladisch.de> <20140616112110.3f509262.m.chehab@samsung.com>
In-Reply-To: <20140616112110.3f509262.m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

16.06.2014 20:21, Mauro Carvalho Chehab wrote:
> Both xawtv and tvtime use the same code for audio:
> 	http://git.linuxtv.org/cgit.cgi/xawtv3.git/tree/common/alsa_stream.c
>
> There's an algorithm there that gets the period size form both the
> capture and the playback cards, trying to find a minimum period that
> would work properly for both.

I don't see any adaptive resampler (similar to what module-loopback does 
in pulseaudio) there. Without that, or dynamically controlling the audio 
capture clock PLL in the tuner, xruns are unavoidable when transferring 
data between two unrelated cards.

So, until any further evidence appears, I think it is a common bug in 
these audio codes.

-- 
Alexander E. Patrakov
