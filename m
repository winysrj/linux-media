Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33712 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S944272AbcJSPTY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 11:19:24 -0400
Date: Wed, 19 Oct 2016 10:01:59 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Thierry Escande <thierry.escande@collabora.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 2/2] [media] vb2: Add support for use_dma_bidirectional
 queue flag
Message-ID: <20161019070158.GP9460@valkosipuli.retiisi.org.uk>
References: <1476446894-4220-1-git-send-email-thierry.escande@collabora.com>
 <1476446894-4220-3-git-send-email-thierry.escande@collabora.com>
 <20161017100632.GM9460@valkosipuli.retiisi.org.uk>
 <664b9541-e7ab-f1b3-b12c-677db0e63fc0@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <664b9541-e7ab-f1b3-b12c-677db0e63fc0@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 18, 2016 at 06:08:53PM +0200, Thierry Escande wrote:
> >#define vb2_dma_dir(q) \

^

VB2_DMA_DIR(), as most of our other macros use capitals as well.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
