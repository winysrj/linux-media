Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:36379 "EHLO
	mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbcHAQwM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2016 12:52:12 -0400
Received: by mail-lf0-f44.google.com with SMTP id g62so119808166lfe.3
        for <linux-media@vger.kernel.org>; Mon, 01 Aug 2016 09:52:10 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Mon, 1 Aug 2016 18:52:07 +0200
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	slongerbeam@gmail.com, lars@metafoo.de, mchehab@kernel.org,
	hans.verkuil@cisco.com
Subject: Re: [PATCH 1/6] media: rcar-vin: allow field to be changed
Message-ID: <20160801165207.GD3672@bigcity.dyn.berto.se>
References: <20160729174012.14331-1-niklas.soderlund+renesas@ragnatech.se>
 <20160729174012.14331-2-niklas.soderlund+renesas@ragnatech.se>
 <1f735458-9ff3-f3fc-e349-20ac0b57cde1@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1f735458-9ff3-f3fc-e349-20ac0b57cde1@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

Thanks for testing!

On 2016-07-30 00:04:33 +0300, Sergei Shtylyov wrote:
> On 07/29/2016 08:40 PM, Niklas Söderlund wrote:
> 
> > The driver forced whatever field was set by the source subdevice to be
> > used. This patch allows the user to change from the default field.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
>    I didn't apply this patch at first (thinking it was unnecessary), and the
> capture worked fine. The field order appeared swapped again after I did
> import this patch as well. :-(

I had a look at the test tool you told me you use 
(https://linuxtv.org/downloads/v4l-dvb-apis/capture-example.html) and 
the reason the field order is swapped is a combination of that tool and 
how the rcar-vin driver interprets V4L2_FIELD_INTERLACED.

1. The tool you use asks for V4L2_FIELD_INTERLACED if the -f switch is 
   used. You told me #v4l that you do use that switch, but have modified 
   the tool to use a different pixelformat than used in the link above, 
   correct?

2. The rcar-vin driver interprets V4L2_FIELD_INTERLACED as 
   V4L2_FIELD_INTERLACED_TB. If this is correct or not I do not know, 
   the old soc-camera version of the driver do it this way so I have 
   kept that logic.

This is the reason why the field order is wrong when you apply this 
patch. Without it the field order would be locked to whatever the 
subdevice reports, V4L2_FIELD_ALTERNATE in this case.

I don't know if it's correct to treat V4L2_FIELD_INTERLACED as 
V4L2_FIELD_INTERLACED_TB or if I should try and use G_STD if 
V4L2_FIELD_INTERLACED is requested and change the field to _TB or _BT 
according to the result of that. I feel this will only push the problem 
further down. What if G_STD is not implemented by the subdevice? Then a 
default fallback interpretation to ether _TB or _BT would still be 
needed. I'm open to suggestion on how to handle this case.

There is also a feature missing in this patch. The field order was set 
to V4L2_FIELD_NONE if the requested format asks for V4L2_FIELD_ANY.  
This have no effect for how you test but i did run into it while trying 
to figure this out. I will send out a v2 which solves this by retaining 
the current field mode if V4L2_FIELD_ANY is asked for.

> 
> MBR, Sergei
> 

-- 
Regards,
Niklas Söderlund
