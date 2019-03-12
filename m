Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8804C43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 15:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B884E2075C
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 15:03:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=lucaceresoli.net header.i=@lucaceresoli.net header.b="4/Au2Asr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfCLPDY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:03:24 -0400
Received: from hostingweb31-40.netsons.net ([89.40.174.40]:57065 "EHLO
        hostingweb31-40.netsons.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725894AbfCLPDY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 11:03:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=lucaceresoli.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Yut3vJ2kSCA6KUuEog7i+w2ZYC8lyu24Pkl3B9ZWaEI=; b=4/Au2Asr0UYm5hBf77liw8HAXL
        8tzaybJiMR/s8QNO47UhUuBOztb6ObwBPgq7e2RW+Uc1/FNC22h1fcJjuWcgxCjHNRXolVnYZWLrU
        rl5ocurB+qMBHkr7MkA8OtaJ/NLIVwOW8K1PGvm/92XM4Dpg8R1g//iUE7iqixVG9NtI=;
Received: from [109.168.11.45] (port=55626 helo=[192.168.101.76])
        by hostingweb31.netsons.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@lucaceresoli.net>)
        id 1h3iw4-00Finm-IM; Tue, 12 Mar 2019 16:03:20 +0100
Subject: Re: [PATCH v6 1/2] media: dt-bindings: media: xilinx: Add Xilinx MIPI
 CSI-2 Rx Subsystem
To:     Vishal Sagar <vsagar@xilinx.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Vishal Sagar <vishal.sagar@xilinx.com>
Cc:     Hyun Kwon <hyunk@xilinx.com>,
        "laurent.pinchart@ideasonboard.com" 
        <laurent.pinchart@ideasonboard.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        Michal Simek <michals@xilinx.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dinesh Kumar <dineshk@xilinx.com>,
        Sandip Kothari <sandipk@xilinx.com>
References: <1552365330-21155-1-git-send-email-vishal.sagar@xilinx.com>
 <1552365330-21155-2-git-send-email-vishal.sagar@xilinx.com>
 <20190312102118.6ianedkzscr7gdba@kekkonen.localdomain>
 <DM5PR02MB2713DB568A4AD713BE3B2621A7490@DM5PR02MB2713.namprd02.prod.outlook.com>
From:   Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <ff914561-a021-9405-8b26-11d4a5cc605d@lucaceresoli.net>
Date:   Tue, 12 Mar 2019 16:03:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <DM5PR02MB2713DB568A4AD713BE3B2621A7490@DM5PR02MB2713.namprd02.prod.outlook.com>
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

Hi Vishal, Sakari,

On 12/03/19 15:45, Vishal Sagar wrote:
>>> +- xlnx,en-csi-v2-0: Present if CSI v2 is enabled in IP configuration.
>>> +- xlnx,en-vcx: When present, there are maximum 16 virtual channels, else
>>> +  only 4. This is present only if xlnx,en-csi-v2-0 is present.
>>> +- xlnx,en-active-lanes: present if the number of active lanes can be
>>> +  reconfigured at runtime in the Protocol Configuration Register.
>>> +  If present, the V4L2_CID_XILINX_MIPICSISS_ACT_LANES control is added.
>>> +  Otherwise all lanes, as set in IP configuration, are always active.
>>
>> The bindings document hardware, therefore a V4L2 control name doesn't
>> belong here.
>>
> Ok. I will remove this and revert to original description as below -
> 
> xlnx,en-active-lanes: present if the number of active lanes can be
> re-configured at runtime in the Protocol Configuration Register

I'm to blame here as I suggested that text. However I still find the
original wording was ambiguous: my initial reading of it was close to
the opposite of the intended meaning. xlnx,en-active-lanes means "a
register exists to configure the active lanes at runtime" and I just
care that this is stated clearly and unambiguously.

If we cannot mention a control name here, why not just dropping it:

- xlnx,en-active-lanes: present if the number of active lanes can be
  reconfigured at runtime in the Protocol Configuration Register.
  Otherwise all lanes are always active.

-- 
Luca
