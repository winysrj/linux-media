Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:33177 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbcHAQxL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2016 12:53:11 -0400
Received: by mail-lf0-f53.google.com with SMTP id b199so120048647lfe.0
        for <linux-media@vger.kernel.org>; Mon, 01 Aug 2016 09:53:10 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Mon, 1 Aug 2016 18:53:08 +0200
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	slongerbeam@gmail.com, lars@metafoo.de, mchehab@kernel.org,
	hans.verkuil@cisco.com
Subject: Re: [PATCH 4/6] media: rcar-vin: add support for V4L2_FIELD_ALTERNATE
Message-ID: <20160801165308.GE3672@bigcity.dyn.berto.se>
References: <20160729174012.14331-1-niklas.soderlund+renesas@ragnatech.se>
 <20160729174012.14331-5-niklas.soderlund+renesas@ragnatech.se>
 <028d6a5c-d86f-fce6-4278-12c561ebbe0d@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <028d6a5c-d86f-fce6-4278-12c561ebbe0d@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

On 2016-07-31 00:55:04 +0300, Sergei Shtylyov wrote:
> Hello.
> 
> On 07/29/2016 08:40 PM, Niklas Söderlund wrote:
> 
> > The HW can capture both ODD and EVEN fields in separate buffers so it's
> > possible to support this field mode.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soder
> 
>    It's probably worth adding that if the subdevice presents the video data
> in this mode, we prefer to use the hardware de-interlacing.

Will include this in v2, thanks for pointing it out.

> 
> MBR, Sergei
> 
> PS: I think I have a patch adding support for this mode to the old driver,
> so that it doesn't get borked with the patch #6 in this series.
> 

-- 
Regards,
Niklas Söderlund
