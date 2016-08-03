Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:36475 "EHLO
	mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbcHCNhl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2016 09:37:41 -0400
Received: by mail-lf0-f49.google.com with SMTP id g62so161263481lfe.3
        for <linux-media@vger.kernel.org>; Wed, 03 Aug 2016 06:36:22 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Wed, 3 Aug 2016 15:36:20 +0200
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	slongerbeam@gmail.com, lars@metafoo.de, mchehab@kernel.org,
	hans.verkuil@cisco.com
Subject: Re: [PATCHv2 5/7] media: rcar-vin: add support for
 V4L2_FIELD_ALTERNATE
Message-ID: <20160803133619.GM3672@bigcity.dyn.berto.se>
References: <20160802145107.24829-1-niklas.soderlund+renesas@ragnatech.se>
 <20160802145107.24829-6-niklas.soderlund+renesas@ragnatech.se>
 <0bfd0a3b-a5ac-e9f3-1295-72c7b0063e68@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0bfd0a3b-a5ac-e9f3-1295-72c7b0063e68@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-08-03 16:22:22 +0300, Sergei Shtylyov wrote:
> Hello.
> 
> On 08/02/2016 05:51 PM, Niklas Söderlund wrote:
> 
> > The HW can capture both ODD and EVEN fields in separate buffers so it's
> > possible to support V4L2_FIELD_ALTERNATE. This patch add support for
> > this mode.
> > 
> > At probe time and when S_STD is called the driver will default to use
> > V4L2_FIELD_INTERLACED if the subdevice reports V4L2_FIELD_ALTERNATE. The
> > driver will only change the field type if the subdevice implements
> > G_STD, if not it will keep the default at V4L2_FIELD_ALTERNATE.
> > 
> > The user can always explicitly ask for V4L2_FIELD_ALTERNATE in S_FTM and
> 
>    S_FMT?

yes :-)

> 
> > the driver will use that field format.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> [...]
> 
> MBR, Sergei
> 

-- 
Regards,
Niklas Söderlund
