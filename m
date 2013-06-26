Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f52.google.com ([209.85.212.52]:54227 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3FZGsH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jun 2013 02:48:07 -0400
Received: by mail-vb0-f52.google.com with SMTP id f12so10229967vbg.25
        for <linux-media@vger.kernel.org>; Tue, 25 Jun 2013 23:48:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK9yfHy3uzCn0GhU6d5CcFLw=VXeHVZukJAK_cmgFkJG6iiGeA@mail.gmail.com>
References: <1372157835-27663-1-git-send-email-arun.kk@samsung.com>
	<1372157835-27663-5-git-send-email-arun.kk@samsung.com>
	<CAK9yfHy3uzCn0GhU6d5CcFLw=VXeHVZukJAK_cmgFkJG6iiGeA@mail.gmail.com>
Date: Wed, 26 Jun 2013 12:18:05 +0530
Message-ID: <CALt3h79G-rKqBXGwgbxKVXSt2ASQ0H603zkEZQekZSUPEs8D1A@mail.gmail.com>
Subject: Re: [PATCH v3 4/8] [media] s5p-mfc: Core support for MFC v7
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>, jtp.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, avnd.kiran@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On Tue, Jun 25, 2013 at 4:54 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Hi Arun,
>
>> @@ -684,5 +685,6 @@ void set_work_bit_irqsave(struct s5p_mfc_ctx *ctx);
>>                                 (dev->variant->port_num ? 1 : 0) : 0) : 0)
>>  #define IS_TWOPORT(dev)                (dev->variant->port_num == 2 ? 1 : 0)
>>  #define IS_MFCV6_PLUS(dev)     (dev->variant->version >= 0x60 ? 1 : 0)
>> +#define IS_MFCV7(dev)          (dev->variant->version >= 0x70 ? 1 : 0)
>
> Considering the definition and pattern, wouldn't it be appropriate to
> call this  IS_MFCV7_PLUS?
>

We are still not sure about MFCv8 if it can re-use v7 stuff or not.

Regards
Arun
