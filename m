Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:42892 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730351AbeHBXPA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 19:15:00 -0400
Date: Thu, 2 Aug 2018 18:22:00 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-media@vger.kernel.org, tglx@linutronix.de,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2nd REPOST 0/5] media: use irqsave() in USB's complete
 callback
Message-ID: <20180802182200.3b3cbbd0@coco.lan>
In-Reply-To: <20180802203948.d4cwty7uz6i6ijyw@linutronix.de>
References: <20180710161833.2435-1-bigeasy@linutronix.de>
        <20180802144743.38fc779b@coco.lan>
        <20180802203948.d4cwty7uz6i6ijyw@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 2 Aug 2018 22:39:49 +0200
Sebastian Andrzej Siewior <bigeasy@linutronix.de> escreveu:

> On 2018-08-02 14:47:43 [-0300], Mauro Carvalho Chehab wrote:
> > Sorry for the long wait... has been busy those days with two international
> > trips to the opposite side of the world.  
> 
> No worries. At some point I wasn't if you are receiving my emails.

The risk of losing patches is now... media workflow is based on
patchwork:
	https://patchwork.linuxtv.org/project/linux-media/list/

If the patch sent to linux-media@vger.kernel.org is stored there,
we should be handling it sooner or later ;-)

Regards,
Mauro
