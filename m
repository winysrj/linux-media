Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42B7C43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 08:46:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A18202173C
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 08:46:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ucAengP4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfCMIqo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 04:46:44 -0400
Received: from mail-lf1-f49.google.com ([209.85.167.49]:32956 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbfCMIqo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 04:46:44 -0400
Received: by mail-lf1-f49.google.com with SMTP id v14so287336lfi.0
        for <linux-media@vger.kernel.org>; Wed, 13 Mar 2019 01:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ubD1cxSO7AETwg4PUQltcWjb2jlXyHFikfIGigLkuLo=;
        b=ucAengP4ZEG4zKYW4eprV40q4jybwA0Hwqjk5sAunxczuOCYGWld5VnbaqrCXK0h9B
         FJ1TLgjM1Ne2NgrNXuzLVw5Dxb1i+MzUhH/CeGt5/cWyFp6qu5AppWSqXUkj1jcbKE6H
         vQIaL9aozTxDPvHqKKHQZBbgbvtI+jwkmafEnn+ADHJ59sPptGlM89lqpYaZKh+dqsUk
         ZySpnMtrEx8Ne7DjNegluF78PdwCxGpRDuk1y+tZ4Qt87qNHCMkO1/8JLwnFtMC0ln1B
         bpQzw0zsb0nfn1uP/nCX3RZIIPwjburUQN9+0mhGf0CYCJGHjMFWi7HNBPYV652ZKAbf
         F9Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ubD1cxSO7AETwg4PUQltcWjb2jlXyHFikfIGigLkuLo=;
        b=sflbPMhO/GX6jlf5dv5PwN8PBnJkhNPNyBBi4I9JlTYOzgBVRKZ+cHPpoJXPEXGuE6
         HRQIMu7NSy7n9GaEsGBVkuWrk4zyBhnQkf2xZ9JgtADRUrA8d/Yi21ueyhujPgPDRTV0
         AKE1sdk3YppayD5MyCvFYc09X2LsGI2UnP5D6S4Pb3uroovnJbmSO/U85cPPiVERN/C8
         3g2s07/0ZDHnt2WpoLgnCITrUHL1czlVusestYZTAFt48wUNj+OV3oJpAEZSdvQyMqps
         t8mKSrtADqfAwrj8NbYBDcGD7CqtAj6SoIMlh4cgono3KLo8i2m9V61N9OOHtm5UcTEt
         5JVQ==
X-Gm-Message-State: APjAAAVuc9J7B7LZUiUNDSpUKTZJsOD9u4bCSnyK+0UDCoyVG6OqElRZ
        zZbT4glrgAEK0kWG6zf/oYY=
X-Google-Smtp-Source: APXvYqxwDv5d+EOEIs9yEeT/mF/ZGWruqlNYYat/cK9vsBgYRJOgv7652/IwDJ4eN48xHhLq3wq7NA==
X-Received: by 2002:ac2:4425:: with SMTP id w5mr19203958lfl.139.1552466801967;
        Wed, 13 Mar 2019 01:46:41 -0700 (PDT)
Received: from [10.17.182.20] (ll-22.209.223.85.sovam.net.ua. [85.223.209.22])
        by smtp.gmail.com with ESMTPSA id h26sm1708774ljf.5.2019.03.13.01.46.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Mar 2019 01:46:41 -0700 (PDT)
Subject: Re: [Xen-devel][PATCH v5 1/1] cameraif: add ABI for para-virtual
 camera
To:     Juergen Gross <jgross@suse.com>, hverkuil@xs4all.nl
Cc:     xen-devel@lists.xenproject.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        koji.matsuoka.xm@renesas.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20190312082000.32181-1-andr2000@gmail.com>
 <20190312082000.32181-2-andr2000@gmail.com>
 <9e3b247e-39e6-3b87-5add-ed40b4bef731@suse.com>
From:   Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <170411d4-de33-8e0d-ab84-e5d9ae5ecf25@gmail.com>
Date:   Wed, 13 Mar 2019 10:46:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <9e3b247e-39e6-3b87-5add-ed40b4bef731@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 3/12/19 10:38 AM, Juergen Gross wrote:
> On 12/03/2019 09:20, Oleksandr Andrushchenko wrote:
>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>
>> This is the ABI for the two halves of a para-virtualized
>> camera driver which extends Xen's reach multimedia capabilities even
>> farther enabling it for video conferencing, In-Vehicle Infotainment,
>> high definition maps etc.
>>
>> The initial goal is to support most needed functionality with the
>> final idea to make it possible to extend the protocol if need be:
>>
>> 1. Provide means for base virtual device configuration:
>>   - pixel formats
>>   - resolutions
>>   - frame rates
>> 2. Support basic camera controls:
>>   - contrast
>>   - brightness
>>   - hue
>>   - saturation
>> 3. Support streaming control
>>
>> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
> Reviewed-by: Juergen Gross <jgross@suse.com>
Thank you,
I'll wait till the next week for any other comments and if there
are only those from Hans then I'll push (final?) v6
>
> Juergen
Thank you,
Oleksandr
