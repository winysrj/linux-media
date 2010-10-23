Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:57860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756766Ab0JWN0g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Oct 2010 09:26:36 -0400
Message-ID: <4CC2E27D.6070101@redhat.com>
Date: Sat, 23 Oct 2010 11:26:21 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: linux-media@vger.kernel.org
Subject: Re: linuxtv.org Wiki (was Re: cx23885 module)
References: <BLU0-SMTP179D180C75C88F1B693AA73A75A0@phx.gbl>	<4CBE0D47.7080201@kernellabs.com>	<BLU0-SMTP3076739B1A745CCB3563D3A75C0@phx.gbl>	<4CBF57F3.1000008@kernellabs.com>	<SNT130-w25B4AAC1A5FC7F00372440A75E0@phx.gbl>	<4CC18C47.9070305@kernellabs.com> <878w1pkti4.fsf_-_@nemi.mork.no>
In-Reply-To: <878w1pkti4.fsf_-_@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 23-10-2010 10:01, Bjørn Mork escreveu:
> Steven Toth <stoth@kernellabs.com> writes:
>> On 10/22/10 9:02 AM, Daniel Lee Kim wrote:
>>
>>> One more question, is there a place I can go to learn how to compile just the
>>> cx23885.ko module? I am not able to compile only that module and so I have to
>>> wait until it compiles all the modules. I apologize as this is my first time
>>> tweaking a driver module. I've searched all over the net but have not found
>>> anyone who wrote about this. Thanks,
>>
>> The wiki at linuxtv.org should contain everything you need for
>> compiling, modifying and submitting patches.
> 
> It should, but it does not.
> 
> Following the path from 
> www.linuxtv.org => V4L-DVB Wiki => Developer Section => How to submit patches
> you end up at
> http://www.linuxtv.org/wiki/index.php/Development:_How_to_submit_patches
> which states
> 
>  'For V4L-DVB driver modules and/or documentation, patches should be
>   created against the master V4L-DVB mercurial tree; for instructions on
>   obtaining and building these sources, see the "How to Obtain, Build and
>   Install V4L-DVB Device Drivers" article.'
> 
> 
> and the "How to Obtain, Build and Install V4L-DVB Device Drivers"
> article contains more of the same outdated information, with its
> references to to 2.6.16 backwards compatibility and Mercurial.
> 
> For a new developer coming from the outside, this is worse than not
> having any information at all.  Anyone reading this list will know that
> the above quote is plain misleading.  But as a new developer you have no
> way to know whether other information in the same page, or even the
> whole Wiki, is just as misleading.  So you cannot trust any of it.
> Making the Wiki useless.
> 
> Never write documentation you do not plan to keep updated. Delete
> outdated documentation if you don't have time/resources to update it.
> Misleading documentation is much, much worse than no documentation.


It is a wiki for a community effort. If you found it outdated, please help us 
on keeping it uptodated.

Thanks,
Mauro

