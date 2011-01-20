Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40730 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab1ATEwf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 23:52:35 -0500
Received: by qyj19 with SMTP id 19so1476547qyj.19
        for <linux-media@vger.kernel.org>; Wed, 19 Jan 2011 20:52:34 -0800 (PST)
Subject: Re: [GIT PATCHES for 2.6.38] Zilog Z8 IR unit fixes
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <DF6BA086-43FF-4FD9-A30E-EB8AAF451A94@wilsonet.com>
Date: Wed, 19 Jan 2011 23:52:31 -0500
Cc: Jean Delvare <khali@linux-fr.org>, Mike Isely <isely@isely.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Transfer-Encoding: 7bit
Message-Id: <86D1EB39-C624-4AF9-96A4-26E139D89CD2@wilsonet.com>
References: <1295205650.2400.27.camel@localhost> <1295234982.2407.38.camel@localhost> <848D2317-613E-42B1-950D-A227CFF15C5B@wilsonet.com> <1295439718.2093.17.camel@morgan.silverblock.net> <alpine.DEB.1.10.1101190714570.5396@ivanova.isely.net> <1295444282.4317.20.camel@morgan.silverblock.net> <20110119145002.6f94f800@endymion.delvare> <D7F0E4A6-5A23-4A28-95F8-0A088F1D6114@wilsonet.com> <20110119184322.0e5d12cd@endymion.delvare> <0281052D-AFBF-4764-ADFF-64EF0A0CC2CB@wilsonet.com> <DF6BA086-43FF-4FD9-A30E-EB8AAF451A94@wilsonet.com>
To: Andy Walls <awalls@md.metrocast.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jan 19, 2011, at 11:45 PM, Jarod Wilson wrote:

> So as we were discussing on irc today, the -EIO is within lirc_zilog's
> send_boot_data() function. The firmware is loaded, and then we send the
> z8 a command to activate the firmware, immediately follow by an attempt
> to read the firmware version. The z8 is still busy when we do that, and
> throwing in a simple mdelay() remedies the problem for both the hvr-1950
> and the hdpvr -- tried 100 initially, and all the way down to 20 still
> worked, didn't try any lower.
> 
> And I definitely horked up the hdpvr i2c a bit, but have a follow-up
> patch that goes back to doing the right thing with two i2c_new_device()
> calls, which I've successfully tested with the latest lirc_zilog plus
> mdelay patch.
> 
> Will post patches tomorrow though, its already past my bed time.

D'oh. Forgot to mention: while lirc_zilog tx binds to the hvr-1950, it
doesn't actually work, I get -EIO when trying to transmit, iirc. So that
is on the list of things to poke at some tomorrow as well.

-- 
Jarod Wilson
jarod@wilsonet.com



