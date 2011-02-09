Return-path: <mchehab@pedra>
Received: from einhorn.in-berlin.de ([192.109.42.8]:40969 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab1BIOZP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Feb 2011 09:25:15 -0500
Date: Wed, 9 Feb 2011 15:24:59 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: firedtv and removal of old IEEE1394 stack
Message-ID: <20110209152459.36abeda5@stein>
In-Reply-To: <20110209142204.6eb445de@stein>
References: <201102031706.12714.hverkuil@xs4all.nl>
	<20110205152122.3b566ef0@stein>
	<20110205153215.03d55743@stein>
	<4D5236E5.8060207@hoogenraad.net>
	<20110209142204.6eb445de@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Feb 09 Stefan Richter wrote:
> > https://bugs.launchpad.net/ubuntu/+source/linux-kernel-headers/+bug/134222

Correction:

Bug 134222 has *nothing* to do with the removal of the older ieee1394
stack.  The bug is about

  1. a defect during assembling the linux-kernel-headers package.
     The drivers/ieee1394/* files do not belong into such a package.
     They are driver source files, not exported kernel headers.

     Don't export kernel source files as linux-headers if they are not
     meant to be exported.

  2. the dvb backports relying on this broken package.  Tough luck.

     You want to build a kernelspace driver whose sources include other
     kernel sources?  Well, include these kernel sources, not some
     arbitrary userland source files.
-- 
Stefan Richter
-=====-==-== --=- -=--=
http://arcgraph.de/sr/
