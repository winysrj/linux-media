Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F91C43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 09:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAC5120859
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 09:44:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="fm49D9LI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391828AbfAPJoM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 04:44:12 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37925 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391825AbfAPJoL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 04:44:11 -0500
Received: by mail-wr1-f66.google.com with SMTP id v13so6128099wrw.5
        for <linux-media@vger.kernel.org>; Wed, 16 Jan 2019 01:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i4COrJ3f04YVkKKA3jV+p3HM78S7a3zx0+u6D2A+RF0=;
        b=fm49D9LIzzrUZ+tHAk2GkcaMLfVnw+cpNEYmIfcqntyU7PeIGmepc6/ASwcsrZbIX6
         olT84NYGG+A3JweN1tKW+/oSjNrRozBPUHVuJZ0xYRJ+tVdI0cafh9zwZIJHoJu7/DjQ
         1L1DWjijS5ALJdUTbtzwtzFFkPBD2FAQPPelw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i4COrJ3f04YVkKKA3jV+p3HM78S7a3zx0+u6D2A+RF0=;
        b=FY2l/UB3c37YqC6gp0JI73VxzlkJG3dLC0Y1p78c3H4AYRf1RmZ+SSxHgMck6zZ8y/
         evVfuAwfNMBwe2A/UKIJbg2fC/4+Mubi2KBVUvwLqZk5QjYsH+PsiEB2QT71SflUT0TK
         zj1/tqnTfDinp3PuZw7m+uHKhVeSY7yGIYawcTrMltCBRzfLkH0ix2MtBtoBTryz1WTB
         PKAkacb59k6lwZoQO76+fS5SA0fuIXhjvW6HjmmTHo5Z98TCffT1ZtXNespYV18mBE9i
         N5bkgIcTgZrdIPwbAOvU46WjHznWm7aQuHEpEe6ynHgXStZWVRGCPle2fiJu9ny0G+4R
         XCSQ==
X-Gm-Message-State: AJcUukeaZCRdEft5EAC0RUGDa5eOB+5R3yoLoxWdbn6TQOWk2oEZzvC2
        xmceAJaWkyMSgq4UGpW4QGVfJQ==
X-Google-Smtp-Source: ALg8bN4nUIvHd+3hrTmx3bjmF4W2SNJYPM2iMyH8wyuB4jjJALZPuuXMgz7FR5pMa1sZBeGKJrJeOg==
X-Received: by 2002:a5d:6889:: with SMTP id h9mr6658214wru.222.1547631849800;
        Wed, 16 Jan 2019 01:44:09 -0800 (PST)
Received: from [192.168.27.209] ([37.157.136.206])
        by smtp.googlemail.com with ESMTPSA id y8sm32185921wmg.13.2019.01.16.01.44.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Jan 2019 01:44:08 -0800 (PST)
Subject: Re: [PATCH] arm64: dts: sdm845: add video nodes
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        mgottam@codeaurora.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, vgarodia@codeaurora.org
References: <1542708506-12680-1-git-send-email-mgottam@codeaurora.org>
 <CAPBb6MVzmxfRstUrTOtkJdCDaZEZO=UeP_u3btGKrsKasBijRg@mail.gmail.com>
 <7e306c60-8603-a8c4-cbb3-526f8a63ee39@linaro.org>
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <238eaf7a-4785-76ca-b146-c4eb8abcfef7@linaro.org>
Date:   Wed, 16 Jan 2019 11:44:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <7e306c60-8603-a8c4-cbb3-526f8a63ee39@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Alex,

On 11/27/18 10:24 AM, Stanimir Varbanov wrote:
> Hi Alex,
> 
> On 11/27/18 9:31 AM, Alexandre Courbot wrote:
>> On Tue, Nov 20, 2018 at 7:08 PM Malathi Gottam <mgottam@codeaurora.org> wrote:
>>>
>>> This adds video nodes to sdm845 based on the examples
>>> in the bindings.
>>>
>>> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
>>> ---
>>>  arch/arm64/boot/dts/qcom/sdm845.dtsi | 34 ++++++++++++++++++++++++++++++++++
>>>  1 file changed, 34 insertions(+)
>>>
>>> diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
>>> index 0c9a2aa..d82487d 100644
>>> --- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
>>> +++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
>>> @@ -84,6 +84,10 @@
>>>                         reg = <0 0x86200000 0 0x2d00000>;
>>>                         no-map;
>>>                 };
>>> +               venus_region: venus@95800000 {
>>> +                       reg = <0x0 0x95800000 0x0 0x500000>;
>>
>> Note that the driver expects a size of 0x600000 here and will fail to
>> probe if this is smaller.
>>
> 
> I have to send a patch to fix that size mismatch as we discussed that it
> the other mail thread.
>

I sent the size mismatch patch here:

https://patchwork.kernel.org/patch/10753645/


-- 
regards,
Stan
