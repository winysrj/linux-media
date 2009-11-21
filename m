Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50721 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342AbZKUOiI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Nov 2009 09:38:08 -0500
Received: by ewy19 with SMTP id 19so469938ewy.21
        for <linux-media@vger.kernel.org>; Sat, 21 Nov 2009 06:38:13 -0800 (PST)
Date: Sat, 21 Nov 2009 15:37:51 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: g_remlin <g_remlin@rocketmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: CH???, Bandwidth 8MHz, Fec_Hi 1/2, Modulation QAM64, Mode 8K,
 Guard 1/4, fails to tune\demux
In-Reply-To: <4B06F484.5050700@rocketmail.com>
Message-ID: <alpine.DEB.2.01.0911211443110.6168@ybpnyubfg.ybpnyqbznva>
References: <4B06F484.5050700@rocketmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Howdy.

I'm afraid that your posting is horribly unclear, with the
apparently important information present in the Subject: header,
as such:

``Subject : Re: CH???, Bandwidth 8MHz, Fec_Hi 1/2, Modulation QAM64, Mode 8K,
          Guard 1/4, fails to tune\demux''

I'm going to go out on a limb and ass-u-me that you are writing
to ask about the DVB-H multiplex which is broadcast by SBC on
several different allocated SFN frequencies throughout
Confœderatio Helvetica.  The DVB-T services use a more 
conventional FEC of 5/6 in a denser network of transmitters.

Note that these frequencies are partly re-used in areas where it
is possible to receive simultaneously the out-of-area DVB-T
signals on the same frequency, which renders both impossible to
receive, in spite of a healthy signal strength.  I don't know if
this might affect you.

Not only is this multiplex sent in DVB-H standard, but it is
also a subscription service.  Therefore at best you can read the
PIDs corresponding to the various services, but you aren't going
to be able to watch anything, as different utilities may come to
terms with the datastreams in different ways.  Most Linux 
utilities likely don't know anything of the DVB-H parsing needed
for this service.

Note that I want to verify that this multiplex uses the more
robust QAM16 along with 1/2 FEC rather than the QAM64 you have
given, in order to permit best operation in diverse terrain,
but I can't find my parse results from the datastream amongst
my active disks.  In any case, you can try this tuning option
to see if you get a lock.

In order to receive these broadcasts, you will need to be a
subscriber to this service -- I suggest that you get in touch
with your nearest Swisscom to point you at the provider, though
Sunrise or Orange or anyone else can probably point you to the
provider of this service, who is unknown to me.  I doubt you
will achieve any Linux-based satisfaction here.

If this is not that to which you refer, then please re-formulate
your question in a less ambiguous and more geographically-specific
way, and sorry that I've wasted your time.


thanks,
barry bouwsma


On Fri, 20 Nov 2009, g_remlin wrote:

> 02:09.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
>         Subsystem: Technotrend Systemtechnik GmbH Technotrend-Budget/Hauppauge
> WinTV-NOVA-T DVB card
>         Flags: bus master, medium devsel, latency 32, IRQ 17
>         Memory at e3001000 (32-bit, non-prefetchable) [size=512]
>         Kernel driver in use: budget dvb
>         Kernel modules: budget
> 
