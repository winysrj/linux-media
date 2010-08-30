Return-path: <mchehab@pedra>
Received: from v-smtp-auth-relay-1.gradwell.net ([79.135.125.40]:56009 "EHLO
	v-smtp-auth-relay-1.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755689Ab0H3UqS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Aug 2010 16:46:18 -0400
Received: from zntrx-gw.adsl.newnet.co.uk ([80.175.181.245] helo=echelon.upsilon.org.uk country=GB ident=dave$pop3$upsilon&org#uk)
          by v-smtp-auth-relay-1.gradwell.net with esmtpa (Gradwell gwh-smtpd 1.290) id 4c7c1898.1ddb.34
          for linux-media@vger.kernel.org; Mon, 30 Aug 2010 21:46:16 +0100
          (envelope-sender <news004@upsilon.org.uk>)
Message-ID: <+c0VYIBHiBfMFwln@echelon.upsilon.org.uk>
Date: Mon, 30 Aug 2010 21:45:59 +0100
To: linux-media@vger.kernel.org
From: dave cunningham <news004@upsilon.org.uk>
Subject: Re: Problems with Freecom USB DVB-T dongles
References: <+ay15VCWVXdMFw1S@echelon.upsilon.org.uk>
In-Reply-To: <+ay15VCWVXdMFw1S@echelon.upsilon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;charset=us-ascii;format=flowed
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

In message <+ay15VCWVXdMFw1S@echelon.upsilon.org.uk>, dave cunningham 
wrote

>Hi,
>
>I'm having problems with a pair of Freecom USB dongles and am wondering 
>if anyone has any pointers?
>

<snip>

>In dmesg at boot I see one message for each device
>"dvb-usb: recv bulk message failed: -110"
>
>Other than this everything seems OK.
>
>The system is running MythTV Backend (0.23) and I can have them both 
>recording simultaneously as I would expect.
>
>At some point however I start to get floods of messages to the console 
>(repeats of "dvb-usb: recv bulk message failed: -110") and the system 
>slows down to a crawl.
>

<snip>

I'm still looking for any suggestions. From a brief look at the source 
this message seems to be coming from a call to usb_bulk_msg.

Given that the dongles are OK in a via system does this likely suggest a 
compatibility issue with the USB host controller on the AMD 760G board?

I'm I likely to get anywhere trying to debug the code or will a USB 
analyser be required to work out what's going on?
-- 
Dave Cunningham                                  dave at upsilon org uk
                                                  PGP KEY ID: 0xA78636DC
