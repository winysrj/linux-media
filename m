Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932512Ab0BCQlg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 11:41:36 -0500
Message-ID: <4B69A732.7020408@redhat.com>
Date: Wed, 03 Feb 2010 14:41:22 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Any saa711x users out there?
References: <829197381002021451g5aaa8013kd5ae2124534ba5ba@mail.gmail.com>	 <4B68C35F.1080902@redhat.com> <829197381002030757k1cea81b7vb214b87cffc213aa@mail.gmail.com>
In-Reply-To: <829197381002030757k1cea81b7vb214b87cffc213aa@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Tue, Feb 2, 2010 at 7:29 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> The better is to allow enabling/disabling the anti-alias via ctrl.
>> Whatever default is chosen, the driver may adjust the control default
>> at the board initialization, or even blocking the control when the
>> other mode of operation is broken.
>>
>> I have here a few devices with saa7113 and saa7114. I think I have
>> also one device with saa7111, but I need to check. If I'm right, it will
>> take some time for me to prepare the saa7111 environment. The saa7113/7114
>> devices are easier to setup, as they are usb.
> 
> I actually am not very familiar with how custom controls work for v4l
> devices in terms of board specific configuration, as I'm more familiar
> with the way that you can provide a config struct during dvb_attach()
> for DVB devices.  I've obviously seen how they can be set from
> userland, but have never dug into the specific as to how a bridge
> would set the parameters.

Just call:

v4l2_device_call_all(&dev->v4l2_dev, 0, core, g_ctrl, ctrl);

For get a control, and:

v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_ctrl, ctrl);

to set a control.

> I actually have a test tree here which includes the change (as well as
> a couple of unrelated em28xx fixes I'm working on).
> 
> http://www.kernellabs.com/hg/~dheitmueller/em28xx-test
> 
> The change in that tree just flips on the Anti-alias filter bit in the
> saa7115_misc_init struct, so it ends up being applied for
> 7113/7114/7115.  However, I'm wondering if it makes sense to just have
> it on by default for all three boards (which is a *much* simpler
> change than adding a custom control and making sure it gets set
> properly by the bridge in all the various cases such as surviving a
> powerdown/powerup of the chip).

The chip powerup/powerdown should preserve all controls, anyway. I think
we need a general logic here to save/restore those values on those cases,
including hibernation/suspend. In the past, several of those drivers like
saa711x used to store the register values into a shadow array (although
the old code were ugly and haven't any suspend/resume logic).

Maybe we can resurrect this idea, in order to quickly recover from a 
powerdown/powerup situation. In general, the shadow array will have only
256 bytes on those chips.

> BTW, the tree above just forces the bit on for all three boards - I'm
> not proposing that should be the final fix, but it is enough to allow
> people to evaluate the effects of the change.

I'll test it later.

> I've got a PVR-350 board with a saa7115 which I will do some testing
> on.  If I see the artifacts on that board without the change, that
> bolsters the argument that the current default may just be wrong in
> general.

> 
> Mauro, the hg logs suggest that you added the saa7115 support (and in
> fact appear to have introduced the issue in question).  Do you
> remember what board you were using when you added the support?  Also,
> how did you arrive at the defaults that you used?  Were they based on
> some sort of i2c bus trace, or did you just set them by reading the
> datasheet?

Well, we used to have different drivers on that time. Basically, the code from all
saa711x drivers got merged and the init arrays were added as seen at the original 
driver. Then, fix patches were applied in order to make everybody happy.

A large number of tests were done on that time, as we've got contributions from
several developers. For sure we used some PVR boards, pvrusb2, WinTV USB2 and 
some bttv based boards with saa711x chips. Later, we've got feedback also from 
NT100x boards (usbvision driver) and I suspect we had tests with other drivers as well.
Some Zoran boards also use saa711x chips, and, after the port to V4L2, they're now
using the same driver.

-- 

Cheers,
Mauro
