Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:24012 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbZBXNP4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 08:15:56 -0500
Date: Tue, 24 Feb 2009 14:15:40 +0100
From: Jean Delvare <khali@linux-fr.org>
To: John Pilkington <J.Pilk@tesco.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
Message-ID: <20090224141540.4b8a765f@hyperion.delvare>
In-Reply-To: <49A3DDFC.6010608@tesco.net>
References: <20090223144917.257a8f65@hyperion.delvare>
	<49A3DDFC.6010608@tesco.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi John,

(re-adding linux-media on Cc as I doubt you dropped it on purpose...)

On Tue, 24 Feb 2009 11:46:04 +0000, John Pilkington wrote:
> Jean Delvare wrote:
> 
> > * Enterprise-class distributions (RHEL, SLED) are not the right target
> >   for the v4l-dvb repository, so we don't care which kernels these are
> >   running.
> 
> I think you should be aware that the mythtv and ATrpms communities 
> include a significant number of people who have chosen to use the 
> CentOS_5 series in the hope of getting systems that do not need to be 
> reinstalled every few months.  I hope you won't disappoint them.

CentOS is a parasite, if it dies I can't care less. CentOS users have
the recurrent habit to expect professional support from the community
without giving anything in return. Even worse: they consider that
running an antediluvian OS is the default and they don't understand why
upstream developers won't help them.

You said it yourself: they expect to be able to keep the same system
for a long time. This is a service you normally get from Red Hat or
Novell, and you pay for it. This is something the community is
generally not willing to offer for free, because it is not fun.

If the MythTV community cares that much about the v4l-dvb tree, they are
free to fork it right before support for kernel 2.6.18 is dropped, and
maintain that copy themselves. But their model is broken to start with:
sticking to a several-year-old kernel and OS, and OTOH picking critical
(for their use case) kernel drivers from a development tree which
evolves continuously by definition, makes little sense. Then again, I
would be happy to keep support for them if the cost wasn't too high.
But right now, the cost _is_ too high.

Your view of community distributions is a bit too negative BTW. You
don't need to go to the extreme CentOS_5 is to not have to reinstall
every few months. openSUSE distributions are maintained for 2 years for
example.

-- 
Jean Delvare
