Return-path: <mchehab@pedra>
Received: from einhorn.in-berlin.de ([192.109.42.8]:40571 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab1BINWT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Feb 2011 08:22:19 -0500
Date: Wed, 9 Feb 2011 14:22:04 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: firedtv and removal of old IEEE1394 stack
Message-ID: <20110209142204.6eb445de@stein>
In-Reply-To: <4D5236E5.8060207@hoogenraad.net>
References: <201102031706.12714.hverkuil@xs4all.nl>
	<20110205152122.3b566ef0@stein>
	<20110205153215.03d55743@stein>
	<4D5236E5.8060207@hoogenraad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Feb 09 Jan Hoogenraad wrote:
> For a problem description, and workaround, see:
> 
> http://linuxtv.org/hg/~jhoogenraad/ubuntu-firedtv/

Do you mean
http://linuxtv.org/hg/~jhoogenraad/ubuntu-firedtv/rev/c8e14191e48d
"Disable FIREDTV for debian/ubuntu distributions with bad header files"?

I still don't see what the problem is.  If you have a kernel without
drivers/ieee1394/*, then you also must have a kernel .config without
CONFIG_IEEE1394.  Et voilà, firedtv builds fine (if CONFIG_FIREWIRE is y
or m).  So, please make sure that .config and kernel sources match.

IOW the workaround c8e14191e48d addresses the wrong issue.  Don't disable
CONFIG_DVB_FIREDTV; just make sure that the dependency of
CONFIG_DVB_FIREDTV_IEEE1394 on CONFIG_IEEE1394 is taken into account, like
in the mainline kernel's build system.

> and
> 
> https://bugs.launchpad.net/ubuntu/+source/linux-kernel-headers/+bug/134222

Well, if you move arbitrary drivers/*/*.h files somewhere else where they
were never intended to be exported to, and supplant Kconfig by some
homegrewn ad hoc configuration builder, then you are of course on your own.
Still, my above comment on .config having to match the kernel sources
applies just as well and fully describes the problem and its solution. :-)
-- 
Stefan Richter
-=====-==-== --=- -=--=
http://arcgraph.de/sr/
