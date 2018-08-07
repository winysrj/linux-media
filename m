Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:35276 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732510AbeHGSlE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 14:41:04 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: kieran.bingham+renesas@ideasonboard.com
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: vsp1_dl: add a description for cmdpool field
Date: Tue, 07 Aug 2018 19:26:42 +0300
Message-ID: <46485775.Lhs2cjB2RI@avalon>
In-Reply-To: <446d7cf7-3598-da8a-90c7-8978d0b724b1@ideasonboard.com>
References: <5cc2f8f81f4c7d1ae693d87980353c725f9a11d3.1533637111.git.mchehab+samsung@kernel.org> <2872557.73pf0dW4Nv@avalon> <446d7cf7-3598-da8a-90c7-8978d0b724b1@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tuesday, 7 August 2018 19:19:41 EEST Kieran Bingham wrote:
> On 07/08/18 17:17, Laurent Pinchart wrote:
> > On Tuesday, 7 August 2018 13:36:59 EEST Kieran Bingham wrote:
> >> On 07/08/18 11:18, Mauro Carvalho Chehab wrote:
> >>> Gets rid of this build warning:
> >>> drivers/media/platform/vsp1/vsp1_dl.c:229: warning: Function parameter
> >>> or member 'cmdpool' not described in 'vsp1_dl_manager'>
> >>> 
> >>> Fixes: f3b98e3c4d2e ("media: vsp1: Provide support for extended command
> >>> pools") Signed-off-by: Mauro Carvalho Chehab
> >>> <mchehab+samsung@kernel.org>
> >>> ---
> >>> 
> >>>  drivers/media/platform/vsp1/vsp1_dl.c | 1 +
> >>>  1 file changed, 1 insertion(+)
> >>> 
> >>> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c
> >>> b/drivers/media/platform/vsp1/vsp1_dl.c index 9255b5ee2cb8..af60d95ec4f8
> >>> 100644
> >>> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> >>> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> >>> @@ -211,6 +211,7 @@ struct vsp1_dl_list {
> >>>   * @queued: list queued to the hardware (written to the DL registers)
> >>>   * @pending: list waiting to be queued to the hardware
> >>>   * @pool: body pool for the display list bodies
> >>> + * @cmdpool: Display List commands pool
> >> 
> >> Unfortunately this isn't quite right...
> >> 
> >>>   * @autofld_cmds: command pool to support auto-fld interlaced mode
> >> 
> >> This ^ was the original documentation line, but it got missed in a
> >> rename. Sorry about that.
> >> 
> >> The pool is now more 'generic' so the line probably should mention the
> >> auto-fld directly, so your line is worded appropriately enough, We
> >> probably just# need to remove the autofld_cmds line.
> > 
> > And I also wouldn't capitalize display list:
> > 
> > 	 * @cmdpool: display list commands pool
> > 
> > or possibly a bit more descriptive:
> > 
> > 	 * @cmdpool: commands pool for extended display list
> > 
> > Kieran, which version do you like best ?
> 
> If there's a respin anyway, then
> 
>  	 * @cmdpool: commands pool for extended display list
> 
> is certainly better, because this commands are specific to the extended
> portion of the display list.

I like that better as well. Mauro, could you please use that for v2 ?

> >> With that line removed:
> >> 
> >> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> >> 
> >>>   */
> >>>  
> >>>  struct vsp1_dl_manager {

-- 
Regards,

Laurent Pinchart
