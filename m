Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:48939 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbZK1U3h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 15:29:37 -0500
Message-ID: <4B11881B.7000204@s5r6.in-berlin.de>
Date: Sat, 28 Nov 2009 21:29:15 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Christoph Bartelmus <lirc@bartelmus.de>, khc@pm.waw.pl,
	awalls@radix.net, dmitry.torokhov@gmail.com, j@jannau.net,
	jarod@redhat.com, jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	maximlevitsky@gmail.com, mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR 	system?
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>	 <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>	 <4B116954.5050706@s5r6.in-berlin.de>	 <9e4733910911281058i1b28f33bh64c724a89dcb8cf5@mail.gmail.com>	 <4B117DEA.3030400@s5r6.in-berlin.de> <9e4733910911281208t23c938a2l7537e248e1eda4ae@mail.gmail.com>
In-Reply-To: <9e4733910911281208t23c938a2l7537e248e1eda4ae@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jon Smirl wrote:
> On Sat, Nov 28, 2009 at 2:45 PM, Stefan Richter
> <stefanr@s5r6.in-berlin.de> wrote:
>> Jon Smirl wrote:
>>> Also, how do you create the devices for each remote? You would need to
>>> create these devices before being able to do EVIOCSKEYCODE to them.
>> The input subsystem creates devices on behalf of input drivers.  (Kernel
>> drivers, that is.  Userspace drivers are per se not affected.)
> 
> We have one IR receiver device and multiple remotes. How does the
> input system know how many devices to create corresponding to how many
> remotes you have?

If several remotes are to be used on the same receiver, then they
necessarily need to generate different scancodes, don't they?  Otherwise
the input driver wouldn't be able to route their events to the
respective subdevice.  But if they do generate different scancodes,
there is no need to create subdevices just for EVIOCSKEYCODE's sake. (It
might still be desirable to have subdevices for other reasons perhaps.)
-- 
Stefan Richter
-=====-==--= =-== ===--
http://arcgraph.de/sr/
