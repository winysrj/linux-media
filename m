Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:63278 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab3FNWnZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 18:43:25 -0400
Message-ID: <51BB9C88.1040606@gmail.com>
Date: Sat, 15 Jun 2013 00:43:20 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH v11 00/21] V4L2 clock and asynchronous probing
References: <1371236911-15131-1-git-send-email-g.liakhovetski@gmx.de> <2342425.VllfyDroN8@avalon> <Pine.LNX.4.64.1306142244310.11221@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1306142244310.11221@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 06/14/2013 10:45 PM, Guennadi Liakhovetski wrote:
> On Fri, 14 Jun 2013, Laurent Pinchart wrote:
>> >  On Friday 14 June 2013 21:08:10 Guennadi Liakhovetski wrote:
>>> >  >  v11 of the V4L2 clock helper and asynchronous probing patch set.
>>> >  >  Functionally identical to v10, only differences are a couple of comment
>>> >  >  lines and one renamed struct field - as requested by respectable
>>> >  >  reviewers:)
>>> >  >
>>> >  >  Only patches #15, 16 and 18 changed.
>> >
>> >  [snip]
>> >
>>> >  >    .../devicetree/bindings/media/sh_mobile_ceu.txt    |   18 +
>> >
>> >      Documentation/video4linux/v4l2-framework.txt is missing:-)
>
> I know. I will add it as soon as these patches are in.

Actually it would be nice to see some documentation, before this patch set
is merged. I don't think the whole concept is going to be changed or 
rejected
by Mauro at this point :) And we always have been pushing back on 
merging any
code without some corresponding documentation. The v4l2 API seems 
relatively
well documented, and I would prefer to keep it that way. :-)

Regards,
Sylwester

