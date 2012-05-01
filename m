Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1463 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab2EAMys (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2012 08:54:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Matthias Bock <mail@matthiasbock.net>
Subject: Re: RDS help needed
Date: Tue, 1 May 2012 14:53:59 +0200
Cc: linux-media@vger.kernel.org, v4l2-library@linuxtv.org
References: <1335869809.4592.14.camel@localhost>
In-Reply-To: <1335869809.4592.14.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205011453.59928.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue May 1 2012 12:56:49 Matthias Bock wrote:
> Hi there!
> 
> I hacked a RDS TMC-message receiver to work on the serial port.
> 
> http://www.matthiasbock.net/wiki/?title=Kategorie:GNS_TrafficBox_FM9_RDS_TMC-Receiver
> 
> According to
>  http://linuxtv.org/wiki/index.php/Radio_Data_System_(RDS)
> already several different receivers are available for usage
> with Linux but development of the RDS message daemon,
> that would be required to collect, decode and distribute
> the RDS messages to client applications
>  http://rdsd.berlios.de/
> kindof stucked, didn't progress since 2009 (!)
> 
> The available SVN sources only support
> SAA6588-based RDS receivers.
> 
> Is RDS support still an important task to
> someone on this list ?

It is on my list. I might actually be able to get someone to work on this as
a summerjob (no guarantees yet). The kernel side of things is well in hand,
but that RDS daemon is crap software and should be replaced with something
different (and above all, not daemon based).

> Is there someone, who would consider assisting me a little
> in writing some documentation on the RDS daemon project,
> some code maybe, lateron some linux kernel modules ?

I'd be happy to help with the kernel modules, but the userspace part depends
on whether I can get someone to work on this or not.

BTW, that RDS daemon does work fine, it's just way overengineered.

Regards,

	Hans
