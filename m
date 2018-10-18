Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0014.hostedemail.com ([216.40.44.14]:38035 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727090AbeJRJl0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Oct 2018 05:41:26 -0400
Message-ID: <864470f074e634e7276bf999e3c3704b58c1e913.camel@perches.com>
Subject: Re: [PATCH v11 1/5] venus: firmware: add routine to reset ARM9
From: Joe Perches <joe@perches.com>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Vikash Garodia <vgarodia@codeaurora.org>, hverkuil@xs4all.nl,
        mchehab@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org
Date: Wed, 17 Oct 2018 18:42:51 -0700
In-Reply-To: <fffd5b1f-73b5-81d5-a95b-a2dc9db1961d@linaro.org>
References: <1539005572-803-1-git-send-email-vgarodia@codeaurora.org>
         <1539005572-803-2-git-send-email-vgarodia@codeaurora.org>
         <fffd5b1f-73b5-81d5-a95b-a2dc9db1961d@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2018-10-17 at 11:49 +0300, Stanimir Varbanov wrote:
> On 10/08/2018 04:32 PM, Vikash Garodia wrote:
> > Add routine to reset the ARM9 and brings it out of reset. Also
> > abstract the Venus CPU state handling with a new function. This
> > is in preparation to add PIL functionality in venus driver.
[]
> > diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
[]
> > @@ -129,6 +130,7 @@ struct venus_core {
> >  	struct device *dev;
> >  	struct device *dev_dec;
> >  	struct device *dev_enc;
> > +	bool use_tz;
> 
> could you make it unsigned? For more info please run checkpatch --strict.
> 
> I know that we have structure members of type bool already - that should
> be fixed with follow-up patches, I guess.

That's probably not necessary.

I personally have no issue with bool struct members that
are only used on a transitory basis and not used by hardware
or shared between multiple cpus with different hardware
alignment requirements.

Nothing in this struct is saved or shared.

Perhaps the checkpatch message should be expanded to
enumerate when bool use in a struct is acceptable.
