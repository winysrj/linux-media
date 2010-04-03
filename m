Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:49204 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752395Ab0DCAXj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Apr 2010 20:23:39 -0400
Subject: Re: V4L-DVB drivers and BKL
From: Andy Walls <awalls@md.metrocast.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
In-Reply-To: <n2y829197381004011429u1d405025t8586abebeb3948ef@mail.gmail.com>
References: <201004011001.10500.hverkuil@xs4all.nl>
	 <4BB4D9AB.6070907@redhat.com>
	 <g2q829197381004011129lc706e6c3jcac6dcc756012173@mail.gmail.com>
	 <201004012306.31471.hverkuil@xs4all.nl> <4BB50D1A.7020803@redhat.com>
	 <n2y829197381004011429u1d405025t8586abebeb3948ef@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 02 Apr 2010 20:23:45 -0400
Message-Id: <1270254225.3027.69.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2010-04-01 at 17:29 -0400, Devin Heitmueller wrote:
> On Thu, Apr 1, 2010 at 5:16 PM, Mauro Carvalho Chehab <mchehab@redhat.com>

> I think though that we need to favor stability/reliability over
> performance.

You mean doing the wrong thing, as fast as you can, isn't performing? ;)

I usually consider performance with two broad criteria

	- requirements correctly implemented (can be a weighted sum)
	- efficient use of limited resources (usually time or bandwidth)

Regards,
Andy

