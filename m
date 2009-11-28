Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:49043 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbZK1Uec (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 15:34:32 -0500
Message-ID: <4B11893D.5070209@s5r6.in-berlin.de>
Date: Sat, 28 Nov 2009 21:34:05 +0100
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
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>	 <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>	 <4B116954.5050706@s5r6.in-berlin.de>	 <9e4733910911281058i1b28f33bh64c724a89dcb8cf5@mail.gmail.com>	 <4B117DEA.3030400@s5r6.in-berlin.de> <9e4733910911281208t23c938a2l7537e248e1eda4ae@mail.gmail.com> <4B11881B.7000204@s5r6.in-berlin.de>
In-Reply-To: <4B11881B.7000204@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Richter wrote:
> Jon Smirl wrote:
>> We have one IR receiver device and multiple remotes. How does the
>> input system know how many devices to create corresponding to how many
>> remotes you have?
> 
> If several remotes are to be used on the same receiver, then they
> necessarily need to generate different scancodes, don't they?  Otherwise
> the input driver wouldn't be able to route their events to the
> respective subdevice.  But if they do generate different scancodes,
> there is no need to create subdevices just for EVIOCSKEYCODE's sake. (It
> might still be desirable to have subdevices for other reasons perhaps.)

PS, forgot to add:  If there is a real need to initiate device creation
from userspace, then ioctl is not the way to go.
-- 
Stefan Richter
-=====-==--= =-== ===--
http://arcgraph.de/sr/
