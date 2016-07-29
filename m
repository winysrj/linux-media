Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:35596 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbcG2UQh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2016 16:16:37 -0400
Received: by mail-lf0-f43.google.com with SMTP id f93so78636313lfi.2
        for <linux-media@vger.kernel.org>; Fri, 29 Jul 2016 13:16:36 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Fri, 29 Jul 2016 22:16:34 +0200
To: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	slongerbeam@gmail.com, lars@metafoo.de, mchehab@kernel.org,
	hans.verkuil@cisco.com
Subject: Re: [PATCH 6/6] media: adv7180: fix field type
Message-ID: <20160729201634.GC3672@bigcity.dyn.berto.se>
References: <20160729174012.14331-1-niklas.soderlund+renesas@ragnatech.se>
 <20160729174012.14331-7-niklas.soderlund+renesas@ragnatech.se>
 <cc084571-3063-a883-b731-0ffe01c4fefa@cogentembedded.com>
 <df2a330f-30a3-e296-006e-204fa1771bb5@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <df2a330f-30a3-e296-006e-204fa1771bb5@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-07-29 12:32:30 -0700, Steve Longerbeam wrote:
> 
> On 07/29/2016 12:10 PM, Sergei Shtylyov wrote:
> > On 07/29/2016 08:40 PM, Niklas Söderlund wrote:
> > 
> > > From: Steve Longerbeam <slongerbeam@gmail.com>
> > > 
> > > The ADV7180 and ADV7182 transmit whole fields, bottom field followed
> > > by top (or vice-versa, depending on detected video standard). So
> > > for chips that do not have support for explicitly setting the field
> > > mode, set the field mode to V4L2_FIELD_ALTERNATE.
> > > 
> > > Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> > > [Niklas: changed filed type from V4L2_FIELD_SEQ_{TB,BT} to
> > > V4L2_FIELD_ALTERNATE]
> > > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > 
> > Tested-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> > 
> >    IIUC, it's a 4th version of this patch; you should have kept the
> > original change log (below --- tearline) and indicated that in the
> > subject.
> > 
> > MBR, Sergei
> 
> This version is fine with me. The i.mx6 h/w motion-compensation deinterlacer
> (VDIC)
> needs to know the field order, and it can't get that info from
> V4L2_FIELD_ALTERNATE,
> but it can still determine the order via querystd().
> 
> But I agree the change log should be preserved, and the V4L2_FIELD_ALTERNATE
> change
> added to the change log.

Yes, I will send a v2 containing the changelog. My bad for dropping it.

> 
> Acked-by: Steve Longerbeam <slongerbeam@gmail.com>
> 
> Steve
> 
> 

-- 
Regards,
Niklas Söderlund
