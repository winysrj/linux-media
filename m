Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:38735 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbZK1UqA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 15:46:00 -0500
MIME-Version: 1.0
In-Reply-To: <4B11881B.7000204@s5r6.in-berlin.de>
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>
	 <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>
	 <4B116954.5050706@s5r6.in-berlin.de>
	 <9e4733910911281058i1b28f33bh64c724a89dcb8cf5@mail.gmail.com>
	 <4B117DEA.3030400@s5r6.in-berlin.de>
	 <9e4733910911281208t23c938a2l7537e248e1eda4ae@mail.gmail.com>
	 <4B11881B.7000204@s5r6.in-berlin.de>
Date: Sat, 28 Nov 2009 15:46:01 -0500
Message-ID: <9e4733910911281246r65670e1free76e98ff4a23822@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, khc@pm.waw.pl,
	awalls@radix.net, dmitry.torokhov@gmail.com, j@jannau.net,
	jarod@redhat.com, jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	maximlevitsky@gmail.com, mchehab@redhat.com, superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 28, 2009 at 3:29 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Jon Smirl wrote:
>> On Sat, Nov 28, 2009 at 2:45 PM, Stefan Richter
>> <stefanr@s5r6.in-berlin.de> wrote:
>>> Jon Smirl wrote:
>>>> Also, how do you create the devices for each remote? You would need to
>>>> create these devices before being able to do EVIOCSKEYCODE to them.
>>> The input subsystem creates devices on behalf of input drivers.  (Kernel
>>> drivers, that is.  Userspace drivers are per se not affected.)
>>
>> We have one IR receiver device and multiple remotes. How does the
>> input system know how many devices to create corresponding to how many
>> remotes you have?
>
> If several remotes are to be used on the same receiver, then they
> necessarily need to generate different scancodes, don't they?  Otherwise
> the input driver wouldn't be able to route their events to the
> respective subdevice.  But if they do generate different scancodes,
> there is no need to create subdevices just for EVIOCSKEYCODE's sake. (It
> might still be desirable to have subdevices for other reasons perhaps.)

Multiple remotes will have duplicate buttons (1, 2 ,3, power, mute,
etc) these should get mapped into the standard keycodes. You need to
devices to key things straight.

Push button 1 on Remote A. That should generate a KP_1 on the evdev
interface for that remote.
Push button 1 on Remote B. That should generate a KP_1 on the evdev
interface for that remote.

Scenario for this - a mutifunction remote that is controlling two
different devices/apps. In one mode the 1 might be a channel number,
in the other mode it might be a telephone number.

The user may chose to make button 1 on both remote A/B map to KP_1 on
a single interface.

Scenario for this - I want to use two different remotes to control a
single device.

---------------------

I handled that in configds like this:
/configfs - mount the basic configfs
/configfs/remotes (created by loading IR support)
mkdir /configfs/remotes/remote_A  - this causes the input subdevice to
be created, the name of it appears in the created directory.

--- this entry really shouldn't be called "remote" it should be named
"application" . Then you build map entries under it for the keycodes
the app knows about. Nothing prevents you from adding entries that map
both Remote_A_1 and Remote_B_1 to KP_1.

-- it's not sufficient to support a single application. I might be
running mythtv, a voip phone, home automation, etc all using a remote.
 By switching modes on a multifunction remote I can switch apps.

mkdir /configfs/remotes/remote_A/... - now build the mapping entires.


> --
> Stefan Richter
> -=====-==--= =-== ===--
> http://arcgraph.de/sr/
>



-- 
Jon Smirl
jonsmirl@gmail.com
