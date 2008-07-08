Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n61.bullet.mail.sp1.yahoo.com ([98.136.44.37])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KGEov-0004UY-8t
	for linux-dvb@linuxtv.org; Tue, 08 Jul 2008 17:09:34 +0200
Date: Tue, 8 Jul 2008 08:08:50 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: linux-dvb@linuxtv.org, Mark Fraser <linuxtv@mfraz74.orangehome.co.uk>
In-Reply-To: <200807081130.38188.linuxtv@mfraz74.orangehome.co.uk>
MIME-Version: 1.0
Message-ID: <162160.58094.qm@web46116.mail.sp1.yahoo.com>
Subject: Re: [linux-dvb] Kaffeine 0.8.7 released
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

--- On Tue, 7/8/08, Mark Fraser <linuxtv@mfraz74.orangehome.co.uk> wrote:

> > > I would also like to have some easy way of
> sorting the channels and
> > > support for the FreeSat EPG.

> > Isn't FreeSat EPG standard epg ?

> Don't think so, all I get at the moment with Kaffeine
> is Now/Next information.

Correct.  On the standard EIT PID (18/0x12) you only receive this.
And at the moment, the FTA Channel 4 has neither this nor a proper
channel name on the usual PIDs.  For Radio, you only get Now info.

There is a completely different set of PIDs with corrrect EIT,
NIT, TDT, etc. info from PID 3101 upwards as follows, in order
not to interfere with the BSkyB data or that sent on the standard
PIDS:
PID 3101 -- NIT
PID 3102 -- SDT/BAT
PID 3103 -- EIT
PID 3104 -- ?
PID 3105 -- TDT/TOT, and this is accurate, no less
(info from `dvbsnoop')

In addition to the non-standard PID of 3103, the data is usually
sent in compressed format for the title/description (occasionally
the data is uncompressed where there is no savings to compress,
such as a title of `News').

The full EIT is sent on one specific transponder, while the tuned
transponder will deliver a partial EIT (but more than now/next)
as above across the entire Freesat family, much like the standard
PIDs EIT info from the german ARD family includes all their
channels over several transponders for seven days.

Code to handle (at least some) decompression of the non-standard
EIT data has been added to, I believe, MythTV (can't check now
as I'm not online and not sure where to look in my code repository,
as that SCS appears to require online access to retrieve logs),
based on reverse-engineering.  The EPG data is *not* scrambled,
regardless of what others have written, but the spec is presently
not available publicly, and so the tables in the reverse-engineered
code may not be complete.



barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
