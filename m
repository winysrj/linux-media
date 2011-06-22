Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:49385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758297Ab1FVWYm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 18:24:42 -0400
Message-ID: <4E026BA4.9010905@redhat.com>
Date: Wed, 22 Jun 2011 19:24:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?R=E9mi_Denis-Courmont?= <remi@remlab.net>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] vtunerc - virtual DVB device driver
References: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com> <BANLkTikmbVj1t7w3XmHXW58Kpvv0M_jbnQ@mail.gmail.com> <4E01DD57.3080508@redhat.com> <201106222218.14268.remi@remlab.net>
In-Reply-To: <201106222218.14268.remi@remlab.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 22-06-2011 16:18, Rémi Denis-Courmont escreveu:
> Le mercredi 22 juin 2011 15:17:27 Mauro Carvalho Chehab, vous avez écrit :
>>> My very little opinion is that waving GPL is way to the hell. Nobody told
>>> me why similar technologies, in different kernel parts are acceptable,
>>> but not here.
>>
>> If you want to do the networking code at userspace, why do you need a
>> kernel driver after all?
> 
> Are you seriously asking why people write tunneling drivers in user-space? Or 
> why they want to use the kernel-space socket API and protocol stack?
> 
>> The proper solution is to write an userspace
>> library for that, and either enclose such library inside the applications,
>> or use LD_PRELOAD to bind the library to handle the open/close/ioctl glibc
>> calls. libv4l does that. As it proofed to be a good library, now almost
>> all V4L applications are using it.
> 
> No. Set aside the problem of licensing, the correct way is to reuse existing 
> code, which means the layer-3/4 stacks and the socket API in net/*. That 
> avoids duplicating efforts (and bugs) and allows socket API apps to run 
> unchanged and without brittle hacks like LD_PRELOAD.
> 
> And indeed, that's what the Linux ecosystem does, thanks to the tuntap network 
> device driver.

Rémi,

Using the Kernel network layer is the right thing to do, but you don't need to add
a new driver for it: it is already there. All that userspace needs to do is to use
glibc socket's support.

It could make sense to have some sort of virtualization driver that would allow 
passing DVB API calls via, for example, the network socket API, to allow accessing
a physical DVB driver (or a remote machine DVB driver)from a VM machine. That was 
my original understanding.

Instead, the proposal is wrapper, that will be a sort of kernelspace implementation for
"LD_PRELOAD" that just returns the DVB commands back to some other application
in userspace. The real code to transmit DVB commands will be in userspace.

Technically speaking, this is a hack.

If I would code something like that, I would write it as a library with some functions like:
	connect_to_dvb()
	get_dvb_properties()
	get_frontend_parameters()
	set_frontend_parameters()
	get_dvb_ts()
And write a few patches for the userspace applications I would care.

If I wanted to provide transparent access to it, I would simply implement a LD_PRELOAD
schema, in order to help the new library deployment.

With such approach, at the initial stages (the worse case, e. g. using LD_PRELOAD), it will
be equivalent to have a kernel wrapper code, but, at long term, it will allow important
optimizations, like avoiding the need of copying data from/to the wrapper, supporting the extra
delays introducing by the network and allowing the applications to implement themselves the
dialog windows to control the network properties.

Thanks,
Mauro.
