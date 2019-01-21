Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66485C67874
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 10:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37AAF20663
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 10:48:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="TVCLxlcG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbfAUKsb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 05:48:31 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42342 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727440AbfAUKsa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 05:48:30 -0500
Received: by mail-wr1-f65.google.com with SMTP id q18so22694482wrx.9
        for <linux-media@vger.kernel.org>; Mon, 21 Jan 2019 02:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1ttaux9N8+M7syJi6fIp1C2xsjMJsGRJJyi8anCnSNE=;
        b=TVCLxlcGpRv2Gxbu4n0RwJLY9m/obf4w3VfUJcZ8qDVvKbtB7F+XoHbwgul6gnZTm7
         elSwhQm1rT3wa/KACqmkY32KYeVjPn2GDSJJUtiXIojJU09WfKHmUhR6YgWUuSTLIZ3q
         vS/+ZlTqCRoXxkjTsoZrXwHK3nKuHP+w0BpSw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1ttaux9N8+M7syJi6fIp1C2xsjMJsGRJJyi8anCnSNE=;
        b=pPcpLwZ3s6iz47D5RpxVzBEzZvptG66mshCjqVsUo01t7Z3aOVLUOFO52Ckkw5F9D2
         +4SEIj2TccLEAxQjquGkag3+7Ylv2RRzjZuanaj6OKyecgT3Mx5WZNlVtTvYG50Jdy8U
         rRlVtbanqQiYbV5s6hlABP5M/S7th8iqE2Z8nhmWo7FgHn1V9njybAQk9nDEVt6qQlzd
         4VHrIyt7udMvPpdH9iy5BZGig/BwuyAd2w1d38JhAKkljW4yglT4+wiLBayhzUz1sFio
         SUgBaHc9iSkkBNsN7aaCHDJ2sp0e6+soESCEyL8L9SBXWzleKylGVXjRiQd3DpkhfV99
         s6Yg==
X-Gm-Message-State: AJcUukdia6apJmMk8VmzRO5lN7DL8kG1uaUAyF6rBwJ3dCrasrPwmKvB
        tHJ1ljnoqlV7UFFHQI6piwOVX74URW8=
X-Google-Smtp-Source: ALg8bN6ZHR94sgSFTbDFBw/pg/+KOlZaBo07H6jjtjHLp5kuuTC5yGUZ7cwJlNwAs5YTLbdRzws9yw==
X-Received: by 2002:adf:c38e:: with SMTP id p14mr22292986wrf.68.1548067708263;
        Mon, 21 Jan 2019 02:48:28 -0800 (PST)
Received: from [192.168.27.209] ([37.157.136.206])
        by smtp.googlemail.com with ESMTPSA id y138sm57934722wmc.16.2019.01.21.02.48.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jan 2019 02:48:27 -0800 (PST)
Subject: Re: [RFC PATCH] media/doc: Allow sizeimage to be set by v4l clients
To:     Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>
References: <20190116123701.10344-1-stanimir.varbanov@linaro.org>
 <299e8aeb-6deb-b383-8f63-cf2cbf5d2e9f@xs4all.nl>
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <adecdc4e-1aed-fc33-b14b-083322797c70@linaro.org>
Date:   Mon, 21 Jan 2019 12:48:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <299e8aeb-6deb-b383-8f63-cf2cbf5d2e9f@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On 1/18/19 11:13 AM, Hans Verkuil wrote:
> On 1/16/19 1:37 PM, Stanimir Varbanov wrote:
>> This changes v4l2_pix_format and v4l2_plane_pix_format sizeimage
>> field description to allow v4l clients to set bigger image size
>> in case of variable length compressed data.
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst | 5 ++++-
>>  Documentation/media/uapi/v4l/pixfmt-v4l2.rst        | 3 ++-
>>  2 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst b/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst
>> index 7f82dad9013a..dbe0b74e9ba4 100644
>> --- a/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst
>> +++ b/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst
>> @@ -30,7 +30,10 @@ describing all planes of that format.
>>  
>>      * - __u32
>>        - ``sizeimage``
>> -      - Maximum size in bytes required for image data in this plane.
>> +      - Maximum size in bytes required for image data in this plane,
>> +        set by the driver. When the image consists of variable length
>> +        compressed data this is the maximum number of bytes required
>> +        to hold an image, and it is allowed to be set by the client.
>>      * - __u32
>>        - ``bytesperline``
>>        - Distance in bytes between the leftmost pixels in two adjacent
>> diff --git a/Documentation/media/uapi/v4l/pixfmt-v4l2.rst b/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
>> index 71eebfc6d853..54b6d2b67bd7 100644
>> --- a/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
>> +++ b/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
>> @@ -89,7 +89,8 @@ Single-planar format structure
>>        - Size in bytes of the buffer to hold a complete image, set by the
>>  	driver. Usually this is ``bytesperline`` times ``height``. When
>>  	the image consists of variable length compressed data this is the
>> -	maximum number of bytes required to hold an image.
>> +	maximum number of bytes required to hold an image, and it is
>> +	allowed to be set by the client.
>>      * - __u32
>>        - ``colorspace``
>>        - Image colorspace, from enum :c:type:`v4l2_colorspace`.
>>
> 
> Hmm. "maximum number of bytes required to hold an image": that's not actually true
> for bitstream formats like MPEG. It's just the size of the buffer used to store the
> bitstream, i.e. one buffer may actually contain multiple compressed images, or a
> compressed image is split over multiple buffers.
> 

Do you want me to change something in the current documentation, i.e.
the quoted above?

> Only for MJPEG is this statement true since each buffer will contain a single
> compressed JPEG image.
> 
> Regards,
> 
> 	Hans
> 

-- 
regards,
Stan
