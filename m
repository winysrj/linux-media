Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40886 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbbEDHog convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 03:44:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH/RFC] v4l: vsp1: Align crop rectangle to even boundary for YUV formats
Date: Mon, 04 May 2015 01:13:12 +0300
Message-ID: <2003077.85RPlhiJ1o@avalon>
In-Reply-To: <5542105A.1010601@cogentembedded.com>
References: <1430327133-8461-1-git-send-email-ykaneko0929@gmail.com> <5542105A.1010601@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Thursday 30 April 2015 14:22:02 Sergei Shtylyov wrote:
> On 4/29/2015 8:05 PM, Yoshihiro Kaneko wrote:
> > From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
> > 
> > Make sure that there are valid values in the crop rectangle to ensure
> > that the color plane doesn't get shifted when cropping.
> > Since there is no distintion between 12bit and 16bit YUV formats in
> 
> Вistinсtion.
> 
> > at the subdev level, use the more restrictive 12bit limits for all YUV
> > formats.

I would like to mention in the commit message that only the top coordinate 
constraints differ between the YUV formats, as the subsampling coefficient is 
always two in the horizontal direction.

Do you foresee a use case for odd cropping top coordinates ?

> > Signed-off-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>
> > Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> > ---
> > 
> > This patch is based on the master branch of linuxtv.org/media_tree.git.
> > 
> >   drivers/media/platform/vsp1/vsp1_rwpf.c | 14 ++++++++++++--
> >   1 file changed, 12 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c
> > b/drivers/media/platform/vsp1/vsp1_rwpf.c index fa71f46..9fed0b2 100644
> > --- a/drivers/media/platform/vsp1/vsp1_rwpf.c
> > +++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
> > @@ -197,11 +197,21 @@ int vsp1_rwpf_set_selection(struct v4l2_subdev
> > *subdev,> 
> >   	 */
> >   	format = vsp1_entity_get_pad_format(&rwpf->entity, cfg,
> >   	RWPF_PAD_SINK,
> >   					    sel->which);
> > +
> > +	if (format->code == MEDIA_BUS_FMT_AYUV8_1X32) {
> > +		sel->r.left = (sel->r.left + 1) & ~1;
> > +		sel->r.top = (sel->r.top + 1) & ~1;
> 
> There's ALIGN() macro just for that.
> 
> > +		sel->r.width = (sel->r.width) & ~1;
> > +		sel->r.height = (sel->r.height) & ~1;
> 
> Parens not needed.

round_down() could also be used, it might be more readable.

> > +	}
> > +
> >   	sel->r.left = min_t(unsigned int, sel->r.left, format->width - 2);
> >   	sel->r.top = min_t(unsigned int, sel->r.top, format->height - 2);

If format->width (height) is odd and sel->r.left (top) is larger than format-
>width (height) - 2 then the resulting value will become odd. The resulting 
configuration will not be accepted at streamon time as the video node width 
and height are correctly rounded based on YUV subsampling and will thus not 
match the subdev width and height. However, it would be good to enforce the 
constraint better at the subdev level, by moving the above alignment code 
after these two lines.

> >   	if (rwpf->entity.type == VSP1_ENTITY_WPF) {
> > -		sel->r.left = min_t(unsigned int, sel->r.left, 255);
> > -		sel->r.top = min_t(unsigned int, sel->r.top, 255);
> > +		int maxcrop =

I would declare maxcrop as an unsigned int.

> > +			format->code == MEDIA_BUS_FMT_AYUV8_1X32 ? 254 : 255;
> 
> I think you need an empty line here.
> 
> > +		sel->r.left = min_t(unsigned int, sel->r.left, maxcrop);
> > +		sel->r.top = min_t(unsigned int, sel->r.top, maxcrop);

Is this needed ? Based on what I understand from the datasheet the WPF crops 
the image before passing it to the DMA engine. At that point YUV data isn't 
subsampled, so it looks like we don't need to restrict the left and top to 
even values.

> >   	}
> >   	sel->r.width = min_t(unsigned int, sel->r.width,
> >   			     format->width - sel->r.left);

-- 
Regards,

Laurent Pinchart
