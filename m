Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D50C43381
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 12:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58D0A20857
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 12:08:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=lucaceresoli.net header.i=@lucaceresoli.net header.b="aisdqNz0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfCKMIM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 08:08:12 -0400
Received: from hostingweb31-40.netsons.net ([89.40.174.40]:33603 "EHLO
        hostingweb31-40.netsons.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726932AbfCKMIM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 08:08:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=lucaceresoli.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/NoQ0wwIA2IHYfQP4VF8zClSWplCmHXSuxQDutBvUqs=; b=aisdqNz0czfqwEx5egi7B6xNqS
        3JdKlmu7/wIfyvDS4KfO+fy4gmP8xvyE6ShfiWD5kWVT7pv3MiWSBXzuqXFGtHy/yuD9EB4H6rl3S
        d/lFaFVHfl3vuJakanpABbpnpnKlULQKdzYMzfkhD3c0ndwZzbqXF260bhnPL4zjpuO8=;
Received: from [109.168.11.45] (port=50852 helo=[192.168.101.76])
        by hostingweb31.netsons.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@lucaceresoli.net>)
        id 1h3Jiw-003lft-NX; Mon, 11 Mar 2019 13:08:06 +0100
Subject: Re: [PATCH v3 1/2] media: dt-bindings: media: xilinx: Add Xilinx MIPI
 CSI-2 Rx Subsystem
To:     Vishal Sagar <vsagar@xilinx.com>,
        Vishal Sagar <vishal.sagar@xilinx.com>,
        Hyun Kwon <hyunk@xilinx.com>,
        "laurent.pinchart@ideasonboard.com" 
        <laurent.pinchart@ideasonboard.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        Michal Simek <michals@xilinx.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dinesh Kumar <dineshk@xilinx.com>,
        Sandip Kothari <sandipk@xilinx.com>
References: <1549025766-135037-1-git-send-email-vishal.sagar@xilinx.com>
 <1549025766-135037-2-git-send-email-vishal.sagar@xilinx.com>
 <fe975327-2746-28d4-1340-5ad1e71858f1@lucaceresoli.net>
 <CY4PR02MB27098AB5D144C74AE6553699A74D0@CY4PR02MB2709.namprd02.prod.outlook.com>
From:   Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <1f698576-89b2-e264-387e-6db4c5a4713a@lucaceresoli.net>
Date:   Mon, 11 Mar 2019 13:08:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <CY4PR02MB27098AB5D144C74AE6553699A74D0@CY4PR02MB2709.namprd02.prod.outlook.com>
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

On 08/03/19 20:04, Vishal Sagar wrote:
>>> +Optional properties:
>>> +--------------------
>>> +- xlnx,vfb: This is present when Video Format Bridge is enabled.
>>> +  Without this property the driver won't be loaded as IP won't be able to
>> generate
>>> +  media bus format compliant stream output.
>>> +- xlnx,en-csi-v2-0: Present if CSI v2 is enabled in IP configuration.
>>> +- xlnx,en-vcx: When present, there are maximum 16 virtual channels, else
>>> +  only 4. This is present only if xlnx,en-csi-v2-0 is present.
>>> +- xlnx,en-active-lanes: Enable Active lanes configuration in Protocol
>>> +  Configuration Register.
>>
>> This doesn't seem very clear to me. According to my understanding of the
>> IP and driver, I'd rather rephrase as:
>>
>> - xlnx,en-active-lanes: present if the number of active lanes can be
>>   reconfigured at runtime in the Protocol Configuration Register.
>>   If present, the V4L2_CID_XILINX_MIPICSISS_ACT_LANES is added.
>>   Otherwise all lanes are always active.
>>
> 
> Your description is better. I will update with this in next version.

Ok, thanks. But I just noticed an error in my own words...
"V4L2_CID_XILINX_MIPICSISS_ACT_LANES is added" ->
"V4L2_CID_XILINX_MIPICSISS_ACT_LANES control is added".

-- 
Luca
