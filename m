Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41914 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727491AbeIQQop (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 12:44:45 -0400
Received: by mail-lf1-f67.google.com with SMTP id l26-v6so13189227lfc.8
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2018 04:17:51 -0700 (PDT)
Date: Mon, 17 Sep 2018 13:17:48 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH] rcar-csi2: add R8A77980 support
Message-ID: <20180917111748.GT18450@bigcity.dyn.berto.se>
References: <f6edfd44-7b08-e467-3486-795251816187@cogentembedded.com>
 <20180806180250.GD1635@bigcity.dyn.berto.se>
 <e2d1e9ea-f524-31f1-1561-2f0363981938@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e2d1e9ea-f524-31f1-1561-2f0363981938@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

On 2018-08-06 21:24:11 +0300, Sergei Shtylyov wrote:
> Hello!
> 
> On 08/06/2018 09:02 PM, Niklas Söderlund wrote:
> 
> > On 2018-08-06 19:56:27 +0300, Sergei Shtylyov wrote:
> >> Add the R-Car V3H (AKA R8A77980) SoC support to the R-Car CSI2 driver.
> >>
> >> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> > 
> > It looks good but before I add my tag I would like to know if you tested 
> > this on a V3H?
> 
>    No, have not tested the upstream patch, seemed too cumbersome (we did 
> test the BSP patch AFAIK).

Did you find time to test this change? I think it looks good but I would 
feel a lot better about this change if I knew it was tested :-) More 
often then not have we shaken a bug out of the rcar-{csi2,vin} tree by 
adding support for a new SoC.

Also if you for some reason need to resend this series could you split 
the DT documentation and driver changes in two separate patches?

> 
> > In the past extending the R-Car CSI-2 receiver to a new 
> > SoC always caught some new corner case :-)
> > 
> > I don't have access to a V3H myself otherwise I would of course test it 
> > myself.
> 
>    CSI-2 on the Condor board is connected to a pair of MAX9286 GMSL de-serializers
> which are connected to 4 (composite?) connectors... There's supposed to be sensor
> chip on the other side, AFAIK...

There is experimental patches which are tested on V3M that uses the 
MAX9286 GMSL setup if you feel brave and want to try and extend them to 
cover V3H ;-P

> 
> MBR, Sergei

-- 
Regards,
Niklas Söderlund
