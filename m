Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EABD3C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 17:32:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD9FE2173C
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 17:32:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=lucaceresoli.net header.i=@lucaceresoli.net header.b="5bgIm6V8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfCSRcX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 13:32:23 -0400
Received: from hostingweb31-40.netsons.net ([89.40.174.40]:55380 "EHLO
        hostingweb31-40.netsons.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726579AbfCSRcW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 13:32:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=lucaceresoli.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:References:To:Subject:From:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=JLAXyU8jMJY4Zq8HSdudDBplsAaLVJtin7+H/8t47Qk=; b=5bgIm6V82DDv1WducSfmgzzGx8
        T7iRLRg7QH8uk8scit3Qa7eQa2fP2HePvgDryJTr5ijYTkMwbHz9tzw8CP3VsGTjTMm9glvjSoObJ
        aNxLu/S+LBvjL/X0oPe1h+hxMtTcXhP275/g2PIyaxO6nENCkUkcvkj0UOsfoVYGTh+o=;
Received: from [78.134.57.171] (port=34118 helo=[192.168.77.67])
        by hostingweb31.netsons.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@lucaceresoli.net>)
        id 1h6Ib4-00DGXh-BV; Tue, 19 Mar 2019 18:32:18 +0100
From:   Luca Ceresoli <luca@lucaceresoli.net>
Subject: Re: [PATCH v7 1/2] media: dt-bindings: media: xilinx: Add Xilinx MIPI
 CSI-2 Rx Subsystem
To:     Vishal Sagar <vishal.sagar@xilinx.com>,
        Hyun Kwon <hyunk@xilinx.com>,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        Michal Simek <michals@xilinx.com>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Dinesh Kumar <dineshk@xilinx.com>,
        Sandip Kothari <sandipk@xilinx.com>
References: <1552562691-14445-1-git-send-email-vishal.sagar@xilinx.com>
 <1552562691-14445-2-git-send-email-vishal.sagar@xilinx.com>
Message-ID: <61dd8f07-033b-5573-99e1-0694c7febfb2@lucaceresoli.net>
Date:   Tue, 19 Mar 2019 18:32:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <1552562691-14445-2-git-send-email-vishal.sagar@xilinx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hostingweb31.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: hostingweb31.netsons.net: authenticated_id: luca@lucaceresoli.net
X-Authenticated-Sender: hostingweb31.netsons.net: luca@lucaceresoli.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Vishal,

On 14/03/19 12:24, Vishal Sagar wrote:
> Add bindings documentation for Xilinx MIPI CSI-2 Rx Subsystem.
> 
> The Xilinx MIPI CSI-2 Rx Subsystem consists of a CSI-2 Rx controller, a
> DPHY in Rx mode, an optional I2C controller and a Video Format Bridge.
> 
> Signed-off-by: Vishal Sagar <vishal.sagar@xilinx.com>
> Reviewed-by: Hyun Kwon <hyun.kwon@xilinx.com>
> Reviewed-by: Rob Herring <robh@kernel.org>

Reviewed-by: Luca Ceresoli <luca@lucaceresoli.net>

-- 
Luca
