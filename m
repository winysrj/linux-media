Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46260 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730876AbeITDXC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 23:23:02 -0400
Received: by mail-lf1-f65.google.com with SMTP id q22-v6so6463027lfa.13
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2018 14:43:10 -0700 (PDT)
Date: Wed, 19 Sep 2018 23:43:07 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH] rcar-csi2: add R8A77980 support
Message-ID: <20180919214307.GG4351@bigcity.dyn.berto.se>
References: <f6edfd44-7b08-e467-3486-795251816187@cogentembedded.com>
 <20180806180250.GD1635@bigcity.dyn.berto.se>
 <e2d1e9ea-f524-31f1-1561-2f0363981938@cogentembedded.com>
 <20180917111748.GT18450@bigcity.dyn.berto.se>
 <662a85e2-a26a-515c-2e0c-05df9f7570d8@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <662a85e2-a26a-515c-2e0c-05df9f7570d8@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

Thanks for still working on this,

On 2018-09-19 21:44:53 +0300, Sergei Shtylyov wrote:
> >>    CSI-2 on the Condor board is connected to a pair of MAX9286 GMSL 
> >>    de-serializers
> >> which are connected to 4 (composite?) connectors... There's supposed to be sensor
> >> chip on the other side, AFAIK...
> > 
> > There is experimental patches which are tested on V3M that uses the 
> > MAX9286 GMSL setup if you feel brave and want to try and extend them to 
> > cover V3H ;-P
> 
>    Wouldn't hurt having them. :-)

My bad the intention when pointing out the existence of the patches 
where of course to also provide a reference to them ;-)

Unfortunately the whole stack is a bit out of date. A old branch with 
framework + max9286 + rdacm20 patches can be found at:

git://git.ragnatech.se/linux v4l2/mux+gmsl

While updated branch with framework changes is:

git://git.ragnatech.se/linux v4l2/mux

-- 
Regards,
Niklas Söderlund
