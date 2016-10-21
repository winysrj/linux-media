Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50212 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932407AbcJUJO0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 05:14:26 -0400
Date: Fri, 21 Oct 2016 12:13:47 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Thierry Escande <thierry.escande@collabora.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v3] [media] vb2: Add support for
 capture_dma_bidirectional queue flag
Message-ID: <20161021091347.GB9460@valkosipuli.retiisi.org.uk>
References: <1477034705-5829-1-git-send-email-thierry.escande@collabora.com>
 <20161021074845.GZ9460@valkosipuli.retiisi.org.uk>
 <f3a6dbd1-62d6-826c-e89a-282ce51eeab4@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3a6dbd1-62d6-826c-e89a-282ce51eeab4@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thierry,

On Fri, Oct 21, 2016 at 10:53:22AM +0200, Thierry Escande wrote:
> #define VB2_DMA_DIR_CAPTURE(d) \
> 		((d) == DMA_FROM_DEVICE || (d) == DMA_BIDIRECTIONAL)

That looks good to me.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
