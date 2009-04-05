Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:20615 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486AbZDEUXL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Apr 2009 16:23:11 -0400
Date: Sun, 5 Apr 2009 22:22:50 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@radix.net>
Cc: Janne Grunau <j@jannau.net>, Hans Verkuil <hverkuil@xs4all.nl>,
	Mike Isely <isely@pobox.com>, isely@isely.net,
	LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
  model
Message-ID: <20090405222250.64ed67ae@hyperion.delvare>
In-Reply-To: <1238957897.3337.50.camel@morgan.walls.org>
References: <20090404142427.6e81f316@hyperion.delvare>
	<Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
	<20090405010539.187e6268@hyperion.delvare>
	<200904050746.47451.hverkuil@xs4all.nl>
	<20090405143748.GC10556@aniel>
	<1238953174.3337.12.camel@morgan.walls.org>
	<20090405183154.GE10556@aniel>
	<1238957897.3337.50.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 05 Apr 2009 14:58:17 -0400, Andy Walls wrote:
> On Sun, 2009-04-05 at 20:31 +0200, Janne Grunau wrote:
> > I have devices for lirc_zilog (which should probably be merged with
> > lirc_i2c) 
> 
> Hmmm. Following Jean's reasoning, that may be the wrong way to go, if
> you want to avoid probing.  A module to handle each specific type of I2C
> IR chip, splitting up lirc_i2c and leaving lirc_zilog as is, may be
> better in the long run.

This really doesn't matter. With the new binding model, probing is
under control. You can do probing on some cards and not others, and you
can probe some addresses and not others. And one i2c drivers can
cleanly support more than one device type.

What should be considered to decide whether two devices should be
supported by the same driver or not, is how much their supporting code
has in common.

-- 
Jean Delvare
