Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:33205 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932695AbdDEJJh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Apr 2017 05:09:37 -0400
Received: by mail-wr0-f182.google.com with SMTP id w43so4954492wrb.0
        for <linux-media@vger.kernel.org>; Wed, 05 Apr 2017 02:09:37 -0700 (PDT)
Date: Wed, 5 Apr 2017 10:09:33 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: hans.verkuil@cisco.com, mchehab@kernel.org,
        benjamin.gaignard@st.com, patrice.chotard@st.com,
        linux-kernel@vger.kernel.org, kernel@stlinux.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] [media] cec: Handle RC capability more elegantly
Message-ID: <20170405090933.ji6bapwcvnrinz5z@dell>
References: <20170404161005.20884-1-lee.jones@linaro.org>
 <20170404161005.20884-2-lee.jones@linaro.org>
 <20170404163455.GD7909@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170404163455.GD7909@n2100.armlinux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 04 Apr 2017, Russell King - ARM Linux wrote:

> On Tue, Apr 04, 2017 at 05:10:05PM +0100, Lee Jones wrote:
> > @@ -237,7 +241,6 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
> >  	if (!(caps & CEC_CAP_RC))
> >  		return adap;
> >  
> > -#if IS_REACHABLE(CONFIG_RC_CORE)
> >  	/* Prepare the RC input device */
> >  	adap->rc = rc_allocate_device(RC_DRIVER_SCANCODE);
> >  	if (!adap->rc) {
> 
> The above, coupled with patch 1:
> 
> +#ifdef CONFIG_RC_CORE
>  struct rc_dev *rc_allocate_device(enum rc_driver_type);
> +#else
> +static inline struct rc_dev *rc_allocate_device(int unused)
> +{
> +       return ERR_PTR(-EOPNOTSUPP);
> +}
> +#endif
> 
> is really not nice.  You claim that this is how stuff is done elsewhere
> in the kernel, but no, it isn't.  Look at debugfs.

I'm afraid you have entered half way through a conversation, which as
caused a misunderstanding.  Apologies for not being clear in my commit
log.

When I say "this is how it's done else where", that is in reference to
offering stubs which can be tucked away in a header file, rather than
being forced to #if out any functionality which is not available.

> You're right that debugfs returns an error pointer when it's not
> configured.  However, the debugfs dentry is only ever passed back into
> the debugfs APIs, it is never dereferenced by the caller.

Continued on from my last point:

What I do not mean is that this solution is perfect and does not
require a review.  You are completely correct in what you say, the
return values I have used are not suitable.  I failed to see how
callers were treating the return value.  I will carry out due
diligence on that point and re-submit as per your request.

> That is not the case here.  The effect if your change is that the
> following dereferences will oops the kernel.  This is unacceptable for
> a feature that is deconfigured.

Fair point Russell.  Thanks, will fix.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
