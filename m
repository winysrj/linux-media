Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51116 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933596AbeGDMVb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 08:21:31 -0400
Date: Wed, 4 Jul 2018 09:16:11 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hugues FRUCHET <hugues.fruchet@st.com>
Subject: Re: [PATCH] vivid: fix gain when autogain is on
Message-ID: <20180704091506.0a85686c@coco.lan>
In-Reply-To: <b7ae30af-dcaa-f8ef-4171-e73cb0107884@xs4all.nl>
References: <b7ae30af-dcaa-f8ef-4171-e73cb0107884@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 29 Jun 2018 11:40:41 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> In the vivid driver you want gain to continuous change while autogain
> is on. However, dev->jiffies_vid_cap doesn't actually change. It probably
> did in the past, but changes in the code caused this to be a fixed value
> that is only set when you start streaming.
> 
> Replace it by jiffies, which is always changing.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
> index 6b0bfa091592..6eb8ad7fb12c 100644
> --- a/drivers/media/platform/vivid/vivid-ctrls.c
> +++ b/drivers/media/platform/vivid/vivid-ctrls.c
> @@ -295,7 +295,7 @@ static int vivid_user_vid_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
> 
>  	switch (ctrl->id) {
>  	case V4L2_CID_AUTOGAIN:
> -		dev->gain->val = dev->jiffies_vid_cap & 0xff;
> +		dev->gain->val = (jiffies / HZ) & 0xff;

Manipulating jiffies directly like the above is not a good idea.

Better to use, instead:

	dev->gain->val = (jiffies_to_msecs(jiffies) / 1000) & 0xff;

I'll change the code when applying the patch.


Thanks,
Mauro
