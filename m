Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LImPK-0004BL-Ux
	for linux-dvb@linuxtv.org; Fri, 02 Jan 2009 16:57:56 +0100
Received: by ey-out-2122.google.com with SMTP id 25so651056eya.17
	for <linux-dvb@linuxtv.org>; Fri, 02 Jan 2009 07:57:51 -0800 (PST)
Date: Fri, 2 Jan 2009 16:57:22 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Nico Sabbi <nicola.sabbi@poste.it>
In-Reply-To: <1230892173.3791.12.camel@linux-wcrt.site>
Message-ID: <alpine.DEB.2.00.0901021305300.32128@ybpnyubfg.ybpnyqbznva>
References: <ecc841d80901011033s58b2fecawd3dd2d42c1b09cd7@mail.gmail.com>
	<alpine.DEB.2.00.0901021055060.32128@ybpnyubfg.ybpnyqbznva>
	<1230891602.3791.4.camel@linux-wcrt.site>
	<1230892173.3791.12.camel@linux-wcrt.site>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvbsream v0-5 and -n switch
Reply-To: Barry Bouwsma <free_beer_for_all@yahoo.com>
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

On Fri, 2 Jan 2009, Nico Sabbi wrote:

> > can you post a patch against latest cvs, please?

It will be some time, as I will need to figure which bugfixes
are already there, and whether custom added features are
already included, or will apply painlessly...  Plus, Real
Life has the habit of rearing its ugly head too often and
taking my time from better things.

For starters, so I don't waste my time, I've hacked the
code from 2005 to...
* permit extending the recording by SIGHUP (in case the
  supplied value is incorrect, the program overruns or
  starts late, or something)
* allow the user to specify that the program terminates
  immediately in case of problems such as inability to
  open the specified output file
* for writing to a specified file, directs normal messages
  to stdout and errors to stderr -- allows me to call the
  program >/dev/null from a script from `cron' and only
  receive mail in case of errors that I could correct
* what seem to be a few compiler quietings
* RTP MPA audio hacks that may not work
* probably checks that nothing else has the device open
  to prevent interfering with anything else
* other fixes that certainly aren't needed now (dev/ost)

In case any of the above are undesired by anyone save
myself, I won't bother creating those particular diffs



> BTW, for years I asked to insert the correct "reply-to" header in this
> *fuckingly broken* mailing list (to send replies to the list rather than
> to the poster), but not a single time I received an answer by His
> Majesty the ML administrator.

That's the wrong header.  See my headers.  Reply-To: should
be a user-supplied header, as I've often used when sending
mail from one account but receiving it elsewhere.

A better header to use would be Mail-Followup-To: or
Mail-Reply-To: , so that, should I start using a dyndns
domain again, I can still receive personal replies.

Anyway, I default to replying to all recipients, and trim
the list if I think personal mail would be better, or the
individual recipient(s) if it's not directed at them, the
Reply-To: if I don't want to use that redirection...  But
my mailer is clear about this, and handles the different
reply-type headers properly, yet allowing me flexibility
to take things off-list as appropriate

bazza bouwzma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
