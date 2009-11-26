Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:35876 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758263AbZKZDvI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 22:51:08 -0500
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, mchehab@redhat.com, superm1@ubuntu.com
In-Reply-To: <829197380911251020y6f330f15mba32920ac63e97d3@mail.gmail.com>
References: <BDZb9P9ZjFB@christoph> <m3skc25wpx.fsf@intrepid.localdomain>
	 <E6F196CB-8F9E-4618-9283-F8F67D1D3EAF@wilsonet.com>
	 <829197380911251020y6f330f15mba32920ac63e97d3@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 25 Nov 2009 22:50:00 -0500
Message-Id: <1259207400.3060.62.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-11-25 at 13:20 -0500, Devin Heitmueller wrote:
> On Wed, Nov 25, 2009 at 1:07 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
> > Took me a minute to figure out exactly what you were talking about. You're referring to the current in-kernel decoding done on an ad-hoc basis for assorted remotes bundled with capture devices, correct?
> >
> > Admittedly, unifying those and the lirc driven devices hasn't really been on my radar.
> 
> This is one of the key use cases I would be very concerned with.  For
> many users who have bought tuner products, the bundled remotes work
> "out-of-the-box", regardless of whether lircd is installed.  I have no
> objection so much as to saying "well, you have to install the lircd
> service now", but there needs to be a way for the driver to
> automatically tell lirc what the default remote control should be, to
> avoid a regression in functionality.  We cannot go from a mode where
> it worked automatically to a mode where now inexperienced users now
> have to deal with the guts of getting lircd properly configured.
> 
> If such an interface were available, I would see to it that at least
> all the devices I have added RC support for will continue to work
> (converting the in-kernel RC profiles to lirc RC profiles as needed
> and doing the associations with the driver).
> 
> The other key thing I don't think we have given much thought to is the
> fact that in many tuners, the hardware does RC decoding and just
> returns NEC/RC5/RC6 codes.  And in many of those cases, the hardware
> has to be configured to know what format to receive.  We probably need
> some kernel API such that the hardware can tell lirc what formats are
> supported, and another API call to tell the hardware which mode to
> operate in.

Please think about how we would need to augment the v4l_subdev_ir_ops:

http://linuxtv.org/hg/v4l-dvb/file/74ad936bcca2/linux/include/media/v4l2-subdev.h#l246
http://linuxtv.org/hg/v4l-dvb/file/74ad936bcca2/linux/include/media/v4l2-subdev.h#l305
http://linuxtv.org/hg/v4l-dvb/file/74ad936bcca2/linux/include/media/v4l2-subdev.h#l27

I think encapsulation of the various IR devices under V4L-DVB into
v4l_subdevices can facilitate your suggestions.


The CX23888 IR subdevice code configures itself to a single default
setup for Tx and Rx:

http://linuxtv.org/hg/v4l-dvb/file/74ad936bcca2/linux/drivers/media/video/cx23885/cx23888-ir.c#l1192
http://linuxtv.org/hg/v4l-dvb/file/74ad936bcca2/linux/drivers/media/video/cx23885/cx23888-ir.c#l1211

but there isn't a reason V4L2 IR subdevices couldn't configure to a per
"product" defaults based on information about the detected card from the
main bridge driver code.

Regards,
Andy

> This is why I think we really should put together a list of use cases,
> so that we can see how any given proposal addresses those use cases.
> I offered to do such, but nobody seemed really interested in this.
> 
> Devin


