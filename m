Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:48930 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676Ab0JWMBx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Oct 2010 08:01:53 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1P9cnG-000142-4x
	for linux-media@vger.kernel.org; Sat, 23 Oct 2010 14:01:50 +0200
Received: from nemi.mork.no ([148.122.252.4])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 23 Oct 2010 14:01:50 +0200
Received: from bjorn by nemi.mork.no with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 23 Oct 2010 14:01:50 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: linuxtv.org Wiki (was Re: cx23885 module)
Date: Sat, 23 Oct 2010 14:01:39 +0200
Message-ID: <878w1pkti4.fsf_-_@nemi.mork.no>
References: <BLU0-SMTP179D180C75C88F1B693AA73A75A0@phx.gbl>
	<4CBE0D47.7080201@kernellabs.com>
	<BLU0-SMTP3076739B1A745CCB3563D3A75C0@phx.gbl>
	<4CBF57F3.1000008@kernellabs.com>
	<SNT130-w25B4AAC1A5FC7F00372440A75E0@phx.gbl>
	<4CC18C47.9070305@kernellabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Steven Toth <stoth@kernellabs.com> writes:
> On 10/22/10 9:02 AM, Daniel Lee Kim wrote:
>
>> One more question, is there a place I can go to learn how to compile just the
>> cx23885.ko module? I am not able to compile only that module and so I have to
>> wait until it compiles all the modules. I apologize as this is my first time
>> tweaking a driver module. I've searched all over the net but have not found
>> anyone who wrote about this. Thanks,
>
> The wiki at linuxtv.org should contain everything you need for
> compiling, modifying and submitting patches.

It should, but it does not.

Following the path from 
www.linuxtv.org => V4L-DVB Wiki => Developer Section => How to submit patches
you end up at
http://www.linuxtv.org/wiki/index.php/Development:_How_to_submit_patches
which states

 'For V4L-DVB driver modules and/or documentation, patches should be
  created against the master V4L-DVB mercurial tree; for instructions on
  obtaining and building these sources, see the "How to Obtain, Build and
  Install V4L-DVB Device Drivers" article.'


and the "How to Obtain, Build and Install V4L-DVB Device Drivers"
article contains more of the same outdated information, with its
references to to 2.6.16 backwards compatibility and Mercurial.

For a new developer coming from the outside, this is worse than not
having any information at all.  Anyone reading this list will know that
the above quote is plain misleading.  But as a new developer you have no
way to know whether other information in the same page, or even the
whole Wiki, is just as misleading.  So you cannot trust any of it.
Making the Wiki useless.

Never write documentation you do not plan to keep updated. Delete
outdated documentation if you don't have time/resources to update it.
Misleading documentation is much, much worse than no documentation.

Bjørn


