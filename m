Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CBF7C43387
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 16:43:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E78D206C2
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 16:43:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbeLNQnq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 11:43:46 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:47199 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729465AbeLNQnq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 11:43:46 -0500
Received: from [IPv6:2001:983:e9a7:1:950:c892:de62:df26] ([IPv6:2001:983:e9a7:1:950:c892:de62:df26])
        by smtp-cloud8.xs4all.net with ESMTPA
        id XqYxgFe4XAdxGXqYyghPTQ; Fri, 14 Dec 2018 17:43:44 +0100
Subject: Re: [PATCH 0/8] gspca_ov534 raw bayer (SGRBG8) support
To:     Philipp Zabel <philipp.zabel@gmail.com>,
        linux-media@vger.kernel.org
References: <20181214164031.16757-1-philipp.zabel@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8cf685ab-770e-9b02-83c4-4eef7365670b@xs4all.nl>
Date:   Fri, 14 Dec 2018 17:43:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181214164031.16757-1-philipp.zabel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfL8Wh0ocSMAhcgRqm4JYvQSDMfOSBjkk3oMQNgTdhyrqxtt3DerFzR5XM0Iiyn/tsb6EjtoevKTw33qm06erQEAnkVVc5UGQiTW9j5oSDzgTieD2ma+F
 McaAJnTP1q19GNYDdB31dgap/qlUAOQ138xtevC3+YIIbYfijbEOIHM8jkDnfT2Ec1pDvlVPRjv4TZEjsYOgSoW/Wr+/To2WBK8i2uw8YA8BDOOpBvkDK2+R
 Pd33AjHho70rgj6Utk5l9FgcX78lCz5z2IK3tunlmQTy6BsxioZpCHS+AZAHrBSyJaGBju+/XL6og/VW+hu6SQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/14/18 5:40 PM, Philipp Zabel wrote:
> Hi,
> 
> this series adds raw bayer (V4L2_PIX_FMT_SGRBG8) support to the gspca
> ov534-ov772x driver used for the PlayStation Eye camera for VGA and
> QVGA modes. Selecting the SGRBG8 format bypasses image processing
> (brightness, contrast, saturation, and hue controls).

I'm curious since I don't see many patches for gspca: what are you planning
to use this for?

Regards,

	Hans

> 
> regards
> Philipp
> 
> Philipp Zabel (8):
>   media: gspca: ov534: replace msleep(10) with usleep_range
>   media: gspca: support multiple pixel formats in ENUM_FRAMEINTERVALS
>   media: gspca: support multiple pixel formats in TRY_FMT
>   media: gspca: ov543-ov772x: move video format specific registers into
>     bridge_start
>   media: gspca: ov534-ov772x: add SGBRG8 bayer mode support
>   media: gspca: ov534-ov722x: remove mode specific video data registers
>     from bridge_init
>   media: gspca: ov534-ov722x: remove camera clock setup from bridge_init
>   media: gspca: ov534-ov772x: remove unnecessary COM3 initialization
> 
>  drivers/media/usb/gspca/gspca.c |  18 ++--
>  drivers/media/usb/gspca/ov534.c | 153 +++++++++++++++++++++++---------
>  2 files changed, 123 insertions(+), 48 deletions(-)
> 

