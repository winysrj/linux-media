Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:64303 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751321AbeANWzM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 14 Jan 2018 17:55:12 -0500
Date: Mon, 15 Jan 2018 00:55:09 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Yong Zhi <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        Cao Bing Bu <bingbu.cao@intel.com>
Subject: Re: [PATCH 2/2] media: intel-ipu3: cio2: fix for wrong vb2buf state
 warnings
Message-ID: <20180114225508.5oa54rjxilum4tvm@kekkonen.localdomain>
References: <1515034637-3517-1-git-send-email-yong.zhi@intel.com>
 <1515034637-3517-2-git-send-email-yong.zhi@intel.com>
 <CAAFQd5AaOSQ_wcA_w5vBufVk5FfLPe6x9BnS=hcShv_asf3Cyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5AaOSQ_wcA_w5vBufVk5FfLPe6x9BnS=hcShv_asf3Cyw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz and others,

On Fri, Jan 12, 2018 at 05:19:04PM +0900, Tomasz Figa wrote:
> On Thu, Jan 4, 2018 at 11:57 AM, Yong Zhi <yong.zhi@intel.com> wrote:
...
> > @@ -793,7 +794,7 @@ static void cio2_vb2_return_all_buffers(struct cio2_queue *q)
> >                 if (q->bufs[i]) {
> >                         atomic_dec(&q->bufs_queued);
> >                         vb2_buffer_done(&q->bufs[i]->vbb.vb2_buf,
> > -                                       VB2_BUF_STATE_ERROR);
> > +                                       state);
> 
> nit: Does it really exceed 80 characters after folding into previous line?
> 
> With the nit fixed:
> Reviewed-by: Tomasz Figa <tfiga@chromium.org>

The patches have been merged to media tree master; if there are matters to
address, then please send more patches on top of the master branch. :-)

Thanks.

-- 
Cheers,

Sakari Ailus
sakari.ailus@linux.intel.com
