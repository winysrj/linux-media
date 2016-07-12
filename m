Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0055.hostedemail.com ([216.40.44.55]:57013 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753598AbcGLPvp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 11:51:45 -0400
Message-ID: <1468338700.8745.14.camel@perches.com>
Subject: Re: [PATCH] media: s5p-mfc Fix misspelled error message and
 checkpatch errors
From: Joe Perches <joe@perches.com>
To: Shuah Khan <shuahkh@osg.samsung.com>, kyungmin.park@samsung.com,
	k.debski@samsung.com, jtp.park@samsung.com, mchehab@kernel.org,
	javier@osg.samsung.com
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Tue, 12 Jul 2016 08:51:40 -0700
In-Reply-To: <578501E9.6090008@osg.samsung.com>
References: <1468276740-1591-1-git-send-email-shuahkh@osg.samsung.com>
	 <1468332418.8745.11.camel@perches.com> <578501E9.6090008@osg.samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2016-07-12 at 08:42 -0600, Shuah Khan wrote:
> On 07/12/2016 08:06 AM, Joe Perches wrote:
> > On Mon, 2016-07-11 at 16:39 -0600, Shuah Khan wrote:
> > > Fix misspelled error message and existing checkpatch errors in the
> > > error message conditional.
> > []
> > > diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> > []
> > > @@ -775,11 +775,11 @@ static int vidioc_g_crop(struct file *file, void *priv,
> > >  	u32 left, right, top, bottom;
> > >  
> > >  	if (ctx->state != MFCINST_HEAD_PARSED &&
> > > -	ctx->state != MFCINST_RUNNING && ctx->state != MFCINST_FINISHING
> > > -					&& ctx->state != MFCINST_FINISHED) {
> > > -			mfc_err("Cannont set crop\n");
> > > -			return -EINVAL;
> > > -		}
> > > +	    ctx->state != MFCINST_RUNNING && ctx->state != MFCINST_FINISHING
> > > +	    && ctx->state != MFCINST_FINISHED) {
> > > +		mfc_err("Can not get crop information\n");
> > > +		return -EINVAL;
> > > +	}
> > is it a set or a get?
> vidioc_g_crop is a get routine.
> > 
> > It'd be nicer for humans to read if the alignment was consistent
> Are you okay with this alignment change or would you like it
> changed?

Well, if you're resubmitting, I'd prefer it changed.
Thanks.
