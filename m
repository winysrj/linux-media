Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59552 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbcAVQR2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2016 11:17:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Honza =?utf-8?B?UGV0cm91xaE=?= <jpetrous@gmail.com>
Cc: Sebastien LEDUC <sebastien.leduc@st.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: mediacontroller for framebuffer
Date: Fri, 22 Jan 2016 18:17:43 +0200
Message-ID: <145372199.rVcaveV4h8@avalon>
In-Reply-To: <CAJbz7-3ffWJTD-NH=JWAsUVWKGbuBm7g_OTEZ1R010X5aS_VbQ@mail.gmail.com>
References: <DF597D17D2F66F40A76F27D4E5D6E1A48B0F5CF5@SAFEX1MAIL1.st.com> <1707301.3M6CagkYeP@avalon> <CAJbz7-3ffWJTD-NH=JWAsUVWKGbuBm7g_OTEZ1R010X5aS_VbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Honza,

On Friday 22 January 2016 08:23:44 Honza Petrouš wrote:
> Hi Laurent
> 
> >> I have seen that a long time ago you had done some prototyping work for
> >> exposing framebuffer devices as media entities:
> >> http://www.spinics.net/lists/linux-fbdev/msg04408.html
> >> 
> >> What did happen to this prototyping ?
> >> Seems it has never been merged, so could you please explain why ?
> >> 
> >> We have some similar needs, so I'd like to understand the right way to go
> > 
> > The prototype has been dropped as the framebuffer subsystem got
> > deprecated. Display drivers should now use DRM/KMS.
> 
> FB is deprecated? Can you, please, provide some links regarding such talk?

https://lkml.org/lkml/2015/9/24/253

> Sorry for my ignorance, I was never so deep in DRM/KMS (as I treat that
> as big gun for my small embedded systems I was working on) and I'm
> still happy with simple FB support which I get from kernel.

DRM/KMS might be a bit complex for simple display controllers, but helpers 
that simplify driver development would certainly be welcome. All it will take 
is someone to write them :-)

-- 
Regards,

Laurent Pinchart

