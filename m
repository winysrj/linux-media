Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:30820 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab0DQX0G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Apr 2010 19:26:06 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1137374fgg.1
        for <linux-media@vger.kernel.org>; Sat, 17 Apr 2010 16:26:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3d7d5c150911111556h253099a4mbc5d65c7b796151d@mail.gmail.com>
References: <3d7d5c150911021621g72461dao1e66a654b574af5f@mail.gmail.com>
	 <Pine.LNX.4.64.0911032250060.5059@axis700.grange>
	 <3d7d5c150911031413i2a3c23a1j8cb136b721b75da1@mail.gmail.com>
	 <3d7d5c150911111556h253099a4mbc5d65c7b796151d@mail.gmail.com>
Date: Sun, 18 Apr 2010 01:26:04 +0200
Message-ID: <s2jc384c5ea1004171626mb4c2cf98kf1b316b6293ae8ea@mail.gmail.com>
Subject: Re: Capturing video and still images using one driver
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Neil Johnson <realdealneil@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Neil,

I found this thread:

On Thu, Nov 12, 2009 at 1:56 AM, Neil Johnson <realdealneil@gmail.com> wrote:
> Unfortunately, I'm not a huge expert at making my code fit the
> video4linux model, so I've basically introduced some hacks that make
> it work for me.  I'll try to get my hackish code up to spec so that it
> will possibly be useful for others.
>
>>> On Mon, 2 Nov 2009, Neil Johnson wrote:
>>> > I am developing on the OMAP3 system using a micron/aptina mt9p031
>>> > 5-megapixel imager.  This CMOs imager supports full image capture at 5
>
I am in the same position (OMAP3 plus MT9P031) and I'm reasonably
familiar with the v4l2 code.

Are you able to share your code so far? My work will be GPL and
submitted upstream.

Regards,
-- 
Leon
