Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C399C07EBF
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 18:28:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60F6220896
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 18:28:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="hKNtyIeX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728822AbfARS2q (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 13:28:46 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35390 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728704AbfARS2q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 13:28:46 -0500
Received: by mail-wm1-f66.google.com with SMTP id t200so5447504wmt.0
        for <linux-media@vger.kernel.org>; Fri, 18 Jan 2019 10:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=/Z+of8cw4kSSx9c4Idfga/LjwFXImT0GSXN0UcDCyZY=;
        b=hKNtyIeXxgwH9jO5gHR1zAX4w4x3zJnyTIZd+6S0sp7AuqTPmpNysjRQLqYrVeuBTf
         nt/DGAXiaQo2WCW4pIdwMJsL4DhPYEtMlBFky3hiHkjnC/etFe9ipfloT0T9t0ixglMa
         si5o98wQCPasLyTxxjZmcGCyRQKfyqKI1p6GQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=/Z+of8cw4kSSx9c4Idfga/LjwFXImT0GSXN0UcDCyZY=;
        b=g9soQIJkDSkpSUk3vPwx1QDyWUfPQTEzW0G3vjhfb8CCrn74tqLKArHnfBXftgGta4
         zo13q2atuTNIBNRweytaY2hBJio/lsMM+shVZUMzpS4a4VlcTUUEJsYkDvLIztjW+jGH
         mVBeIARAaxJFZ3W984M20zV/GiFDRqBNOurbPspqJC6h8D+2DNcL1pVL30/BJ0e/q+zo
         ljgkBya5VWqGha4BMnm0jNLHSy+5Wbsm4VKhgFqo5FMd5JhIgTgoeYl9+MwQnd5NgJ7Y
         urKOb9+095ii59Es5zNb6DAIQGuTbgtxhx/4coJuTo1UU17Pke8SsLGQmVGYPhk5O6cT
         qrYQ==
X-Gm-Message-State: AJcUukdPNlGqlToVtyWZZFAC4bb2tiZHljMkn4ob3t46FjNOTeQVsWMd
        J27DKpKK5Qxs+ezBzPtmxOjeeSvvSj8=
X-Google-Smtp-Source: ALg8bN5hvJSryRf5xGQVssaXmq2zXCDy5GaJEskNQoE8ITW/+uQoQ8jNKvgW+Ko1rWh9VKrbWdYtQA==
X-Received: by 2002:a1c:4d12:: with SMTP id o18mr17165445wmh.92.1547836123491;
        Fri, 18 Jan 2019 10:28:43 -0800 (PST)
Received: from arch-late (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id l14sm171019365wrp.55.2019.01.18.10.28.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 18 Jan 2019 10:28:42 -0800 (PST)
References: <20181122151834.6194-1-rui.silva@linaro.org> <757f8c52-7c23-7cf7-32ee-75ddba767ff8@xs4all.nl> <CAOMZO5BCPAmcE=fU0fA9hgwZ89JMEtO5hOb15b7VwtD6i1LwSg@mail.gmail.com>
User-agent: mu4e 1.0; emacs 27.0.50
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "open list\:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        "open list\:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH v9 00/13] media: staging/imx7: add i.MX7 media driver
In-reply-to: <CAOMZO5BCPAmcE=fU0fA9hgwZ89JMEtO5hOb15b7VwtD6i1LwSg@mail.gmail.com>
Date:   Fri, 18 Jan 2019 18:28:41 +0000
Message-ID: <m3bm4dg6qu.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Oi Fabio,
On Fri 18 Jan 2019 at 16:49, Fabio Estevam wrote:
> Hi Rui,
>
> On Fri, Dec 7, 2018 at 10:44 AM Hans Verkuil 
> <hverkuil@xs4all.nl> wrote:
>
>> I got a few checkpatch warnings about coding style:
>>
>> CHECK: Alignment should match open parenthesis
>> #953: FILE: drivers/staging/media/imx/imx7-media-csi.c:911:
>> +static struct v4l2_mbus_framefmt *imx7_csi_get_format(struct 
>> imx7_csi *csi,
>> +                                       struct 
>> v4l2_subdev_pad_config *cfg,
>>
>> CHECK: Alignment should match open parenthesis
>> #1341: FILE: drivers/staging/media/imx/imx7-media-csi.c:1299:
>> +       ret = v4l2_async_register_fwnode_subdev(&csi->sd,
>> +                                       sizeof(struct 
>> v4l2_async_subdev),
>>
>> CHECK: Lines should not end with a '('
>> #684: FILE: drivers/staging/media/imx/imx7-mipi-csis.c:669:
>> +static struct csis_pix_format const *mipi_csis_try_format(
>>
>> CHECK: Alignment should match open parenthesis
>> #708: FILE: drivers/staging/media/imx/imx7-mipi-csis.c:693:
>> +static struct v4l2_mbus_framefmt *mipi_csis_get_format(struct 
>> csi_state *state,
>> +                                       struct 
>> v4l2_subdev_pad_config *cfg,
>>
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
>>
>> I was really hoping I could merge this, but the SPDX license 
>> issue killed it.
>
> Do you plan to submit a new version?

Yeah, I will try to send one next week. I think have all this
addressed in a branch, I will need to rebase again.

---
Cheers,
	Rui

