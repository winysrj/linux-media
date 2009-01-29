Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:39783 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093AbZA2DlJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2009 22:41:09 -0500
Subject: Re: cx18, HVR-1600 Clear qam tuning
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: siegeljb@umich.edu, linux-media@vger.kernel.org
In-Reply-To: <412bdbff0901281900w3d1b3b0we95608629b913fba@mail.gmail.com>
References: <2d21cac80901280817s4dcb498cx73c931e513f9161d@mail.gmail.com>
	 <1233191016.3098.4.camel@palomino.walls.org>
	 <2d21cac80901281856qbdb0541h762ecbbb6e85ab0a@mail.gmail.com>
	 <412bdbff0901281900w3d1b3b0we95608629b913fba@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 22:41:08 -0500
Message-Id: <1233200468.3098.39.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-01-28 at 22:00 -0500, Devin Heitmueller wrote:
> On Wed, Jan 28, 2009 at 9:56 PM, Jason Siegel <siegeljb@gmail.com> wrote:
> > Thanks Andy,
> >
> > That did the trick! QAM256 is working!
> >
> > -J

Jason,

Glad it worked for you.


> Really?  That made a difference?  Sure, I was expecting general tuning
> performance to improve, but I'm a bit surprised if it really makes the
> difference between "works with QAM256" and "doesn't work with QAM256".
> 
> Devin

Devin,

Well, since you noted a failure mechanism with a symptom of "not all
channels lock within X seconds", why couldn't it be the case that the
same mechanism causes "no channels lock within X seconds"? :)

Regards,
Andy

