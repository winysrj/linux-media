Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 351F3C169C4
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 10:42:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04B7D20863
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 10:42:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=lucaceresoli.net header.i=@lucaceresoli.net header.b="J5ngiVZf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbfBKKm2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 05:42:28 -0500
Received: from hostingweb31-40.netsons.net ([89.40.174.40]:45465 "EHLO
        hostingweb31-40.netsons.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726173AbfBKKm2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 05:42:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=lucaceresoli.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:References:To:Subject:From:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=PefZbUwJMzQ4ZwMXSOIIqFQDeGpOHkO2Vj/7JrEeLUU=; b=J5ngiVZfK4jGBlXcrYy0/yw3a8
        6rze3AtW+z6vDUKlP4uPMOuOf1efbcNdu1pwPgdMvLUi5ZlL08BmJiWLxOeOzEfYNSCJ1ohHXYNF+
        UeXC5EzBg8VKvqFmAUTUYW0bqN4r0q95eNgnFi2et6M0lfLRWL8Buz8U03k6n1/tRsV4=;
Received: from [109.168.11.45] (port=59808 helo=[192.168.101.224])
        by hostingweb31.netsons.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@lucaceresoli.net>)
        id 1gt92f-00GzIe-Hj; Mon, 11 Feb 2019 11:42:25 +0100
From:   Luca Ceresoli <luca@lucaceresoli.net>
Subject: Re: [PATCH v3 2/2] media: v4l: xilinx: Add Xilinx MIPI CSI-2 Rx
 Subsystem
To:     Vishal Sagar <vishal.sagar@xilinx.com>, hyun.kwon@xilinx.com,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, michals@xilinx.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dineshk@xilinx.com, sandipk@xilinx.com
References: <1549025766-135037-1-git-send-email-vishal.sagar@xilinx.com>
 <1549025766-135037-3-git-send-email-vishal.sagar@xilinx.com>
Message-ID: <3923069f-7c69-c601-0ded-f7629696ef9b@lucaceresoli.net>
Date:   Mon, 11 Feb 2019 11:42:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1549025766-135037-3-git-send-email-vishal.sagar@xilinx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hostingweb31.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: hostingweb31.netsons.net: authenticated_id: luca+lucaceresoli.net/only user confirmed/virtual account not confirmed
X-Authenticated-Sender: hostingweb31.netsons.net: luca@lucaceresoli.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Vishal,

On 01/02/19 13:56, Vishal Sagar wrote:
> The Xilinx MIPI CSI-2 Rx Subsystem soft IP is used to capture images
> from MIPI CSI-2 camera sensors and output AXI4-Stream video data ready
> for image processing. Please refer to PG232 for details.

For those unused to Xilinx documentation I'd use the full document name
("MIPI CSI-2 Receiver Subsystem v4.0") or, even better, a stable URL if
available.

> The driver is used to set the number of active lanes, if enabled
> in hardware. The CSI2 Rx controller filters out all packets except for
> the packets with data type fixed in hardware. RAW8 packets are always
> allowed to pass through.
> 
> It is also used to setup and handle interrupts and enable the core. It
> logs all the events in respective counters between streaming on and off.
> The generic short packets received are notified to application via
> v4l2_events.
> 
> The driver supports only the video format bridge enabled configuration.
> Some data types like YUV 422 10bpc, RAW16, RAW20 are supported when the
> CSI v2.0 feature is enabled in design. When the VCX feature is enabled,
> the maximum number of virtual channels becomes 16 from 4.
> 
> Signed-off-by: Vishal Sagar <vishal.sagar@xilinx.com>

...

> +/**
> + * xcsi2rxss_reset - Does a soft reset of the MIPI CSI2 Rx Subsystem
> + * @core: Core Xilinx CSI2 Rx Subsystem structure pointer
> + *
> + * Core takes less than 100 video clock cycles to reset.
> + * So a larger timeout value is chosen for margin.
> + *
> + * Return: 0 - on success OR -ETIME if reset times out
> + */
> +static int xcsi2rxss_reset(struct xcsi2rxss_core *core)
> +{
> +	u32 timeout = XCSI_TIMEOUT_VAL;

The comment about the timeout is duplicated here and at the #define
line. Why not removing the define above and just putting

  u32 timeout = 1000; /* us */

here? It would make the entire timeout logic appear in a unique place.

> +static int xcsi2rxss_start_stream(struct xcsi2rxss_state *state)
> +{
> +	struct xcsi2rxss_core *core = &state->core;
> +	int ret = 0;
> +
> +	xcsi2rxss_enable(core);
> +
> +	ret = xcsi2rxss_reset(core);
> +	if (ret < 0) {
> +		state->streaming = false;
> +		return ret;
> +	}
> +
> +	xcsi2rxss_intr_enable(core);
> +	state->streaming = true;

Shouldn't you propagate s_stream to the upstream subdev here calling
v4l2_subdev_call(..., ..., s_stream, 1)?

> +	return ret;
> +}


-- 
Luca
