Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:33638 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754266AbdDDMyN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Apr 2017 08:54:13 -0400
Received: by mail-wr0-f169.google.com with SMTP id w43so213063419wrb.0
        for <linux-media@vger.kernel.org>; Tue, 04 Apr 2017 05:54:13 -0700 (PDT)
Date: Tue, 4 Apr 2017 13:54:09 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: hans.verkuil@cisco.com, mchehab@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, patrice.chotard@st.com,
        linux-media@vger.kernel.org, benjamin.gaignard@st.com
Subject: Re: [PATCH 1/2] [media] cec: Move capability check inside #if
Message-ID: <20170404125409.ay5yszwdkdxb6nvx@dell>
References: <20170404123219.22040-1-lee.jones@linaro.org>
 <4920d83a-8983-36cc-936d-9e0989e833ce@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4920d83a-8983-36cc-936d-9e0989e833ce@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 04 Apr 2017, Hans Verkuil wrote:

> On 04/04/2017 02:32 PM, Lee Jones wrote:
> > If CONFIG_RC_CORE is not enabled then none of the RC code will be
> > executed anyway, so we're placing the capability check inside the
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/media/cec/cec-core.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
> > index 37217e2..06a312c 100644
> > --- a/drivers/media/cec/cec-core.c
> > +++ b/drivers/media/cec/cec-core.c
> > @@ -234,10 +234,10 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
> >  		return ERR_PTR(res);
> >  	}
> >  
> > +#if IS_REACHABLE(CONFIG_RC_CORE)
> >  	if (!(caps & CEC_CAP_RC))
> >  		return adap;
> >  
> > -#if IS_REACHABLE(CONFIG_RC_CORE)
> >  	/* Prepare the RC input device */
> >  	adap->rc = rc_allocate_device(RC_DRIVER_SCANCODE);
> >  	if (!adap->rc) {
> > 
> 
> Not true, there is an #else further down.

I saw the #else.  It's inert code that becomes function-less.

> That said, this code is clearly a bit confusing.
> 
> It would be better if at the beginning of the function we'd have this:
> 
> #if !IS_REACHABLE(CONFIG_RC_CORE)
> 	caps &= ~CEC_CAP_RC;
> #endif
> 
> and then drop the #else bit and (as you do in this patch) move the #if up.
> 
> Can you make a new patch for this?

Sure.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
