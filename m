Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n62.bullet.mail.sp1.yahoo.com ([98.136.44.35])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KbE5r-00066u-3z
	for linux-dvb@linuxtv.org; Thu, 04 Sep 2008 14:37:48 +0200
Date: Thu, 4 Sep 2008 05:36:07 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: linux-dvb@linuxtv.org, Roger James <roger@beardandsandals.co.uk>
In-Reply-To: <48BFBE68.7070707@beardandsandals.co.uk>
MIME-Version: 1.0
Message-ID: <619958.57053.qm@web46102.mail.sp1.yahoo.com>
Subject: Re: [linux-dvb] S2API - First release
Reply-To: free_beer_for_all@yahoo.com
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

--- On Thu, 9/4/08, Roger James <roger@beardandsandals.co.uk> wrote:

>  The services I use (BSkyB and
> Freesat) are mostly DVB-S with very little if any S2.

Howdy,

Just to clarify things, in fact, BSkyB is indeed making rather
heavy use of DVB-S2, with -- based on what I've read and results
of previous `scan's (as I have no DVB-S2-capable tuner), two more
transponders recently or about to switch from DVB-S to DVB-S2.

If I am to trust my manually-added notes to my frequency list,
that is bringing the number of DVB-S2 transponders at 28E to
almost ten, more or less.

However, as I understand it, the specs from Freesat for the SD
receivers do not include DVB-S2 ability (or is it H.264, or both?)
and Sky SD receivers also do not support this (nor dynamic PMT,
thus the need for umpteen regional variants of ITV1 and BBC1
and not-so-many C4/+1) and as a result, pretty much lock the
broadcasters into a far less efficient use of the scarce spectrum
for the near future.

The existing HDTV Freesat/FTA services are H.264 over DVB-S, but
all Freesat-HD receivers will need to tune DVB-S2, and it is
likely that BBC-HD will in the not-terribly-distant future be
using a DVB-S2 transponder.  Likewise ITV-HD, C4HD when it makes
it to Freesat, and all the regular channels that get HD versions.

BSkyB actually makes the most use of DVB-S2 for DTH satellite in
europe that I am aware of, but these services are pretty much
exclusively subscription services.


I agree that due to compatibility with SD services, DVB-S reception
will be a necessity for quite some time to come in many markets.


barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
