Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:48858 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab0BHMYs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 07:24:48 -0500
Message-ID: <4B700287.5080900@linuxtv.org>
Date: Mon, 08 Feb 2010 13:24:39 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Francesco Lavra <francescolavra@interfree.it>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] dvb-core: fix initialization of feeds list in demux filter
References: <1265546998.9356.4.camel@localhost> <4B6F72E5.3040905@redhat.com>
In-Reply-To: <4B6F72E5.3040905@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

Mauro Carvalho Chehab wrote:
> Good catch, but it seems better to initialize both the mutex and the list head
> at dvb_dmx_dev_init. Please test if the following patch fixes the issue. If so, please
> sign.

please apply Francesco's original patch. Yours won't work, because
"feed" is a union. It must be initialized each time DMX_SET_PES_FILTER
gets called, because the memory might have been overwritten by a
previous call to DMX_SET_FILTER, which uses "feed.sec".

Regards,
Andreas
