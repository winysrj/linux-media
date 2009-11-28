Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:49605 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbZK1Vqv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 16:46:51 -0500
Message-ID: <4B119A36.8020903@s5r6.in-berlin.de>
Date: Sat, 28 Nov 2009 22:46:30 +0100
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
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>	 <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>	 <4B116954.5050706@s5r6.in-berlin.de>	 <9e4733910911281058i1b28f33bh64c724a89dcb8cf5@mail.gmail.com>	 <4B117DEA.3030400@s5r6.in-berlin.de>	 <9e4733910911281208t23c938a2l7537e248e1eda4ae@mail.gmail.com>	 <4B11881B.7000204@s5r6.in-berlin.de> <9e4733910911281246r65670e1free76e98ff4a23822@mail.gmail.com>
In-Reply-To: <9e4733910911281246r65670e1free76e98ff4a23822@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jon Smirl wrote:
> On Sat, Nov 28, 2009 at 3:29 PM, Stefan Richter
> <stefanr@s5r6.in-berlin.de> wrote:
>> Jon Smirl wrote:
>>> We have one IR receiver device and multiple remotes. How does the
>>> input system know how many devices to create corresponding to how many
>>> remotes you have?
>> If several remotes are to be used on the same receiver, then they
>> necessarily need to generate different scancodes, don't they?  Otherwise
                                          ^^^^^^^^^
I referred to scancodes, not keycodes.

>> the input driver wouldn't be able to route their events to the
>> respective subdevice.  But if they do generate different scancodes,
>> there is no need to create subdevices just for EVIOCSKEYCODE's sake. (It
>> might still be desirable to have subdevices for other reasons perhaps.)
> 
> Multiple remotes will have duplicate buttons (1, 2 ,3, power, mute,
> etc) these should get mapped into the standard keycodes. You need to
> devices to key things straight.
> 
> Push button 1 on Remote A. That should generate a KP_1 on the evdev
> interface for that remote.
> Push button 1 on Remote B. That should generate a KP_1 on the evdev
> interface for that remote.
> 
> Scenario for this - a mutifunction remote that is controlling two
> different devices/apps. In one mode the 1 might be a channel number,
> in the other mode it might be a telephone number.
> 
> The user may chose to make button 1 on both remote A/B map to KP_1 on
> a single interface.
> 
> Scenario for this - I want to use two different remotes to control a
> single device.
> 
> ---------------------
> 
> I handled that in configds like this:
> /configfs - mount the basic configfs
> /configfs/remotes (created by loading IR support)
> mkdir /configfs/remotes/remote_A  - this causes the input subdevice to
> be created, the name of it appears in the created directory.
[...]

I'm lost.  If there are two remotes sending to a single receiver, and
their sets of scancodes do not overlap, then all is fine.  You can map
either set of scancodes to keycodes independently.  But if their ranges
of scancodes do overlap, then even the creation of subdevices does not
help --- the driver has no way to tell which of the remotes sent the
signal in order to select the corresponding input subdevice, does it?
-- 
Stefan Richter
-=====-==--= =-== ===--
http://arcgraph.de/sr/
