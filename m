Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:35509 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751814AbdEBIwr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 May 2017 04:52:47 -0400
Received: by mail-wr0-f172.google.com with SMTP id z52so74717183wrc.2
        for <linux-media@vger.kernel.org>; Tue, 02 May 2017 01:52:47 -0700 (PDT)
Subject: Re: [PATCH v8 05/10] media: venus: adding core part and helper
 functions
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
References: <1493370837-19793-1-git-send-email-stanimir.varbanov@linaro.org>
 <1493370837-19793-6-git-send-email-stanimir.varbanov@linaro.org>
 <20170429222141.GK7456@valkosipuli.retiisi.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <d4f46814-41b3-b3a2-2e8f-d9f3cb7638a0@linaro.org>
Date: Tue, 2 May 2017 11:52:44 +0300
MIME-Version: 1.0
In-Reply-To: <20170429222141.GK7456@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hei Sakari,

On 04/30/2017 01:21 AM, Sakari Ailus wrote:
> Hi, Stan!!
> 
> On Fri, Apr 28, 2017 at 12:13:52PM +0300, Stanimir Varbanov wrote:
> ...
>> +int helper_get_bufreq(struct venus_inst *inst, u32 type,
>> +		      struct hfi_buffer_requirements *req)
>> +{
>> +	u32 ptype = HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS;
>> +	union hfi_get_property hprop;
>> +	int ret, i;
> 
> unsigned int i ? It's an array index...

Thanks for pointing that out, I have to revisit all similar places as
well ...

> 
>> +
>> +	if (req)
>> +		memset(req, 0, sizeof(*req));
>> +
>> +	ret = hfi_session_get_property(inst, ptype, &hprop);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = -EINVAL;
>> +
>> +	for (i = 0; i < HFI_BUFFER_TYPE_MAX; i++) {
>> +		if (hprop.bufreq[i].type != type)
>> +			continue;
>> +
>> +		if (req)
>> +			memcpy(req, &hprop.bufreq[i], sizeof(*req));
>> +		ret = 0;
>> +		break;
>> +	}
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(helper_get_bufreq);
> 
> As these are global symbols but still specific to a single driver, it'd be
> good to have them prefixed with a common prefix. How about "venus"? You
> actually already have that in a macro in the header. :-)

You are damned right, will rework that in next version.

<snip>

-- 
regards,
Stan
