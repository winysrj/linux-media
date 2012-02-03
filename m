Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37339 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab2BCJLD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2012 04:11:03 -0500
Date: Fri, 3 Feb 2012 09:10:38 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [dmaengine] [Q] jiffies value does not increase in
	dma_sync_wait()
Message-ID: <20120203091038.GI889@n2100.arm.linux.org.uk>
References: <CACKLOr26BuTh8Qr8pFHoTJoyCW9ty4-Kg-YRisXmN3=spzY6_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACKLOr26BuTh8Qr8pFHoTJoyCW9ty4-Kg-YRisXmN3=spzY6_Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 03, 2012 at 09:37:48AM +0100, javier Martin wrote:
> I've introduced a couple of printk() to check why this timeout is not
> triggered and I've found that the value of jiffies does not increase
> between loop iterations (i. e. it's like time didn't advance).
> 
> Does anyobody know what reasons could make jiffies not being updated?

Are interrupts disabled?
