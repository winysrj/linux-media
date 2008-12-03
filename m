Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1L7teC-00035k-Q7
	for linux-dvb@linuxtv.org; Wed, 03 Dec 2008 16:28:17 +0100
Received: by nf-out-0910.google.com with SMTP id g13so2121289nfb.11
	for <linux-dvb@linuxtv.org>; Wed, 03 Dec 2008 07:28:13 -0800 (PST)
Message-ID: <412bdbff0812030728q5f5853fap3f569604ecdac557@mail.gmail.com>
Date: Wed, 3 Dec 2008 10:28:13 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "BOUWSMA Barry" <freebeer.bouwsma@gmail.com>
In-Reply-To: <alpine.DEB.2.00.0812031223490.9198@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Content-Disposition: inline
References: <412bdbff0812021455n221ee909nba6c7e546f1a0650@mail.gmail.com>
	<alpine.DEB.2.00.0812030110260.9198@ybpnyubfg.ybpnyqbznva>
	<500D461448%linux@youmustbejoking.demon.co.uk>
	<alpine.DEB.2.00.0812031223490.9198@ybpnyubfg.ybpnyqbznva>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Pinnacle 80e support: not going to happen...
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Thanks to everyone for their support, and of course to Barry for
several incoherent multi-page rants.  :-)

A couple of things worth clarifying based on people's comments:

In all fairness to Micronas, the people who provided the datasheets
and reference driver source were unaware of the Micronas corporate
position.  They claim to have been surprised as I was when the lawyers
and management came back and denied the request, and I have no reason
not to believe them.  That said, I wish that had happened about six
weeks earlier instead of being reassured "Your ongoing efforts will
not be lost, so please proceed."

If there was any confusion regarding my intentions, I will not be
releasing a binary driver for this device.  I couldn't legally do it
even if I wanted to (but rest assured, I don't), since it would
require me to include GPL'd headers.

On that note, maybe some developers who hold linux-dvb copyrights
should reach out and have a conversation with Asus, since they seem to
be shipping a binary drx-j and dib0700 driver with the eeePC, and I
can't imagine any way they could be doing this without violating the
GPL.

Regarding Markus's video player, I wish him well in his effort, but I
cannot imagine any open source developers wanting to use an SDK to
hook into his commercial, closed source video player application that
is locked down to only work with Empia based devices.

As to which products are affected, I don't have a list but in terms of
the drx-j, the only products I know of are the Pinnacle 80e and the
Asus U3100.  In terms of the drx-k and drx-d, I don't really keep
track of DVB products since I'm in the US, but I'm sure a google
search will tell people (and feel free to update the linux-dvb wiki).
If you're in the US market looking for an USB based device, just stick
with the fourteen devices in the wiki that are currently supported.

On the upside, thanks to Pinnacle and Empia, we now have full support
for the em2874 in the mainline as well as a bunch of other fixes and
cleanup of the in-kernel em28xx driver.  So the next em2874 based
device that comes along should be trivial to add support for (and if
it doesn't "just work", email me and I will *make* it work)...

Obviously this whole situation has taken it's toll on me personally,
so I'm going to take a break from linux-dvb for a while.  Perhaps I'll
do some work on Kaffeine....

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
