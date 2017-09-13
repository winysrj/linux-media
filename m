Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55033 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751435AbdIMC0g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 22:26:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: kieran.bingham@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 3/8] v4l: vsp1: Convert display lists to use new fragment pool
Date: Wed, 13 Sep 2017 05:26:37 +0300
Message-ID: <2301221.HrvjfJSAbq@avalon>
In-Reply-To: <1bc44302-c8e0-973c-b7b8-312e24fe27a6@ideasonboard.com>
References: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com> <1922275.UObh22kbi7@avalon> <1bc44302-c8e0-973c-b7b8-312e24fe27a6@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Monday, 11 September 2017 23:27:39 EEST Kieran Bingham wrote:
> On 17/08/17 13:13, Laurent Pinchart wrote:
> > On Monday 14 Aug 2017 16:13:26 Kieran Bingham wrote:
> >> Adapt the dl->body0 object to use an object from the fragment pool.
> >> This greatly reduces the pressure on the TLB for IPMMU use cases, as
> >> all of the lists use a single allocation for the main body.
> >> 
> >> The CLU and LUT objects pre-allocate a pool containing two bodies,
> >> allowing a userspace update before the hardware has committed a previous
> >> set of tables.
> > 
> > I think you'll need three bodies, one for the DL queued to the hardware,
> > one for the pending DL and one for the new DL needed when you update the
> > LUT/CLU. Given that the VSP test suite hasn't caught this problem, we
> > also need a new test :-)
> > 
> >> Fragments are no longer 'freed' in interrupt context, but instead
> >> released back to their respective pools.  This allows us to remove the
> >> garbage collector in the DLM.
> >> 
> >> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> >> 
> >> ---
> >> 
> >> v2:
> >>  - Use dl->body0->max_entries to determine header offset, instead of the
> >>    global constant VSP1_DL_NUM_ENTRIES which is incorrect.
> >>  
> >>  - squash updates for LUT, CLU, and fragment cleanup into single patch.
> >>    (Not fully bisectable when separated)
> >> 
> >> ---
> >> 
> >>  drivers/media/platform/vsp1/vsp1_clu.c |  22 ++-
> >>  drivers/media/platform/vsp1/vsp1_clu.h |   1 +-
> >>  drivers/media/platform/vsp1/vsp1_dl.c  | 223 +++++---------------------
> >>  drivers/media/platform/vsp1/vsp1_dl.h  |   3 +-
> >>  drivers/media/platform/vsp1/vsp1_lut.c |  23 ++-
> >>  drivers/media/platform/vsp1/vsp1_lut.h |   1 +-
> >>  6 files changed, 90 insertions(+), 183 deletions(-)
> > 
> > This is a nice diffstat, but only if you add kerneldoc for the new
> > functions introduced in patch 2/8, otherwise the overall documentation
> > diffstat looks bad :-)

[snip]

> >> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c
> >> b/drivers/media/platform/vsp1/vsp1_dl.c index aab9dd6ec0eb..6ffdc3549283
> >> 100644
> >> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> >> +++ b/drivers/media/platform/vsp1/vsp1_dl.c

[snip]

> >>  static void vsp1_dl_list_free(struct vsp1_dl_list *dl)
> >>  {
> >> 
> >> -	vsp1_dl_body_cleanup(&dl->body0);
> >> -	list_splice_init(&dl->fragments, &dl->dlm->gc_fragments);
> >> +	vsp1_dl_fragment_put(dl->body0);
> >> +	vsp1_dl_list_fragments_free(dl);
> > 
> > I wonder whether the second line is actually needed. vsp1_dl_list_free()
> > is called from vsp1_dlm_destroy() for every entry in the dlm->free list. A
> > DL can only be put in that list by vsp1_dlm_create() or
> > __vsp1_dl_list_put(). The former creates lists with no fragment, while
> > the latter calls vsp1_dl_list_fragments_free() already.
> > 
> > If you're not entirely sure you could add a WARN_ON(!list_empty(&dl-
> > >fragments)) and run the test suite. A comment explaining why the
> > fragments list should already be empty here would be useful too.
> 
> You may be right here, but would you object to leaving it in ?
> 
> Isn't it correct to ensure that the list is completely cleaned up on
> release?
> 
> Furthermore - I would anticipate that in the future - 'body0' could be
> removed, (becoming a fragment) and thus this line would then be required.
> 
> ## /where 's/fragments/bodies/g' applies to the above text. ##

I'm fine with that for now.

> >> +
> >> 
> >>  	kfree(dl);
> >>  }

-- 
Regards,

Laurent Pinchart
