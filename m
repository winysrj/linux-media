Return-path: <linux-media-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45740 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751284AbeAJIRZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Jan 2018 03:17:25 -0500
Date: Wed, 10 Jan 2018 09:17:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: Joe Perches <joe@perches.com>
Cc: Christoph Hellwig <hch@lst.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-pci@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] media/ttusb-budget: remove pci_zalloc_coherent
        abuse
Message-ID: <20180110081724.GB9810@lst.de>
References: <20180109203939.5930-1-hch@lst.de> <20180109203939.5930-2-hch@lst.de> <1515530966.9619.124.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1515530966.9619.124.camel@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 09, 2018 at 12:49:26PM -0800, Joe Perches wrote:
> This message doesn't make sense anymore and it might as well
> be deleted.
> 
> And it might be better to use kcalloc
> 
> 	ttusb->iso_buffer = kcalloc(FRAMES_PER_ISO_BUF * ISO_BUF_COUNT,
> 				    ISO_FRAME_SIZE, GFP_KERNEL);

Sure.
