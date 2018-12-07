Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C66EC07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 14:01:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6A222146F
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 14:01:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="RZKNzrFA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E6A222146F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbeLGOBL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 09:01:11 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44752 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbeLGOBK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 09:01:10 -0500
Received: by mail-wr1-f67.google.com with SMTP id z5so3874476wrt.11
        for <linux-media@vger.kernel.org>; Fri, 07 Dec 2018 06:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=SXgSGFZAhjGfPSIMgF8g7rzBuVayB/sISmM/viu8EAE=;
        b=RZKNzrFAdEU2JWMob7MuqUdURnp3Y0Yi1/kNxjrb1tUUh6W+pgHB15kMhnoFV9tQtF
         TpKjWOSI7q8zl5rEWoqmm9eisY6hGIyq4KlImnctAT0m9PbB/a4+SDlaSUCcKZZqMGs6
         ZSLPLyJrlQGajpyw/BsVsijyzOFlD5ikOf6tk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=SXgSGFZAhjGfPSIMgF8g7rzBuVayB/sISmM/viu8EAE=;
        b=cPqrIVRYN2sJm1FJcaOL1f7NrP/L2A2oh4dUdvKeLE5pLCXsvw2EAjOsVAhTUFu2TQ
         pC89PFa0kziDutyDjNkoezG9f9nadAQCbcR5X6cCmjM2YXT1mSEH5Ttmm/1oUk31xn/0
         uWUS66AIXhXiEavrHHVZyiMREiEjgZ//LVKBSSbg28l17RaCzKwnK8W/tT+FcrVzqz75
         t7I5Hgo5Yvj58RY5ei4kgDQMjtk0wieRBuuBFdyith0ukPIL+RKWQVk416bid3GgnbgK
         5cCT2He0Qz5M17ogmU3Me06ZKXPw9rCgkT++XTNV5kdVqkRV+ZCqhW529pr7XnLtkjF6
         H8dQ==
X-Gm-Message-State: AA+aEWazcq+OW/eNAyrakYHiTuALy2iGlzwvSNipOdh55HfIiMcA6/Gb
        iYjamwI2E0ogg41VmKgSto0mBHjFTuY=
X-Google-Smtp-Source: AFSGD/WjwpNpImLiE6sJBYgmS07bakFmKhV11PVTddp+N+8OeISTUx07NCiP3LXXi6JAXiS6sAQ9Uw==
X-Received: by 2002:adf:f984:: with SMTP id f4mr1939180wrr.234.1544191267879;
        Fri, 07 Dec 2018 06:01:07 -0800 (PST)
Received: from arch-late (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id s81sm5264788wmf.14.2018.12.07.06.01.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 07 Dec 2018 06:01:07 -0800 (PST)
References: <20181122151834.6194-1-rui.silva@linaro.org> <757f8c52-7c23-7cf7-32ee-75ddba767ff8@xs4all.nl> <20181207133849.GK3095@unbuntlaptop>
User-agent: mu4e 1.0; emacs 27.0.50
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>, sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v9 00/13] media: staging/imx7: add i.MX7 media driver
In-reply-to: <20181207133849.GK3095@unbuntlaptop>
Date:   Fri, 07 Dec 2018 14:01:05 +0000
Message-ID: <m34lbp307y.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans and Dan,
On Fri 07 Dec 2018 at 13:38, Dan Carpenter wrote:
> On Fri, Dec 07, 2018 at 01:44:00PM +0100, Hans Verkuil wrote:
>> CHECK: Alignment should match open parenthesis
>> #936: FILE: drivers/staging/media/imx/imx7-mipi-csis.c:921:
>> +       ret = v4l2_async_register_fwnode_subdev(mipi_sd,
>> +                               sizeof(struct 
>> v4l2_async_subdev), &sink_port, 1,
>> 
>> Apparently the latest coding style is that alignment is more 
>> important than
>> line length, although I personally do not agree. But since you 
>> need to
>> respin in any case due to the wrong SPDX identifier you used 
>> you might as
>> well take this into account.

I added this in the cover letter:
     - some alignment parenthesis that were left as they are, to
     be more readable

this ones were left as they are as they seem impossible to fit all
rules. I hope you really do not mind about this checks. if you
have a strong opinion about this let me know, otherwise I will
leave this as it is.

>
> I'm pretty sure it complains about both equally.  If you make 
> fix one
> warning it will complain about the other.  So you just have to 
> pick
> which warning to not care about.

Yeah, I agree with you, I normally like to avoid at all cost the
line length issue.

---
Cheers,
	Rui

>
> regards,
> dan carpenter

