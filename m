Return-path: <linux-media-owner@vger.kernel.org>
Received: from nbfkord-smmo02.seg.att.com ([209.65.160.78]:55976 "EHLO
	nbfkord-smmo02.seg.att.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752179AbbJEPSj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Oct 2015 11:18:39 -0400
Subject: Re: [PATCH 11/15] sfc: don't call dma_supported
To: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Don Fry <pcnet32@frontier.com>,
	Oliver Neukum <oneukum@suse.com>
References: <1443885579-7094-1-git-send-email-hch@lst.de>
 <1443885579-7094-12-git-send-email-hch@lst.de>
CC: <linux-net-drivers@solarflare.com>,
	<dri-devel@lists.freedesktop.org>, <linux-media@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-parisc@vger.kernel.org>,
	<linux-serial@vger.kernel.org>, <linux-usb@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
From: Bert Kenward <bkenward@solarflare.com>
Message-ID: <56129266.8070600@solarflare.com>
Date: Mon, 5 Oct 2015 16:08:22 +0100
MIME-Version: 1.0
In-Reply-To: <1443885579-7094-12-git-send-email-hch@lst.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/10/15 16:19, Christoph Hellwig wrote:
> dma_set_mask already checks for a supported DMA mask before updating it,
> the call to dma_supported is redundant.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Bert Kenward <bkenward@solarflare.com>
The information contained in this message is confidential and is intended for the addressee(s) only. If you have received this message in error, please notify the sender immediately and delete the message. Unless you are an addressee (or authorized to receive for an addressee), you may not use, copy or disclose to anyone this message or any information contained in this message. The unauthorized use, disclosure, copying or alteration of this message is strictly prohibited.
