Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F8FC43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 16:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 335BF217D9
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 16:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545235289;
	bh=KjVtgsaDR3fItCOlduFomsRDNTRefk72OVT5ycanHVk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=rUGG4SHw9rK4CMotcvWDdmUU7Qd3vid0XqeTel+hr4RoYAa6+eLLpRS+HUaHiyTal
	 ivMX35emLfrjQ+wgPK/kJDJBIBmUYBVzC0Ndc2gPqf3e76tFc5vVN4fOwnP/VTdS+W
	 LTJCNBwBRbjhSi2JPbnnbJ0mcjKgea0/p+dK2iIM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbeLSQBX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 11:01:23 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:42464 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727959AbeLSQBX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 11:01:23 -0500
Received: by mail-ot1-f68.google.com with SMTP id v23so19537359otk.9;
        Wed, 19 Dec 2018 08:01:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IPlkvNM9GsyzZD67er9Zgb7zoKIvhVOUgUKubFfAp0k=;
        b=T0XNbv3wG8rxqaX5c/yiuHD7N5+D7kDiiJ448IEpKp4qQDwFZ/bBlbwmd0XZUQLKBT
         ZcWUd/7EaotkGxEBRT/oU+j0ViQTQVYKv4cczBKi48tOurN1j+Yf2I2I7xgcOSW6kvv8
         ui1s98I3YupS6Np+IzPE8r0pUNbouKrt2e7nzs62iaFy5dd7rlDbAbvAhfl78Yern9Yd
         /tnzk28Y2lhbzfNJjyqiZPi030X346wTsJUI2M3tQzR5762YbAZR3uo46TaXwLcgQPxC
         UC3lLVL8gGo9pZeuUmYnpu61E4Ma462hVmjpd+VqARVFM9IsLqIhTW6VJPOv4io2QhnA
         478w==
X-Gm-Message-State: AA+aEWZ7luDvlrXXV2LJceQgCXIauARQnETJ60ElydyIe7yXiQMJJ5zq
        gxlGgrfSRGLdlZ9zjTQzAQ==
X-Google-Smtp-Source: AFSGD/WIO+D0wloRt8yliL36bwmAdCFAVBOfDeBY2iMpsNzbqObhjTxN6MgXkgLnR7hAxhfD/J/6hA==
X-Received: by 2002:a9d:c6a:: with SMTP id 97mr14856681otr.163.1545235282296;
        Wed, 19 Dec 2018 08:01:22 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id e81sm8769551oig.8.2018.12.19.08.01.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Dec 2018 08:01:21 -0800 (PST)
Date:   Wed, 19 Dec 2018 10:01:20 -0600
From:   Rob Herring <robh@kernel.org>
To:     Chen-Yu Tsai <wens@csie.org>
Cc:     Jagan Teki <jagan@amarulasolutions.com>,
        Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] dt-bindings: media: sun6i: Add vcc-csi supply
 property
Message-ID: <20181219160120.GB22708@bogus>
References: <20181203100747.16442-1-jagan@amarulasolutions.com>
 <20181203100747.16442-3-jagan@amarulasolutions.com>
 <CAGb2v66pG0kes1_xBNUj4z85fjunjP_Fe5_pPiRja=nDSOS01A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGb2v66pG0kes1_xBNUj4z85fjunjP_Fe5_pPiRja=nDSOS01A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Dec 03, 2018 at 06:11:35PM +0800, Chen-Yu Tsai wrote:
> On Mon, Dec 3, 2018 at 6:08 PM Jagan Teki <jagan@amarulasolutions.com> wrote:
> >
> > Most of the Allwinner A64 CSI controllers are supply with
> > VCC-PE pin. which need to supply for some of the boards to
> > trigger the power.
> >
> > So, document the supply property as vcc-csi so-that the required
> > board can eable it via device tree.
> >
> > Used vcc-csi instead of vcc-pe to have better naming convention
> > wrt other controller pin supplies.
> 
> This is not related to the CSI controller. It belongs in the pin
> controller, but that has its own set of problems like possible
> circular dependencies.

That might be a better choice, but I think most platforms put the supply 
in the module node. But that wouldn't work well if the module is not 
used and you want to use the pins for GPIO or some other function. Maybe 
we don't hit that property because most I/O supplies are always on.

Rob
