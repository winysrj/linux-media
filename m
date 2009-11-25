Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:39448
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758796AbZKYSnZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 13:43:25 -0500
Subject: Re: [RFC] Should we create a raw input interface for IR's ?
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <829197380911251020y6f330f15mba32920ac63e97d3@mail.gmail.com>
Date: Wed, 25 Nov 2009 13:43:24 -0500
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, mchehab@redhat.com, superm1@ubuntu.com
Content-Transfer-Encoding: 8BIT
Message-Id: <E88E119C-BB86-4F01-8C2C-E514AC6BA5E2@wilsonet.com>
References: <BDZb9P9ZjFB@christoph> <m3skc25wpx.fsf@intrepid.localdomain> <E6F196CB-8F9E-4618-9283-F8F67D1D3EAF@wilsonet.com> <829197380911251020y6f330f15mba32920ac63e97d3@mail.gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Nov 25, 2009, at 1:20 PM, Devin Heitmueller wrote:

> On Wed, Nov 25, 2009 at 1:07 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
>> Took me a minute to figure out exactly what you were talking about. You're referring to the current in-kernel decoding done on an ad-hoc basis for assorted remotes bundled with capture devices, correct?
>> 
>> Admittedly, unifying those and the lirc driven devices hasn't really been on my radar.
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

Agreed. Auto-config of lircd for remotes bundled with receivers is definitely on the TODO list. It sorta kinda works using gnome-lirc-properties, but well, that's not an actual lirc project component, and from what I've seen, its fairly incomplete (and reproduces a device ID list within its own code, that has never been fully updated to match the list of stuff the lirc drivers actually support).

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

Well, we've got a number of IOCTLs already, could extend those. (Although its been suggested elsewhere that we replace the IOCTLs with sysfs knobs). A simple sysfs attr that contains the name of the default config file for the bundled remote of a given receiver would seem simple enough to implement.

> This is why I think we really should put together a list of use cases,
> so that we can see how any given proposal addresses those use cases.
> I offered to do such, but nobody seemed really interested in this.

D'oh, sorry, I recall reading that email, but neglected to respond. Yes, I think that's useful, and would gladly contribute to the list.

-- 
Jarod Wilson
jarod@wilsonet.com



