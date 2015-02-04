Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:46511 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbbBDAOy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 19:14:54 -0500
Date: Wed, 4 Feb 2015 00:14:39 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-mm-sig@lists.linaro.org, Daniel Vetter <daniel@ffwll.ch>,
	linaro-kernel@lists.linaro.org,
	Robin Murphy <robin.murphy@arm.com>,
	LKML <linux-kernel@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Rob Clark <robdclark@gmail.com>,
	Tomasz Stanislawski <stanislawski.tomasz@googlemail.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [Linaro-mm-sig] [RFCv3 2/2] dma-buf: add helpers for sharing
 attacher constraints with dma-parms
Message-ID: <20150204001439.GB8656@n2100.arm.linux.org.uk>
References: <1422347154-15258-1-git-send-email-sumit.semwal@linaro.org>
 <7233574.nKiRa7HnXU@wuerfel>
 <20150203200435.GX14009@phenom.ffwll.local>
 <3327782.QV7DJfvifL@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3327782.QV7DJfvifL@wuerfel>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 03, 2015 at 10:42:26PM +0100, Arnd Bergmann wrote:
> Right, if you have a private iommu, there is no problem. The tricky part
> is using a single driver for the system-level translation and the gpu
> private mappings when there is only one type of iommu in the system.

You've got a problem anyway with this approach.  If you look at my
figure 2 and apply it to this scenario, you have two MMUs stacked
on top of each other.  That's something that (afaik) we don't support,
but it's entirely possible that will come along with ARM64.

It may not be nice to have to treat GPUs specially, but I think we
really do need to, and forget the idea that the GPU's IOMMU (as
opposed to a system MMU) should appear in a generic form in DT.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
