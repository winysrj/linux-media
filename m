Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:33858 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964938AbcCNNnu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 09:43:50 -0400
Received: by mail-lb0-f176.google.com with SMTP id k12so6819663lbb.1
        for <linux-media@vger.kernel.org>; Mon, 14 Mar 2016 06:43:49 -0700 (PDT)
Date: Mon, 14 Mar 2016 14:43:47 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
	<niklas.soderlund@ragnatech.se>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/2] v4l2-ioctl: simplify code
Message-ID: <20160314134347.GB24409@bigcity.dyn.berto.se>
References: <1456741000-39069-1-git-send-email-hverkuil@xs4all.nl>
 <1456741000-39069-2-git-send-email-hverkuil@xs4all.nl>
 <20160314124243.GA24409@bigcity.dyn.berto.se>
 <56E6B401.5090504@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <56E6B401.5090504@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-03-14 13:52:17 +0100, Hans Verkuil wrote:
> On 03/14/2016 01:42 PM, Niklas Söderlund wrote:
> > Hi Hans,
> > 
> > On 2016-02-29 11:16:39 +0100, Hans Verkuil wrote:
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> Instead of a big if at the beginning, just check if g_selection == NULL
> >> and call the cropcap op immediately and return the result.
> >>
> >> No functional changes in this patch.
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >>  drivers/media/v4l2-core/v4l2-ioctl.c | 44 ++++++++++++++++++------------------
> >>  1 file changed, 22 insertions(+), 22 deletions(-)
> >>
> >> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> >> index 86c4c19..67dbb03 100644
> >> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> >> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> >> @@ -2157,33 +2157,33 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
> >>  				struct file *file, void *fh, void *arg)
> >>  {
> >>  	struct v4l2_cropcap *p = arg;
> >> +	struct v4l2_selection s = { .type = p->type };
> >> +	int ret;
> >>  
> >> -	if (ops->vidioc_g_selection) {
> >> -		struct v4l2_selection s = { .type = p->type };
> >> -		int ret;
> >> +	if (ops->vidioc_g_selection == NULL)
> >> +		return ops->vidioc_cropcap(file, fh, p);
> > 
> > I might be missing something but is there a guarantee 
> > ops->vidioc_cropcap is not NULL here?
> 
> There is, either vidioc_g_selection or vidioc_cropcap will always be
> non-NULL. Since g_selection == NULL it follows that cropcap != NULL.
> 
> But I admit that it isn't exactly obvious since the test that ensures
> this is in determine_valid_ioctls() in v4l2-dev.c.

Nice, thanks for clarifying.

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

-- 
Regards,
Niklas Söderlund
