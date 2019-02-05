Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30A31C282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 11:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E880E2080D
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 11:53:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eJshPLo/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbfBELxP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 06:53:15 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37391 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfBELxP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 06:53:15 -0500
Received: by mail-wm1-f68.google.com with SMTP id g67so3318140wmd.2
        for <linux-media@vger.kernel.org>; Tue, 05 Feb 2019 03:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=lZhRktIwF9Xq8elBc9go42899bWEFGRQfHYh5a4xbV8=;
        b=eJshPLo/67FuY7M+OEJKap+ov494CGqjxpiW4jpI1HfmmDC2FNvFNdhQQZ4fp1Z2Ew
         rCVrXe4kPSRqIGUraiTXwWamOrRHJ/XFf31NygGPjpSirw9ANAAW6KMd23BOFDUqpnsF
         ReLcLK/5FgKPujXFCZnbqxmhJFAdS93nicKSteZ8TBbsNmCu/RX7GXkcaTrIlkagzwb/
         DXwBzZ4nh6VEvgIkGkO0Wp2Yie1RM6Sg3wn8AEd6dECBS2oHPFcqbhSmvDWE1RaR9v90
         oFLo3CBlLrzAwH1sAQY2rKI9T31tc0KG9O//rj60i9JYA/gXVXnCtaWMl1eDdqth/B+5
         szYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=lZhRktIwF9Xq8elBc9go42899bWEFGRQfHYh5a4xbV8=;
        b=Gxucno1N6xWAeGrFhqPb6zyvY1GEp88X8QYb1Nrabk55p8qe80YWEQ2Pwk4WvO3LQW
         knI7z72owpGKhdkA0Op+sKS+VXDD6Nj6znDwvIPQElaAKUeMkOiybReyDq/4k+k1m7cu
         Aiby9tIXzWMh7CRlgNe540AgcyxMZdxwhjqS1BaTr/Lm11g7fz+6JaMpG3fgkma+7E4j
         VbQxW1FRheApecJkeDifEtlwX48xXpL3g6STxWi1xpAQP0Ve1RoaMMmbVDVsTam4zslA
         boYGLXBxj4o6kCJvsOenA0bpkzK+gU08dFxTjnujEKP+pwRRY7sdwsK6iFz29ljLVU0J
         3nPg==
X-Gm-Message-State: AHQUAuYio2uQnJt+KXVTqMSIkhDo/mf6ZekNbF983HPmgHnWFCh8f38l
        Ae0G6XzuVOg6RHFGKsRphMmxuA==
X-Google-Smtp-Source: AHgI3IZljfv65ufGWNZHuijShw6ECOx0SDF7Xsb7G/MCDVRZib5hTnA8Op1emVGGEAKoDHbl5YZd9w==
X-Received: by 2002:a1c:c181:: with SMTP id r123mr3477303wmf.8.1549367592837;
        Tue, 05 Feb 2019 03:53:12 -0800 (PST)
Received: from arch-late (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id v6sm33369282wrd.88.2019.02.05.03.53.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Feb 2019 03:53:12 -0800 (PST)
References: <20190204120039.1198-1-rui.silva@linaro.org> <20190205111435.2oz46dqphfdt6mn5@kekkonen.localdomain>
User-agent: mu4e 1.0; emacs 27.0.50
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v12 00/13] media: staging/imx7: add i.MX7 media driver
In-reply-to: <20190205111435.2oz46dqphfdt6mn5@kekkonen.localdomain>
Date:   Tue, 05 Feb 2019 11:53:11 +0000
Message-ID: <m3y36u3108.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,
On Tue 05 Feb 2019 at 11:14, Sakari Ailus wrote:
> Hi Rui,
>
> On Mon, Feb 04, 2019 at 12:00:26PM +0000, Rui Miguel Silva 
> wrote:
>> Hi,
>> This series introduces the Media driver to work with the i.MX7 
>> SoC. it uses the
>> already existing imx media core drivers but since the i.MX7, 
>> contrary to
>> i.MX5/6, do not have an IPU and because of that some changes in 
>> the imx media
>> core are made along this series to make it support that case.
>> 
>> This patches adds CSI and MIPI-CSI2 drivers for i.MX7, along 
>> with several
>> configurations changes for this to work as a capture subsystem. 
>> Some bugs are
>> also fixed along the line. And necessary documentation.
>> 
>> For a more detailed view of the capture paths, pads links in 
>> the i.MX7 please
>> take a look at the documentation in PATCH 10.
>> 
>> The system used to test and develop this was the Warp7 board 
>> with an OV2680
>> sensor, which output format is 10-bit bayer. So, only MIPI 
>> interface was
>> tested, a scenario with an parallel input would nice to have.
>> 
>> Bellow goes an example of the output of the pads and links and 
>> the output of
>> v4l2-compliance testing.
>> 
>> The v4l-utils version used is:
>> v4l2-compliance SHA: 1a6c8fe9a65c26e78ba34bd4aa2df28ede7d00cb, 
>> 32 bits
>> 
>> The Media Driver fail some tests but this failures are coming 
>> from code out of
>> scope of this series (imx-capture), and some from the sensor 
>> OV2680
>> but that I think not related with the sensor driver but with 
>> the testing and
>> core.
>> 
>> The csi and mipi-csi entities pass all compliance tests.
>> 
>> Cheers,
>>     Rui
>> 
>> v11->v12:
>>   Sakari:
>>     - check v4l2_ctrl_handler_free and init when exposed to 
>>     userspace
>>     - check csi_remove missing v4l2_async_notifier_unregister
>>     - media device unregister before ctrl_handler_free
>>     - GPL => GPL v2
>>     - Fix squash of CSI patches, issue on v11
>>     - add Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com> 
>>     10--13
>>     - mipi_s_stream check for ret < 0 and call 
>>     pm_runtime_put_noidle
>>     - use __maybe_unused in pm functions
>>     - Extra space before labels
>
> For patches 1, 2 and 4:
>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Thanks for all your reviews, I did not add this before, because I
messed the patch order in v11.

---
Cheers,
	Rui

