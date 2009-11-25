Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:44757 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759013AbZKYSUR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 13:20:17 -0500
MIME-Version: 1.0
In-Reply-To: <E6F196CB-8F9E-4618-9283-F8F67D1D3EAF@wilsonet.com>
References: <BDZb9P9ZjFB@christoph> <m3skc25wpx.fsf@intrepid.localdomain>
	 <E6F196CB-8F9E-4618-9283-F8F67D1D3EAF@wilsonet.com>
Date: Wed, 25 Nov 2009 13:20:21 -0500
Message-ID: <829197380911251020y6f330f15mba32920ac63e97d3@mail.gmail.com>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
	Re: [PATCH 1/3 v2] lirc core device driver infrastructure
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, mchehab@redhat.com, superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 25, 2009 at 1:07 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
> Took me a minute to figure out exactly what you were talking about. You're referring to the current in-kernel decoding done on an ad-hoc basis for assorted remotes bundled with capture devices, correct?
>
> Admittedly, unifying those and the lirc driven devices hasn't really been on my radar.

This is one of the key use cases I would be very concerned with.  For
many users who have bought tuner products, the bundled remotes work
"out-of-the-box", regardless of whether lircd is installed.  I have no
objection so much as to saying "well, you have to install the lircd
service now", but there needs to be a way for the driver to
automatically tell lirc what the default remote control should be, to
avoid a regression in functionality.  We cannot go from a mode where
it worked automatically to a mode where now inexperienced users now
have to deal with the guts of getting lircd properly configured.

If such an interface were available, I would see to it that at least
all the devices I have added RC support for will continue to work
(converting the in-kernel RC profiles to lirc RC profiles as needed
and doing the associations with the driver).

The other key thing I don't think we have given much thought to is the
fact that in many tuners, the hardware does RC decoding and just
returns NEC/RC5/RC6 codes.  And in many of those cases, the hardware
has to be configured to know what format to receive.  We probably need
some kernel API such that the hardware can tell lirc what formats are
supported, and another API call to tell the hardware which mode to
operate in.

This is why I think we really should put together a list of use cases,
so that we can see how any given proposal addresses those use cases.
I offered to do such, but nobody seemed really interested in this.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
