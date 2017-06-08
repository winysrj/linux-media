Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:56741
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750788AbdFHL1m (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 07:27:42 -0400
Date: Thu, 8 Jun 2017 08:27:31 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-renesas-soc@vger.kernel.org,
        Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?=
        <niklas.soderlund@ragnatech.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] [media] soc_camera: rcar_vin: use proper name for
 the R-Car SoC
Message-ID: <20170608082731.7cdf32dd@vento.lan>
In-Reply-To: <20170529120202.GC4342@katana>
References: <20170528093051.11816-1-wsa+renesas@sang-engineering.com>
        <20170528093051.11816-7-wsa+renesas@sang-engineering.com>
        <a133a7f7-e887-5043-83d3-cccbec581487@cogentembedded.com>
        <20170529120202.GC4342@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 29 May 2017 14:02:02 +0200
Wolfram Sang <wsa@the-dreams.de> escreveu:

> >    Why "soc_camera:" in the subject?  
> 
> I used 'git log $file' and copied the most recent entry. Do I need to
> resend?
> 

No need to resend. I'll fix it when applying the patch.

Btw, I'm seeing only patches 6 and 7 here at media ML (and patchwork).
As those are trivial changes, I'll just apply what I have.

Thanks,
Mauro
