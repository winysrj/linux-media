Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59913 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab0JHKqs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Oct 2010 06:46:48 -0400
Received: by iwn6 with SMTP id 6so535300iwn.19
        for <linux-media@vger.kernel.org>; Fri, 08 Oct 2010 03:46:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1010072012280.15141@axis700.grange>
References: <AANLkTimyR117ZiHq8GFz4YW5tBtW3k82NzGVZqKoVTbY@mail.gmail.com>
	<4CADA7ED.5020604@maxwell.research.nokia.com>
	<201010071527.41438.laurent.pinchart@ideasonboard.com>
	<19F8576C6E063C45BE387C64729E739404AA21D15A@dbde02.ent.ti.com>
	<Pine.LNX.4.64.1010072012280.15141@axis700.grange>
Date: Fri, 8 Oct 2010 12:46:47 +0200
Message-ID: <AANLkTi=7RARKbSWpRRJ8u3r3RZ8HP=VzJU3wgEgaQ+xy@mail.gmail.com>
Subject: Re: OMAP 3530 camera ISP forks and new media framework
From: Bastian Hecht <hechtb@googlemail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>> > > Bastian Hecht wrote:
>> > >
>> > > > I want to write a sensor driver for the mt9p031 (not mt9t031) camera
>> > > > chip and start getting confused about the different kernel forks and
>
> There is already an mt9t031 v4l2-subdev / soc-camera driver, so, if
> mt9t031 and mt9p031 are indeed similar enough, I think, the right way is
> to join efforts to port soc-camera over to the new "pad-level" API and
> re-use the driver.
>
> Thanks
> Guennadi
>

That would be wonderful. As this is my first contact with v4l2 in the
kernel I keep reading through the docs and the sources to get a firmer
grasp of all the stuff here.

Thanks,

Bastian

http://www.symplektikon.de/
