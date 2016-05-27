Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:34805 "EHLO
	mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbcE0Lg7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 07:36:59 -0400
Received: by mail-lf0-f44.google.com with SMTP id k98so44735131lfi.1
        for <linux-media@vger.kernel.org>; Fri, 27 May 2016 04:36:58 -0700 (PDT)
Date: Fri, 27 May 2016 13:36:56 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
	<niklas.soderlund@ragnatech.se>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 8/8] [media] rcar-vin: add Gen2 and Gen3 fallback
 compatibility strings
Message-ID: <20160527113656.GI8307@bigcity.dyn.berto.se>
References: <1464203409-1279-1-git-send-email-niklas.soderlund@ragnatech.se>
 <1464203409-1279-9-git-send-email-niklas.soderlund@ragnatech.se>
 <26f0ba3a-2324-23ce-0933-452fe7e16542@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <26f0ba3a-2324-23ce-0933-452fe7e16542@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

On 2016-05-25 22:36:02 +0300, Sergei Shtylyov wrote:
> On 05/25/2016 10:10 PM, Niklas Söderlund wrote:
> 
> > From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > 
> > These are present in the soc-camera version of this driver and it's time
> > to add them to this driver as well.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-core.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> > index 520690c..87041db 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-core.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> > @@ -33,6 +33,8 @@ static const struct of_device_id rvin_of_id_table[] = {
> >  	{ .compatible = "renesas,vin-r8a7790", .data = (void *)RCAR_GEN2 },
> >  	{ .compatible = "renesas,vin-r8a7779", .data = (void *)RCAR_H1 },
> >  	{ .compatible = "renesas,vin-r8a7778", .data = (void *)RCAR_M1 },
> > +	{ .compatible = "renesas,rcar-gen3-vin", .data = (void *)RCAR_GEN3 },
> > +	{ .compatible = "renesas,rcar-gen2-vin", .data = (void *)RCAR_GEN2 },
> 
>    What's the point of adding the H3 specific compatibility string in the
> previous patch then? The fallback stings were added not have to updated the
> driver for every new SoC exactly.

Since this driver aims to replace the previous R-Car VIN driver which 
uses soc-camera I think it also should contain all the compatibility 
strings that the soc-camera driver do.

Other then that I have no strong opining and are happy to drop the 
previous patch if the intended use of the fallback strings are to use 
them over a SoC specific one.

-- 
Regards,
Niklas Söderlund
