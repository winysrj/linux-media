Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52064 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935421AbcKKWyy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 17:54:54 -0500
Date: Fri, 11 Nov 2016 14:54:52 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3 3/9] media: venus: adding core part and helper
 functions
Message-ID: <20161111225452.GD5177@codeaurora.org>
References: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org>
 <1478540043-24558-4-git-send-email-stanimir.varbanov@linaro.org>
 <20161110214339.GF16026@codeaurora.org>
 <550b86f3-e687-ddcd-2f20-d430bbe06940@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <550b86f3-e687-ddcd-2f20-d430bbe06940@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/11, Stanimir Varbanov wrote:
> On 11/10/2016 11:43 PM, Stephen Boyd wrote:
> > 
> > Should this be ret |= ? Only the last time through the loop will
> > there be an error. Or perhaps we should be bailing out early from
> > this loop?
> 
> I think that even if unset_buffers fail we need to free the memory. In
> case of an error in firmware while unset buffers we should mark the
> session as invalid and abort the session acordingly.

Ok. So perhaps we shouldn't have any return value for this
function then?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
