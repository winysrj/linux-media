Return-path: <linux-media-owner@vger.kernel.org>
Received: from wmgw.wincomm.com.tw ([124.219.8.177]:64467 "EHLO
	wmgw.wincomm.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbbGTAxJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2015 20:53:09 -0400
Reply-To: <tonyc@wincomm.com.tw>
From: "Tony Chang\(Wincomm\)" <tonyc@wincomm.com.tw>
To: "'Steven Toth'" <stoth@kernellabs.com>,
	"'Antti Palosaari'" <crope@iki.fi>
Cc: "'Linux-Media'" <linux-media@vger.kernel.org>
References: <CALzAhNXQe7AtkwymcUeakVouMBmw7pG79-TeEjBMiK5ysXze_g@mail.gmail.com>
Subject: RE: Adding support for three new Hauppauge HVR-1275 variants - testers reqd.
Date: Mon, 20 Jul 2015 08:52:46 +0800
Message-ID: <9B8C9097BFD9499DBD908F556FCD58AB@wincomm.com.tw>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <CALzAhNXQe7AtkwymcUeakVouMBmw7pG79-TeEjBMiK5ysXze_g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear : Steven
Wow .. I can't believe 
You are so quickly with professional service
Thanks for your support . 
Very thanks 
Best Regards
-----Original Message-----
From: Steven Toth [mailto:stoth@kernellabs.com] 
Sent: Sunday, July 19, 2015 6:22 AM
To: tonyc@wincomm.com.tw; Antti Palosaari
Cc: Linux-Media
Subject: Adding support for three new Hauppauge HVR-1275 variants - testers
reqd.

http://git.linuxtv.org/cgit.cgi/stoth/hvr1275.git/log/?h=hvr-1275

Patches above are available for test.

Antti, note the change to SI2168 to add support for enabling and
disabling the SI2168 transport bus dynamically.

I've tested with a combo card, switching back and forward between QAM
and DVB-T, this works fine, just remember to select a different
frontend as we have two frontends on the same adapter,
adapter0/frontend0 is QAM/8SVB, adapter0/frontend1 is DVB-T/T2.

If any testers have the ATSC or DVB-T, I'd expect these to work
equally well, replease report feedback here.

Thanks,

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com

