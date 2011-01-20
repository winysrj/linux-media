Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39127 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab1ATEpX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 23:45:23 -0500
Received: by qyk12 with SMTP id 12so188360qyk.19
        for <linux-media@vger.kernel.org>; Wed, 19 Jan 2011 20:45:23 -0800 (PST)
Subject: Re: [GIT PATCHES for 2.6.38] Zilog Z8 IR unit fixes
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <0281052D-AFBF-4764-ADFF-64EF0A0CC2CB@wilsonet.com>
Date: Wed, 19 Jan 2011 23:45:17 -0500
Cc: Jean Delvare <khali@linux-fr.org>, Mike Isely <isely@isely.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Transfer-Encoding: 7bit
Message-Id: <DF6BA086-43FF-4FD9-A30E-EB8AAF451A94@wilsonet.com>
References: <1295205650.2400.27.camel@localhost> <1295234982.2407.38.camel@localhost> <848D2317-613E-42B1-950D-A227CFF15C5B@wilsonet.com> <1295439718.2093.17.camel@morgan.silverblock.net> <alpine.DEB.1.10.1101190714570.5396@ivanova.isely.net> <1295444282.4317.20.camel@morgan.silverblock.net> <20110119145002.6f94f800@endymion.delvare> <D7F0E4A6-5A23-4A28-95F8-0A088F1D6114@wilsonet.com> <20110119184322.0e5d12cd@endymion.delvare> <0281052D-AFBF-4764-ADFF-64EF0A0CC2CB@wilsonet.com>
To: Andy Walls <awalls@md.metrocast.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jan 19, 2011, at 3:08 PM, Jarod Wilson wrote:

> On Jan 19, 2011, at 12:43 PM, Jean Delvare wrote:
> 
>> Preliminary technical nitpicking: you can't actually pass two addresses
>> in i2c_board_info, so the second address has to be passed as platform
>> data.
>> 
>> I am sorry if you expected an authoritative answer, but... both options
>> are actually possible.
>> 
>> If you use a single call to i2c_new_device(), you'll have a single
>> i2c_client to start with, and you'll have to instantiate the second one
>> in the probe function using i2c_new_dummy().
>> 
>> If you instead decide to call i2c_new_device() twice, there will be two
>> calls to the probe function (which can be the same one in a single
>> driver, or two different ones in separate drivers, at your option.) If
>> any synchronization is needed between the two i2c_clients, you have to
>> use the bridge driver as a relay, as Andy proposed doing already.
>> 
>> Really, both are possible, and the two options aren't that different in
>> the end. I can't think of anything that can be done with one that
>> couldn't be achieved with the other.
> 
> Yeah, see my follow-up mail. The code in hdpvr-i2c.c is clearly a bit
> off now, and only worked in my testing, as at the time, I was using
> an older lirc_zilog from prior to Andy's changes that still used the
> old style binding and probing directly in the driver. I'm working on
> fixing up hdpvr-i2c further right now, and will do some more prodding
> with pvrusb2, the code for which looks correct with two i2c_new_device()
> calls in it, one for each address, so I just need to figure out why
> lirc_zilog is getting an -EIO trying to get tx brought up.

So as we were discussing on irc today, the -EIO is within lirc_zilog's
send_boot_data() function. The firmware is loaded, and then we send the
z8 a command to activate the firmware, immediately follow by an attempt
to read the firmware version. The z8 is still busy when we do that, and
throwing in a simple mdelay() remedies the problem for both the hvr-1950
and the hdpvr -- tried 100 initially, and all the way down to 20 still
worked, didn't try any lower.

And I definitely horked up the hdpvr i2c a bit, but have a follow-up
patch that goes back to doing the right thing with two i2c_new_device()
calls, which I've successfully tested with the latest lirc_zilog plus
mdelay patch.

Will post patches tomorrow though, its already past my bed time.

-- 
Jarod Wilson
jarod@wilsonet.com



