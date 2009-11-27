Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:26857 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbZK0FGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 00:06:46 -0500
MIME-Version: 1.0
In-Reply-To: <20091127043318.GK6936@core.coreip.homeip.net>
References: <4B0A765F.7010204@redhat.com> <m36391tjj3.fsf@intrepid.localdomain>
	 <20091123173726.GE17813@core.coreip.homeip.net>
	 <4B0B6321.3050001@wilsonet.com>
	 <20091126053109.GE23244@core.coreip.homeip.net>
	 <A910E742-51B5-45E0-AD80-B9AE0728D9FB@wilsonet.com>
	 <20091126232311.GD6936@core.coreip.homeip.net>
	 <4B0F3963.8040701@wilsonet.com>
	 <9e4733910911261908l122263c3x68854e8a00334eae@mail.gmail.com>
	 <20091127043318.GK6936@core.coreip.homeip.net>
Date: Fri, 27 Nov 2009 00:06:52 -0500
Message-ID: <9e4733910911262106r553bb28brb5bef07dee3aae3b@mail.gmail.com>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
	Re: [PATCH 1/3 v2] lirc core device driver infrastructure
From: Jon Smirl <jonsmirl@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 26, 2009 at 11:33 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>> In the code I posted there is one evdev device for each configured
>> remote. Mapped single keycodes are presented on these devices for each
>> IR burst. There is no device for the IR receiver.  A LIRC type process
>> could watch these devices and then execute scripts based on the
>> keycodes reported.
>>
...
>
> Maybe we should revisit Jon's patchset as well. Regretfully I did not
> have time to do that when it was submitted the last time.

Consider my patch set a technology demo starting point. It shows a
modern architecture for integrating IR into evdev.  Use the input from
everyone else to turn these concepts into a real design. I wrote the
code for the fun of it, I have no commercial interest in IR. I was
annoyed with how LIRC handled Sony remotes on my home system.

The design is a clean slate implementation of IR for the kernel. No
attempt was made at legacy compatibility. I was familiar with evdev vs
/dev/mouse problems from my work on the X server. Because of working
on X I've also always hated keymaps (that's what drove the configfs
design).

I wish one of the set top box or TV manufacturers would step up and
own this.  They are the ones that would benefit the most. Jarod would
probably be open to some consulting, right?

-- 
Jon Smirl
jonsmirl@gmail.com
