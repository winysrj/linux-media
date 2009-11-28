Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:50925 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbZK1UIf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 15:08:35 -0500
MIME-Version: 1.0
In-Reply-To: <4B117DEA.3030400@s5r6.in-berlin.de>
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>
	 <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>
	 <4B116954.5050706@s5r6.in-berlin.de>
	 <9e4733910911281058i1b28f33bh64c724a89dcb8cf5@mail.gmail.com>
	 <4B117DEA.3030400@s5r6.in-berlin.de>
Date: Sat, 28 Nov 2009 15:08:40 -0500
Message-ID: <9e4733910911281208t23c938a2l7537e248e1eda4ae@mail.gmail.com>
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

On Sat, Nov 28, 2009 at 2:45 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Jon Smirl wrote:
>> Also, how do you create the devices for each remote? You would need to
>> create these devices before being able to do EVIOCSKEYCODE to them.
>
> The input subsystem creates devices on behalf of input drivers.  (Kernel
> drivers, that is.  Userspace drivers are per se not affected.)

We have one IR receiver device and multiple remotes. How does the
input system know how many devices to create corresponding to how many
remotes you have? There is no current mechanism to do that. You need
an input device for each remote so that you can do the EVIOCSKEYCODE
against it. Some type of "create subdevice" IOCTL will need to be
built.

I handled that in configds like this:
/configfs - mount the basic configfs
/configfs/remotes (created by loading IR support)
mkdir /configfs/remotes/remote_A  - this causes the input subdevice to
be created, the name of it appears in the created directory.
mkdir /configfs/remotes/remote_A/... - now build the mapping entires.

This "create subdevice" IOCTL will need to take a name so that it can
be identified. You will probably another IOCTL to enumerate which
subdevices belong to the root device, etc...

Keyboards don't have subdevices. There is a 1:1 mapping between the
keyboard and the device driver.

-- 
Jon Smirl
jonsmirl@gmail.com
