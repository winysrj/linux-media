Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50277 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570Ab0A2CIP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2010 21:08:15 -0500
Message-ID: <4B624309.9040700@infradead.org>
Date: Fri, 29 Jan 2010 00:08:09 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: cx18 fix patches
References: <4B60F901.20301@redhat.com> <1264681562.3081.3.camel@palomino.walls.org>
In-Reply-To: <1264681562.3081.3.camel@palomino.walls.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> Now I'll just review and test tonight (some time between 6:00 - 10:30
> p.m. EST)

One more error (on x86_64):

drivers/media/video/cx18/cx18-alsa-pcm.c: In function ‘cx18_alsa_announce_pcm_data’:
drivers/media/video/cx18/cx18-alsa-pcm.c:82: warning: format ‘%d’ expects type ‘int’, but argument 5 has type ‘size_t’

You should use %zu for size_t.

Cheers,
Mauro
