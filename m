Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47043 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab1HaFfi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 01:35:38 -0400
Received: by wwf5 with SMTP id 5so374285wwf.1
        for <linux-media@vger.kernel.org>; Tue, 30 Aug 2011 22:35:36 -0700 (PDT)
Subject: Re: [PATCH] media: none of the drivers should be enabled by default
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <201108302139.23337.hverkuil@xs4all.nl>
References: <Pine.LNX.4.64.1108301921040.19151@axis700.grange>
	 <201108302139.23337.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 06:35:30 +0100
Message-ID: <1314768930.1992.4.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2011-08-30 at 21:39 +0200, Hans Verkuil wrote:
> On Tuesday, August 30, 2011 19:22:00 Guennadi Liakhovetski wrote:
> > None of the media drivers are compulsory, let users select which drivers
> > they want to build, instead of having to unselect them one by one.
> 
> I disagree with this: while this is fine for SoCs, for a generic kernel I
> think it is better to build it all. Even expert users can have a hard time
> figuring out what chip is in a particular device.
Yes, also if a driver is broken, a considerable amount of time could
have passed before it is known.

tvboxspy



