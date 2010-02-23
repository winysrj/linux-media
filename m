Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:41760 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871Ab0BWOec (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 09:34:32 -0500
Subject: Re: [linux-dvb] soft demux device
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
In-Reply-To: <829000.26472.qm@web57006.mail.re3.yahoo.com>
References: <829000.26472.qm@web57006.mail.re3.yahoo.com>
Content-Type: text/plain
Date: Tue, 23 Feb 2010 09:34:27 -0500
Message-Id: <1266935667.4589.27.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-02-23 at 05:12 -0800, ozgur cagdas wrote:
> Hi All,
> 
> I have just compiled v4l-dvb successfully. My aim is to develop some
> experimental dvb applications on top of this dvb kernel api.
> Initially, I do not want to use any hardware and would like to play
> with the recorded ts files I have. So, is there any software demux
> device available within this package or somewhere else?

I do not know.  You could write a simple dvb_dummy driver module.  The
existing dvb_dummy_fe module would be helpful in such an endeavor, I
suppose.


>  If so, how can I load this device and make it work on a given ts file
> circularly?

Writing the TS to the /dev/dvb/adapter0/dvr0 device would be the way to
replay an existing TS file, IIRC.


>  On the other hand, I have no /dev/dvb node  at the moment, so should
> I do anything for this or would loading the driver create it
> automatically?

A dvb driver being loaded and registering should cause those to be
created automatically.

Regards,
Andy


