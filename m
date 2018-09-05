Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:45484 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726272AbeIELDS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Sep 2018 07:03:18 -0400
Date: Wed, 5 Sep 2018 08:34:38 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma-buf/udmabuf: Fix NULL pointer dereference in
 udmabuf_create
Message-ID: <20180905063438.qpb6fpexq6rz6rxl@sirius.home.kraxel.org>
References: <20180904190749.GA9308@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180904190749.GA9308@embeddedor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 04, 2018 at 02:07:49PM -0500, Gustavo A. R. Silva wrote:
> There is a potential execution path in which pointer memfd is NULL when
> passed as argument to fput(), hence there is a NULL pointer dereference
> in fput().
> 
> Fix this by null checking *memfd* before calling fput().
> 
> Addresses-Coverity-ID: 1473174 ("Explicit null dereferenced")
> Fixes: fbb0de795078 ("Add udmabuf misc device")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Pushed to drm-misc-next.

thanks,
  Gerd
