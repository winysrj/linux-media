Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A66A2C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 13:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75AEA206BB
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 13:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbfAHNop (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 08:44:45 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:59207 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727670AbfAHNoo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Jan 2019 08:44:44 -0500
Received: from [IPv6:2001:420:44c1:2579:e5a0:705e:8afb:6231] ([IPv6:2001:420:44c1:2579:e5a0:705e:8afb:6231])
        by smtp-cloud8.xs4all.net with ESMTPA
        id grgMgXVYyNR5ygrgQgzXWk; Tue, 08 Jan 2019 14:44:43 +0100
Subject: Re: [PATCH v1 2/2] media: atmel-isc: Update device tree binding
 documentation
To:     Ken Sloat <KSloat@aampglobal.com>,
        "eugen.hristev@microchip.com" <eugen.hristev@microchip.com>
Cc:     "mchehab@kernel.org" <mchehab@kernel.org>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "ludovic.desroches@microchip.com" <ludovic.desroches@microchip.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <20181228165934.36393-1-ksloat@aampglobal.com>
 <20181228165934.36393-2-ksloat@aampglobal.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <fd9073b4-7625-6f91-546e-9dad0bf6201f@xs4all.nl>
Date:   Tue, 8 Jan 2019 14:44:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20181228165934.36393-2-ksloat@aampglobal.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfMcpb3R2palsWhnUXhkiCU8PfjMM2CLKnaThBr2+Q2VfswP3Ymn6NAX+h94Qp+4SZRQh3xsZ4RuYK/4Ls7nkKP+L5rGIMZfPfh3iODaHfEiITEzsGOJd
 QBCaZs1N35qn76aBv6hIrkqgHnkwThIZT9VA76wmXplEoSNy/3Az9BdczA+66s5NjYoigk14MsShLDoJhpM6BpedZuggZmhjphIVuyIVbZwkX5ygIFnuuLS/
 UsYRdOcPAR+xKaKOw+NMPSMjzyMlrcCV3XCD+hqtl0Rrggx6KLF07Io9t30bzEjBOpHAgEJalJl+loO9pKtYWAGPU5oOCLQmRbNgFZp2PJO5kifbBFYu3cty
 c0Zryn3UDZ4rE5oBKy13C34F+So6aCVo70Qy9LjS9JZ570e4O+RRAoq+7jXccFxwq7Uo7NXALzv8Aw1BgaH6bj27XxPoFVbWD/RgghlEn4f9lvtQnZ9Iq+Da
 b+Vm4ZvODqX+WGUsdLNshft7aFcNtea51XQS4VfedHqAPajMLTWFI6OLNIo=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/28/18 17:59, Ken Sloat wrote:
> From: Ken Sloat <ksloat@aampglobal.com>
> 
> Update device tree binding documentation specifying how to
> enable BT656 with CRC decoding.
> 
> Signed-off-by: Ken Sloat <ksloat@aampglobal.com>
> ---
>  Documentation/devicetree/bindings/media/atmel-isc.txt | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/atmel-isc.txt b/Documentation/devicetree/bindings/media/atmel-isc.txt
> index bbe0e87c6188..e787edeea7da 100644
> --- a/Documentation/devicetree/bindings/media/atmel-isc.txt
> +++ b/Documentation/devicetree/bindings/media/atmel-isc.txt
> @@ -25,6 +25,9 @@ ISC supports a single port node with parallel bus. It should contain one
>  'port' child node with child 'endpoint' node. Please refer to the bindings
>  defined in Documentation/devicetree/bindings/media/video-interfaces.txt.
>  
> +If all endpoint bus flags (i.e. hsync-active) are omitted, then CCIR656
> +decoding (embedded sync) with CRC decoding is enabled.

Sorry, this is wrong. There is a bus-type property defined in video-interfaces.txt
that you should use to determine whether this is a parallel or a Bt.656 bus.

BTW, for v2 also CC this to devicetree@vger.kernel.org, since it has to be reviewed
by the DT maintainers.

Regards,

	Hans

> +
>  Example:
>  isc: isc@f0008000 {
>  	compatible = "atmel,sama5d2-isc";
> 

