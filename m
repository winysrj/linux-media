Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D73FCC43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 10:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5E7E2087E
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 10:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfARKp4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 05:45:56 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:56708 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726032AbfARKp4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 05:45:56 -0500
Received: from [IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c] ([IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c])
        by smtp-cloud9.xs4all.net with ESMTPA
        id kRergcmi8axzfkResgpCL3; Fri, 18 Jan 2019 11:45:54 +0100
Subject: Re: [PATCH v4 1/2] media: dt-bindings: media: video-i2c: add melexis
 mlx90640 documentation
To:     Matt Ranostay <matt.ranostay@konsulko.com>,
        linux-media@vger.kernel.org
Cc:     devicetree@vger.kernel.org
References: <20181211151701.10002-1-matt.ranostay@konsulko.com>
 <20181211151701.10002-2-matt.ranostay@konsulko.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <83ee363d-f168-2c27-5479-d4a44a14fa16@xs4all.nl>
Date:   Fri, 18 Jan 2019 11:45:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181211151701.10002-2-matt.ranostay@konsulko.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfN/0fcRVo6+byvYO8eeosLViqR98R3lBKi/QDd76BqfzUbE1FXVHVtEfXuXctIm60vbZZvI7OaZp8iC+9BhNK4qh5eVO9Nn15J65hVhfEX1wSWSjFA7c
 njpX6fSXiiz5cLCpML66bKtdTeFcVynSSozwEeHIJ9RUZOap8cvG2W/bqmld7PODTWxdHxQqODXrUkCAxYCABv+0B8IhX/sUcuWr5AkVB05GK7ltELtlkmuX
 5baIhyR8OyG/bHVoPNZLGRK+I4FlrgSZQHms5FyNp78pjdC6GfABIOWsblyZlROFpJIBklFWUrgalFfljV16uIzRprCtvinbYAMwq+rlwQFH9ez7QiobVkWn
 jr44++ht
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Matt,

I'm merging this patch, but can you add a new patch that updates the entry for
this driver in the MAINTAINERS file with references to the relevant bindings files?

I.e., for this one you add:

F:	Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt

but you need to add the panasonic bindings file as well.

Thanks!

	Hans

On 12/11/18 4:17 PM, Matt Ranostay wrote:
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Matt Ranostay <matt.ranostay@konsulko.com>
> ---
>  .../bindings/media/i2c/melexis,mlx90640.txt   | 20 +++++++++++++++++++
>  1 file changed, 20 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt b/Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt
> new file mode 100644
> index 000000000000..060d2b7a5893
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt
> @@ -0,0 +1,20 @@
> +* Melexis MLX90640 FIR Sensor
> +
> +Melexis MLX90640 FIR sensor support which allows recording of thermal data
> +with 32x24 resolution excluding 2 lines of coefficient data that is used by
> +userspace to render processed frames.
> +
> +Required Properties:
> + - compatible : Must be "melexis,mlx90640"
> + - reg : i2c address of the device
> +
> +Example:
> +
> +	i2c0@1c22000 {
> +		...
> +		mlx90640@33 {
> +			compatible = "melexis,mlx90640";
> +			reg = <0x33>;
> +		};
> +		...
> +	};
> 

