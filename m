Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56944 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932776AbaEMMeK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 May 2014 08:34:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Daniel Drake <dsd@laptop.org>
Subject: Re: [PATCH] V4L2: ov7670: fix a wrong index, potentially Oopsing the kernel from user-space
Date: Tue, 13 May 2014 14:34:10 +0200
Message-ID: <2339106.fM9iiffNpn@avalon>
In-Reply-To: <Pine.LNX.4.64.1405131431100.24784@axis700.grange>
References: <Pine.LNX.4.64.1404141545280.23631@axis700.grange> <7866980.K7C626CZfu@avalon> <Pine.LNX.4.64.1405131431100.24784@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tuesday 13 May 2014 14:31:25 Guennadi Liakhovetski wrote:
> On Tue, 13 May 2014, Laurent Pinchart wrote:
> > On Monday 14 April 2014 15:49:34 Guennadi Liakhovetski wrote:
> > > Commit 75e2bdad8901a0b599e01a96229be922eef1e488 "ov7670: allow
> > > configuration of image size, clock speed, and I/O method" uses a wrong
> > > index to iterate an array. Apart from being wrong, it also uses an
> > > unchecked value from user-space, which can cause access to unmapped
> > > memory in the kernel, triggered by a normal desktop user with rights to
> > > use V4L2 devices.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > ---
> > > 
> > > Jonathan,
> > > I'd prefer to first post it to the lists to maybe have someone test it
> > > ;)
> > > Otherwise - I've got a couple more fixes for 3.15, which I hope to make
> > > ready and push in a couple of weeks... So, with your ack I can take this
> > > one too, or, if you prefer to push it earlier - would be good too.
> > 
> > What's your plan for this patch ? Will you send a pull request ?
> > Alternatively I can take it in my tree.
> 
> https://patchwork.linuxtv.org/patch/23815/

Sorry for missing that. I'll mark https://patchwork.linuxtv.org/patch/23599/ 
as accepted then.

> > >  drivers/media/i2c/ov7670.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> > > index e8a1ce2..cdd7c1b 100644
> > > --- a/drivers/media/i2c/ov7670.c
> > > +++ b/drivers/media/i2c/ov7670.c
> > > @@ -1109,7 +1109,7 @@ static int ov7670_enum_framesizes(struct
> > > v4l2_subdev
> > > *sd, * windows that fall outside that.
> > > 
> > >  	 */
> > >  	
> > >  	for (i = 0; i < n_win_sizes; i++) {
> > > 
> > > -		struct ov7670_win_size *win = &info->devtype->win_sizes[index];
> > > +		struct ov7670_win_size *win = &info->devtype->win_sizes[i];
> > > 
> > >  		if (info->min_width && win->width < info->min_width)
> > >  		
> > >  			continue;
> > >  		
> > >  		if (info->min_height && win->height < info->min_height)

-- 
Regards,

Laurent Pinchart

