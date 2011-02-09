Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:2857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab1BIQFT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Feb 2011 11:05:19 -0500
Message-ID: <4D52BB30.6080900@redhat.com>
Date: Wed, 09 Feb 2011 14:05:04 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: firedtv and removal of old IEEE1394 stack
References: <201102031706.12714.hverkuil@xs4all.nl>	<20110205152122.3b566ef0@stein>	<20110205153215.03d55743@stein>	<4D5236E5.8060207@hoogenraad.net>	<20110209142204.6eb445de@stein> <20110209152459.36abeda5@stein>
In-Reply-To: <20110209152459.36abeda5@stein>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 09-02-2011 12:24, Stefan Richter escreveu:
> On Feb 09 Stefan Richter wrote:
>>> https://bugs.launchpad.net/ubuntu/+source/linux-kernel-headers/+bug/134222
> 
> Correction:
> 
> Bug 134222 has *nothing* to do with the removal of the older ieee1394
> stack.  

Agreed.

> The bug is about
> 
>   1. a defect during assembling the linux-kernel-headers package.

Yes.

>      The drivers/ieee1394/* files do not belong into such a package.
>      They are driver source files, not exported kernel headers.
> 
>      Don't export kernel source files as linux-headers if they are not
>      meant to be exported.

It would be fine if they match the ABI symbols found on the vanilla kernel
for the same version. If they don't match, the media backport system could
have a fix, as there are several cases where the backport system detects
for some specific ABI changes, and apply some solution that will make the
driver compile and work with that ABI version.
 
>   2. the dvb backports relying on this broken package.  Tough luck.
> 
>      You want to build a kernelspace driver whose sources include other
>      kernel sources?  Well, include these kernel sources, not some
>      arbitrary userland source files.

I partially agree

The media backport tree is meant only to help people to test media drivers. 
It is not meant to be used on production, as nobody is actually doing tests 
to check if the backports are fine for some specific distro.

So, it is an "use with your own risk" approach. If it doesn't work... well,
this can happen. People are free to fix and send us patches for it.

The real solution is to do a real backport for some specific distro. The
media_build might help to point where the ABI differences are, but some
additional changes may be required to be sure that the module will work
fine.

On the other hand, adding the Firewire stack at the media building tree
would probably add more pain, especially for the ones using other firewire
hardware and/or other distros.

In any case, I don't think that Stefan or any Firewire upstream developer
should do anything to solve it. It is a problem that needs to be addressed
by Ubuntu people, and/or by the developers that want to test the Firwire driver
with the Ubuntu-shipped kernel.

Cheers,
Mauro.
