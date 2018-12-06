Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E98C04EB8
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 12:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DDAD208E7
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 12:42:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DDAD208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sntech.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729518AbeLFMmR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 07:42:17 -0500
Received: from gloria.sntech.de ([185.11.138.130]:41674 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727832AbeLFMmR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Dec 2018 07:42:17 -0500
Received: from we0660.dip.tu-dresden.de ([141.76.178.148] helo=phil.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.0:ECDHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.89)
        (envelope-from <heiko@sntech.de>)
        id 1gUsys-00064D-8J; Thu, 06 Dec 2018 13:42:14 +0100
From:   Heiko Stuebner <heiko@sntech.de>
To:     Ezequiel Garcia <ezequiel@collabora.com>
Cc:     linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Miouyouyou <myy@miouyouyou.fr>
Subject: Re: [PATCH v11 3/4] arm64: dts: rockchip: add VPU device node for RK3399
Date:   Thu, 06 Dec 2018 13:42:13 +0100
Message-ID: <19304128.WNqjp6BVcH@phil>
In-Reply-To: <20181130173433.24185-4-ezequiel@collabora.com>
References: <20181130173433.24185-1-ezequiel@collabora.com> <20181130173433.24185-4-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Am Freitag, 30. November 2018, 18:34:32 CET schrieb Ezequiel Garcia:
> Add the Video Processing Unit node for the RK3399 SoC.
> 
> Also, fix the VPU IOMMU node, which was disabled and lacking
> its power domain property.
> 
> Reviewed-by: Tomasz Figa <tfiga@chromium.org>
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>

applied for 4.21 after a tiny bit of reordering

Thanks for seeing this through
Heiko


