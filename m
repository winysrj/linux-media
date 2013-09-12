Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:49361 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab3ILUrf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Sep 2013 16:47:35 -0400
Received: by mail-wg0-f46.google.com with SMTP id k14so333592wgh.25
        for <linux-media@vger.kernel.org>; Thu, 12 Sep 2013 13:47:34 -0700 (PDT)
Message-ID: <52322860.30106@gmail.com>
Date: Thu, 12 Sep 2013 22:47:28 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?ISO-8859-1?Q?Frank_Sch=E4?= =?ISO-8859-1?Q?fer?=
	<fschaefer.oss@googlemail.com>
Subject: Re: [RFD] use-counting V4L2 clocks
References: <Pine.LNX.4.64.1309121947590.7038@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1309121947590.7038@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 09/12/2013 09:13 PM, Guennadi Liakhovetski wrote:
> So, I think, our V4L2 clock enable / disable calls should be balanced, and
> to enforce that a warning is helpful. Other opinions?

I'd assume we should enforce those calls balanced, but I might not be
well aware of consequences for the all existing drivers. AFAIR all drivers
used in embedded systems follow the convention where default power state
is off and the s_power() calls are balanced.

I never ventured much into drivers that originally used tuner.s_standby()
before it got renamed to core.s_power(). As Mauro indicated tuner devices
assume default device power ON state, but additional s_power(1) call should
not break things as Frank pointed out.

I'd say let's make s_power(1) calls balanced, keep the warning and revisit
drivers one by one as they get support for explicit clock control added.

--
Regards,
Sylwester
