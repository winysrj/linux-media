Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.sig21.net ([80.244.240.74]:56659 "EHLO mail.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbbK3P2b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2015 10:28:31 -0500
Date: Mon, 30 Nov 2015 16:28:29 +0100
From: Johannes Stezenbach <js@linuxtv.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: linuxtv.org downtime around Mon Nov 30 12:00 UTC
Message-ID: <20151130152829.GA8802@linuxtv.org>
References: <20151129161145.GA25209@linuxtv.org>
 <20151130133546.GA6255@linuxtv.org>
 <565C5C10.7050404@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <565C5C10.7050404@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 30, 2015 at 03:24:16PM +0100, Hans Verkuil wrote:
> On 11/30/2015 02:35 PM, Johannes Stezenbach wrote:
> > On Sun, Nov 29, 2015 at 05:11:45PM +0100, Johannes Stezenbach wrote:
> >> the linuxtv.org server will move to a new, freshly installed
> >> machine tomorrow.  Expect some downtime while we do the
> >> final rsync and database export+import.  I'm planning
> >> to start disabling services on the old server about
> >> 30min before 12:00 UTC (13:00 CET) on Mon Nov 30.
> >> If all goes well the new server will be available
> >> soon after 12:00 UTC.  The IP address will not change.
> > 
> > Done.  The new ssh host key:
> > RSA   SHA256:UY3VeEO8B/F7D/zghHGj46ioWcOqcpnGYCeEfVhTP1Q.
> > ECDSA key fingerprint is SHA256:xUEF4X6LaZeXMNiRkmLWx7Wj4jnIPB8+UsDLC35t8ik.
> 
> Hmm, git was working for a bit, but now it's gone again.

Now git-daemon is running, too, and it should be stable.

If not, please let me know.


Thanks,
Johannes
