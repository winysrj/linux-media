Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45080 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727726AbeINO7V (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 10:59:21 -0400
Date: Fri, 14 Sep 2018 11:45:38 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] udmabuf: fix error code in map_udmabuf()
Message-ID: <20180914094538.xied3d2zgg5b2atr@sirius.home.kraxel.org>
References: <20180914065615.GA12043@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180914065615.GA12043@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 14, 2018 at 09:56:15AM +0300, Dan Carpenter wrote:
> We accidentally forgot to set "ret" on this error path so it means we
> return NULL instead of an error pointer.  The caller checks for NULL and
> changes it to an error pointer so it doesn't cause an issue at run time.

Pushed to drm-misc-next.

thanks,
  Gerd
