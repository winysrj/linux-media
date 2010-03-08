Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab0CHBgf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Mar 2010 20:36:35 -0500
Message-ID: <4B945497.9010907@redhat.com>
Date: Sun, 07 Mar 2010 22:36:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: VDR User <user.vdr@gmail.com>
CC: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: "Invalid module format"
References: <alpine.LNX.2.00.1003041737290.18039@banach.math.auburn.edu>	 <alpine.LNX.2.00.1003051829210.21417@banach.math.auburn.edu>	 <a3ef07921003051651j12fbae25r5a3d5276b7da43b7@mail.gmail.com>	 <4B91AADD.4030300@xenotime.net> <4B91CE02.4090200@redhat.com>	 <a3ef07921003070955q7d7ce7e8j747c07d56a0ad98e@mail.gmail.com>	 <alpine.LNX.2.00.1003071557020.23682@banach.math.auburn.edu> <a3ef07921003071616l742095c1mfdc19b2cea88f22@mail.gmail.com>
In-Reply-To: <a3ef07921003071616l742095c1mfdc19b2cea88f22@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VDR User wrote:
> On Sun, Mar 7, 2010 at 2:03 PM, Theodore Kilgore
> <kilgota@banach.math.auburn.edu> wrote:
>> It seems that the problem is solved by a local re-compile of the kernel plus
>> its modules, using the original distro .config settings in order to do this.
>> What I suspect has happened is that there was a simultaneous minor upgrade
>> of gcc at the same time, and it is possible that this interfered. I would
>> further speculate that a similar problem happened with you, in your Debian
>> installation.
>>
>> Hoping that we have finally tracked this down.
> 
> It's a good theory.  However, when I did my "update", I had compiled
> the kernel, installed it, rebooted into it and then proceeded to grab
> a fresh v4l tree and go from there.  There wern't any package updates
> or anything else involved between the kernel compile and v4l compile.
> (except for the reboot into 2.6.33 of course.)

You may try to check if both the kernel files and the out of tree files are compiled
using the same file format, with something like:

$ objdump v4l/cx23885.ko /lib/modules/`uname -r`/kernel/drivers/ata/ahci.ko -a

v4l/cx23885.ko:     file format elf64-x86-64
v4l/cx23885.ko


/lib/modules/2.6.33/kernel/drivers/ata/ahci.ko:     file format elf64-x86-64
/lib/modules/2.6.33/kernel/drivers/ata/ahci.ko

(assuming that debian has ahci.ko compiled as module and at the right place - you may
need to find another module there, it this one doesn't exist).

Cheers,
Mauro

---

PS.: if you're using kernel 2.6.33, plus the latest v4l-dvb hg tree, you could 
alternatively use the latest git tree, as it is just 2.6.33 + drivers/media
(and media staging) updates.

I intend to keep v4l-dvb.git and fixes.git trees with 2.6.33 during all 2.6.34 rc cycle,
in order to help people to test the drivers, if we don't have any mandatory reason to
update to -rc1

