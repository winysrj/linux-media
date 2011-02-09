Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:3360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab1BIPvi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Feb 2011 10:51:38 -0500
Message-ID: <4D52B7FA.7080606@redhat.com>
Date: Wed, 09 Feb 2011 13:51:22 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: firedtv and removal of old IEEE1394 stack
References: <201102031706.12714.hverkuil@xs4all.nl>	<20110205152122.3b566ef0@stein>	<20110205153215.03d55743@stein>	<4D5236E5.8060207@hoogenraad.net> <20110209142204.6eb445de@stein>
In-Reply-To: <20110209142204.6eb445de@stein>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 09-02-2011 11:22, Stefan Richter escreveu:
> On Feb 09 Jan Hoogenraad wrote:
>> For a problem description, and workaround, see:
>>
>> http://linuxtv.org/hg/~jhoogenraad/ubuntu-firedtv/
> 
> Do you mean
> http://linuxtv.org/hg/~jhoogenraad/ubuntu-firedtv/rev/c8e14191e48d
> "Disable FIREDTV for debian/ubuntu distributions with bad header files"?
> 
> I still don't see what the problem is.  If you have a kernel without
> drivers/ieee1394/*, then you also must have a kernel .config without
> CONFIG_IEEE1394.  Et voilà, firedtv builds fine (if CONFIG_FIREWIRE is y
> or m).  So, please make sure that .config and kernel sources match.
> 
> IOW the workaround c8e14191e48d addresses the wrong issue.  Don't disable
> CONFIG_DVB_FIREDTV; just make sure that the dependency of
> CONFIG_DVB_FIREDTV_IEEE1394 on CONFIG_IEEE1394 is taken into account, like
> in the mainline kernel's build system.

The out-of-tree build system tries to match the CONFIG_foo symbols found on
distros where this is possible, but sometimes the config symbol changes its
name. So, the out-of-tree building system has also a per-kernel version list
of drivers that need to be disabled with some older kernel versions (vanilla
kernels), where the driver is known to not work or compile.

The problem arises when a distro-patched kernel uses a newer version of a 
core ABI and not providing backport support for the old ABI.

Ubuntu has a bad history of doing things like that. On some cases, their "devel" 
kernel packages don't match some drivers shipped with it.

For example, some (all?) versions of Ubuntu distribute the alsa headers at the
kernel package that don't match the alsa core ABI found on it. So, if you 
compile a kernel driver based on it, the driver won't work, as symbols won't
match (to be worse, it generally compiles fine).

The firewire and alsa drivers compile and run fine on other distros like Fedora 
and RHEL. I never tried with other distros, so I can't provide a more complete
list, but I suspect that it will also work with Suse/Open Suse, as they also try
to preserve ABI backports.

The only fix for it is to disable the compilation of such drivers for the 
out-of-tree build if a broken distro kernel is detected. That's the approach 
of Jan's patches.

Cheers,
Mauro.
