Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:60530 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab3JHROV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Oct 2013 13:14:21 -0400
Date: Tue, 8 Oct 2013 19:13:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?ISO-8859-1?Q?Frank_Sch=E4?= =?ISO-8859-1?Q?fer?=
	<fschaefer.oss@googlemail.com>
Subject: Re: [RFD] use-counting V4L2 clocks
In-Reply-To: <52322860.30106@gmail.com>
Message-ID: <Pine.LNX.4.64.1310081911340.31629@axis700.grange>
References: <Pine.LNX.4.64.1309121947590.7038@axis700.grange> <52322860.30106@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thu, 12 Sep 2013, Sylwester Nawrocki wrote:

> Hi Guennadi,
> 
> On 09/12/2013 09:13 PM, Guennadi Liakhovetski wrote:
> > So, I think, our V4L2 clock enable / disable calls should be balanced, and
> > to enforce that a warning is helpful. Other opinions?
> 
> I'd assume we should enforce those calls balanced, but I might not be
> well aware of consequences for the all existing drivers. AFAIR all drivers
> used in embedded systems follow the convention where default power state
> is off and the s_power() calls are balanced.
> 
> I never ventured much into drivers that originally used tuner.s_standby()
> before it got renamed to core.s_power(). As Mauro indicated tuner devices
> assume default device power ON state, but additional s_power(1) call should
> not break things as Frank pointed out.
> 
> I'd say let's make s_power(1) calls balanced, keep the warning and revisit
> drivers one by one as they get support for explicit clock control added.

Thanks for your feedback. Any more opinions?

Thanks
Guennadi

> --
> Regards,
> Sylwester

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
