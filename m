Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbZLAKqe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 05:46:34 -0500
Message-ID: <4B14F3EA.4090000@redhat.com>
Date: Tue, 01 Dec 2009 11:46:02 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Krzysztof Halasa <khc@pm.waw.pl>, Jon Smirl <jonsmirl@gmail.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	maximlevitsky@gmail.com, mchehab@redhat.com,
	stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>	 <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>	 <m3aay6y2m1.fsf@intrepid.localdomain>	 <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com>	 <1259450815.3137.19.camel@palomino.walls.org>	 <m3ocml6ppt.fsf@intrepid.localdomain> <1259542097.5231.78.camel@palomino.walls.org>
In-Reply-To: <1259542097.5231.78.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

   Hi,

> A current related problem is that i2c based devices can only be bound to
> only one of ir-kbd-i2c *or* lirc_i2c *or* lirc_zilog at any one time.
> Currently it is somewhat up to the bridge driver which binding is
> preferred.  Discussion about this for the pvrusb2 module had the biggest
> email churn IIRC.

Once lirc_dev is merged you can easily fix this:  You'll have *one* 
driver which supports *both* evdev and lirc interfaces.  If lircd opens 
the lirc interface raw data will be sent there, keystrokes come in via 
uinput.  Otherwise keystrokes are send directly via evdev.  Problem solved.

cheers,
   Gerd

PS:  Not sure this actually makes sense for the i2c case, as far I know
      these do decoding in hardware and don't provide access to the raw
      samples, so killing the in-kernel IR limits to make ir-kbd-i2c
      being on par with lirc_i2c might be more useful in this case.

