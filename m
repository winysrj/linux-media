Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48721 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757727Ab1DHT1D (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 15:27:03 -0400
Received: by wya21 with SMTP id 21so3367729wya.19
        for <linux-media@vger.kernel.org>; Fri, 08 Apr 2011 12:27:02 -0700 (PDT)
References: <1302267045.1749.38.camel@gagarin> <AFEB19DA-4FD6-4472-9825-F13A112B0E2A@wilsonet.com> <1302276147.1749.46.camel@gagarin> <B9A35B3D-DC47-4D95-88F5-5453DD3F506C@wilsonet.com> <BANLkTimyT98dabuYsrwLrcm2wQFv2uQB9g@mail.gmail.com> <44DC1ED9-2697-4F92-A81A-CD024C913CCB@wilsonet.com> <BANLkTi=3Gq+8kXm40O55y55O6A6Q4-3g-g@mail.gmail.com>
In-Reply-To: <BANLkTi=3Gq+8kXm40O55y55O6A6Q4-3g-g@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <CDB2A354-8564-447E-99A3-66502E83E4CB@wilsonet.com>
Content-Transfer-Encoding: 7bit
Cc: Lawrence Rust <lawrence@softsystem.co.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [PATCH] Fix cx88 remote control input
Date: Fri, 8 Apr 2011 15:27:09 -0400
To: Devin Heitmueller <dheitmueller@kernellabs.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Apr 8, 2011, at 2:38 PM, Devin Heitmueller wrote:
...
> I question the notion of introducing the requirement that all keymap
> definitions must have system codes without having really thought
> through the notion that it would result in breaking every existing
> keymap which hadn't been updated.

Speaks the the "too many of us are only hacking on this in their
limited free time" point I raised. Hack, hack, hack, test with the
hardware available on hand (which is actually quite a bit in my case,
I think I have upwards of 35 receivers and even more remotes now),
see that it works, move on to the next issue. I'm certainly guilty of
not looking at the bigger picture and thinking about possible
ramifications more than once. :)

...
>> I have quite a few pieces of Hauppauge hardware, several with IR
>> receivers and remotes, but all of which use ir-kbd-i2c (or
>> lirc_zilog), i.e., none of which pass along raw IR.
> 
> You don't have an HVR-950 or some other stick which announces RC5
> codes?  If not, let me know and I will send you something.  It's kind
> of silly for someone doing that sort of work to not have at least one
> product in each category of receiver.

I don't think I even fully realized before today that there was
Hauppauge hardware shipping with the grey remotes and a raw IR
receiver. All the Hauppauge stuff I've got is either i2c IR
(PVR-250, PVR-350, HVR-1950, HD-PVR) or came with a bundled mceusb
transceiver (HVR-1500Q, HVR-1800, HVR-950Q -- model 72241, iirc),
and its all working these days (modulo some quirks with the HD-PVR
that still need sorting, but they're not regressions, its actually
better now than it used to be).

So yeah, I guess I have a gap in my IR hardware collection here,
and would be happy to have something to fill it.

-- 
Jarod Wilson
jarod@wilsonet.com



