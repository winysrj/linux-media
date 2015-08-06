Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:33860 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754718AbbHFHiE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Aug 2015 03:38:04 -0400
Message-ID: <55C30ED5.6020804@xs4all.nl>
Date: Thu, 06 Aug 2015 09:37:57 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Udit KUMAR <udit-dlh.kumar@st.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Dimple GERA <dimple.gera@st.com>
Subject: Re: VIDIOC_S_EXT_CTRLS
References: <ADCA285CF15CD143BF1E6E2BAF6868AA0894EA4CD6@EAPEX1MAIL1.st.com>
In-Reply-To: <ADCA285CF15CD143BF1E6E2BAF6868AA0894EA4CD6@EAPEX1MAIL1.st.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Udit,

That's why it is called a 'string'. The NUL terminates the string.

If you want to pass character arrays, then use a V4L2_CTRL_TYPE_U8 array.

Regards,

	Hans

On 08/06/2015 07:22 AM, Udit KUMAR wrote:
> Hello 
> 
> When passing strings which has NULL in between, low level driver will not get full strings. 
> Our typical use case is kernel level muxer, where "PMT" descriptor  is passed as strings, which will have NULL in between. 
> 
> In this case V4L2, copies the whole size and passing only stings to low level driver. 
> If V4L2 sends size along with strings to low level driver then it will fix the problem and let low level driver to decide whether they want to use
> size of strings or size. 
> 
> Below patch is proposed to fix such issues. 
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 7e38d59..bd3dc67 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1166,10 +1166,12 @@ static int user_to_new(struct v4l2_ext_control *c,
>  	u32 size;
>  
>  	ctrl->is_new = 1;
> +	ctrl->size = c->size;
>  	switch (ctrl->type) {
>  	case V4L2_CTRL_TYPE_INTEGER64:
>  		ctrl->val64 = c->value64;
>  		break;
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 47ada23..75ec59c 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -152,6 +152,7 @@ struct v4l2_ctrl {
>  		char *string;
>  	};
>  	void *priv;
> +	u32 size;
>  };
>  
>  /** struct v4l2_ctrl_ref - The control reference.
> 
> 
> 
> Regards
> Udit
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
