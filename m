Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:64984 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557AbZLAX0k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 18:26:40 -0500
Subject: Re: Replace Mercurial with GIT as SCM
From: Andy Walls <awalls@radix.net>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.00.0912011003480.30797@pub3.ifh.de>
References: <alpine.LRH.2.00.0912011003480.30797@pub3.ifh.de>
Content-Type: text/plain
Date: Tue, 01 Dec 2009 18:25:00 -0500
Message-Id: <1259709900.3102.3.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-12-01 at 15:59 +0100, Patrick Boettcher wrote:
> Hi all,
> 
> I would like to start a discussion which ideally results in either 
> changing the SCM of v4l-dvb to git _or_ leaving everything as it is today 
> with mercurial.
> 

> I'm waiting for comments.

I only have one requirement: reduce bandwidth usage between the server
and my home.

The less I have to clone out 65 M of history to start a new series of
patches the better.  I suppose that would include a rebase...

Regards,
Andy

