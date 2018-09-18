Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39142 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730010AbeISAkN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 20:40:13 -0400
Received: by mail-lf1-f68.google.com with SMTP id v77-v6so2868869lfa.6
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2018 12:06:14 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Tue, 18 Sep 2018 21:06:10 +0200
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 1/3] i2c: adv748x: store number of CSI-2 lanes described
 in device tree
Message-ID: <20180918190610.GV18450@bigcity.dyn.berto.se>
References: <20180918014509.6394-1-niklas.soderlund+renesas@ragnatech.se>
 <3637555.oe00WY7olM@avalon>
 <73aff0c2-d058-c4ee-2d4c-e63eac724e98@ideasonboard.com>
 <1715235.WJqBHKOvrx@avalon>
 <21b8a885-48c5-70c8-8866-1830c45c27a9@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <21b8a885-48c5-70c8-8866-1830c45c27a9@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran and Laurent,

Thanks for all your comments!

On 2018-09-18 11:51:34 +0100, Kieran Bingham wrote:

[snip]

> > 
> > I'm not sure there's a sensible default, I'd rather specify it explicitly. 
> > Note that the data-lanes property doesn't just specify the number of lanes, 
> > but also how they are remapped, when that feature is supported by the CSI-2 
> > transmitter or receiver.
> 
> 
> Ok understood. As I feared - we can't really default - because it has to
> match and be defined.
> 
> So making the DT property mandatory really is the way to go then.

I will add a patch making the property mandatory.

-- 
Regards,
Niklas Söderlund
