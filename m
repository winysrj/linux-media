Return-Path: <SRS0=Jwgu=RR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17E70C43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 14:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1E4E2075C
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 14:44:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=lucaceresoli.net header.i=@lucaceresoli.net header.b="LhJ2de9Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfCNOo0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Mar 2019 10:44:26 -0400
Received: from hostingweb31-40.netsons.net ([89.40.174.40]:54385 "EHLO
        hostingweb31-40.netsons.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726661AbfCNOo0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Mar 2019 10:44:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=lucaceresoli.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VC4EcTFcaJQ3IXGkzjyI+XA40vEY1qxWM8wK0CWjXt8=; b=LhJ2de9Za0sJUrak6zaHSUzx5Z
        /8Qky9+ZlBJXZQMbM1fJD9PuX9b0XmXB0ENZ0FdJJgxVcebNJcjmTxNG6WIrX8izDdkQZthg5zXib
        j1QF1uaGKq1GsbUf0ZGdyEehaQ2pCPAeRPXV45zL4J9SW5VItYPpHvZ8AXcajQJTZ1HU=;
Received: from [109.168.11.45] (port=50892 helo=[192.168.101.76])
        by hostingweb31.netsons.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@lucaceresoli.net>)
        id 1h4Rap-00HGsb-CS; Thu, 14 Mar 2019 15:44:23 +0100
Subject: Re: [PATCH v3 19/31] media: Documentation: Add GS_ROUTING
 documentation
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc:     laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
 <20190305185150.20776-20-jacopo+renesas@jmondi.org>
 <20190307151928.dogdsks22acqawc3@paasikivi.fi.intel.com>
From:   Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <c89691d5-2983-eb81-7c5c-9c56135e8852@lucaceresoli.net>
Date:   Thu, 14 Mar 2019 15:44:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190307151928.dogdsks22acqawc3@paasikivi.fi.intel.com>
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

Hi,

On 07/03/19 16:19, Sakari Ailus wrote:

...

>> +Description
>> +===========
>> +
>> +These ioctls are used to get and set the routing informations associated to
>> +media pads in a media entity. Routing informations are used to enable or disable
> 
> The routing is a property of an entity. How about
> 
> s/the routing informations associated to media pads in/routing/
> 
> s/R[^\.]+(?=\.)/The routing configuration determines the flows of data
> inside an entity/
> 
>> +data connections between stream endpoints of multiplexed media pads.

In the original wording, mentioning "multiplexed" is incorrect. Routing
can happen even between non-multiplexed streams, as e.g. in the AFE
driver in patch 27. Sakari's rewording is OK in this respect.

-- 
Luca
