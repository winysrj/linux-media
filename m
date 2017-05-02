Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:33608 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751450AbdEBSwp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 May 2017 14:52:45 -0400
Received: by mail-pg0-f42.google.com with SMTP id y4so60443515pge.0
        for <linux-media@vger.kernel.org>; Tue, 02 May 2017 11:52:44 -0700 (PDT)
Date: Tue, 2 May 2017 11:52:41 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Gross <andy.gross@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v8 05/10] media: venus: adding core part and helper
 functions
Message-ID: <20170502185241.GX15143@minitux>
References: <1493370837-19793-1-git-send-email-stanimir.varbanov@linaro.org>
 <1493370837-19793-6-git-send-email-stanimir.varbanov@linaro.org>
 <20170429222141.GK7456@valkosipuli.retiisi.org.uk>
 <d4f46814-41b3-b3a2-2e8f-d9f3cb7638a0@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4f46814-41b3-b3a2-2e8f-d9f3cb7638a0@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 02 May 01:52 PDT 2017, Stanimir Varbanov wrote:

> Hei Sakari,
> 
> On 04/30/2017 01:21 AM, Sakari Ailus wrote:
> > Hi, Stan!!
> > 
> > On Fri, Apr 28, 2017 at 12:13:52PM +0300, Stanimir Varbanov wrote:
> > ...
> >> +int helper_get_bufreq(struct venus_inst *inst, u32 type,
> >> +		      struct hfi_buffer_requirements *req)
> >> +{
> >> +	u32 ptype = HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS;
> >> +	union hfi_get_property hprop;
> >> +	int ret, i;
> > 
> > unsigned int i ? It's an array index...
> 
> Thanks for pointing that out, I have to revisit all similar places as
> well ...
> 

It's perfectly fine to index an array with an int and you are comparing
the index with a integer constant in the loop - so don't clutter the
code unnecessarily.

Regards,
Bjorn
