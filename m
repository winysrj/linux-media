Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <guzowskip@linuxmail.org>) id 1KyXRN-00046l-Tj
	for linux-dvb@linuxtv.org; Fri, 07 Nov 2008 20:56:24 +0100
Received: from wfilter.us4.outblaze.com.int (wfilter.us4.outblaze.com.int
	[192.168.9.180])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	79F44180020C
	for <linux-dvb@linuxtv.org>; Fri,  7 Nov 2008 19:56:16 +0000 (GMT)
Content-Disposition: inline
MIME-Version: 1.0
From: "Paul Guzowski" <guzowskip@linuxmail.org>
To: "Michael Krufky" <mkrufky@linuxtv.org>
Date: Fri, 7 Nov 2008 13:56:16 -0600
Message-Id: <20081107195616.65673233EB@ws5-3.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Channel configuration files....
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


> ----- Original Message -----
> From: "Michael Krufky" <mkrufky@linuxtv.org>
> To: "Paul Guzowski" <guzowskip@linuxmail.org>
> Cc: linux-dvb@linuxtv.org
> Subject: Re: [linux-dvb] Channel configuration files....
> Date: Fri, 7 Nov 2008 12:23:05 -0500
> 
> 
> On Fri, Nov 7, 2008 at 12:21 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> > Paul -- please see my response below.
> >
> >> Paul in NW Florida
> >>> ----- Original Message -----
> >>> From: "Michael Krufky" <mkrufky@linuxtv.org>
> >>> To: "Paul Guzowski" <guzowskip@linuxmail.org>
> >>> Cc: linux-dvb@linuxtv.org
> >>> Subject: Re: [linux-dvb] Channel configuration files....
> >>> Date: Wed, 5 Nov 2008 11:41:27 -0500
> >>>
> >>>
> >>> On Wed, Nov 5, 2008 at 6:58 AM, Paul Guzowski 
> >>> <guzowskip@linuxmail.org> wrote:
> >>> > Greetings,
> >>> >
> >>> > Does anyone on this list have a sample channel.conf file for
> >>> > Brighthouse Networks cable or can anyone give enough information
> >>> > (frequencies, transponders, etc) so that I can try to build one?
> >>> > Thanks in advance.
> >>> >
> >>> > Paul in NW Florida
> >>>
> >>> Paul,
> >>>
> >>> You can use "scan" from dvb-apps, using the scan file,
> >>> "us-Cable-Standard-center-frequencies-QAM256" ...  If that doesn't
> >>> work, you can try the other QAM256 cable scan files, located in the
> >>> util/scan/atsc/ directory of dvb-apps.
> >>>
> >>> Alternatively, you can use the latest version of w_scan WITHOUT any
> >>> scan file.  This should produce the best results.
> >>>
> >>> The latest version of w_scan with atsc / qam scanning support can be
> >>> downloaded from here:
> >>>
> >>> http://wirbel.htpc-forum.de/w_scan/w_scan-20080815.tar.bz2
> >>>
> >>> You can scan cable using this command:
> >>>
> >>> w_scan -A2 -X > channels.conf
> >>>
> >>> Good luck.
> >>>
> >>> -Mike Krufky
> >
> >
> > On Fri, Nov 7, 2008 at 9:05 AM, Paul Guzowski 
> > <guzowskip@linuxmail.org> wrote:
> >> Greetings Mike,
> >>
> >> I tried your suggestion and didn't have any success.  I know 
> >> there are cable signals coming over the line because two other 
> >> TVs in the house (one analog and one HDTV-capable) can tune 
> >> channels.  If I connect to the RF-out from the digital set-top 
> >> box, I can use mplayer tuned to channel 3 to watch TV but I'd 
> >> like to be able to tune from the cable directly. Not sure what 
> >> to try next.  Here's the results of my test:
> >>
> >> paul@Kris-desktop:/media/Data/Computer/Downloads/Linux/Multimedia/w_scan-20080815$ w_scan -a0 -X > 
> >> channels.conf
> >> w_scan version 20080105
> >> -_-_-_-_ Getting frontend capabilities-_-_-_-_
> >> -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
> >> ERROR: Sorry - i couldn't get any working frequency/transponder
> >>  Nothing to scan!!
> >> dumping lists (0 services)
> >> Done.
> >> paul@Kris-desktop:/media/Data/Computer/Downloads/Linux/Multimedia/w_scan-20080815$
> >>
> >
> >
> > Paul,
> >
> > The policy of this mailing list, and almost all linux mailing lists,
> > is to enter your replies BELOW the quoted text.  Do not top-post.
> >
> > Please notice above, that I instructed you to pass " -A2 -X " into the
> > w_scan command line.  You passed " -a0 -X " ..  The -a? and -A? are
> > two entirely different command line switches.  If you're trying to
> > scan QAM, then you must pass -A2
> >
> > -Mike
> >
> 
> Also,  do NOT use the rf out from the cablebox -- you wont get any
> digital services that way.  You must use the cable feed coming in
> directly from the wall / street.
> 
> -Mike

Mike,

I failed to say in the prior note that I had already tried your suggested command.  Here's the result:

paul@Kris-desktop:~/Desktop$ w_scan -A2 -X > channels.conf
w_scan: invalid option -- 'A'

usage: w_scan [options...] 
	-a N	use device /dev/dvb/adapterN/ [default: auto detect]
	-f type	frontend type
		What programs do you want to search for?
		c = cable
		t = terrestrian [default]
	-i N	spectral inversion setting for cable TV
		DVB-T: always off
		DVB-C (0: off, 1: on, 2: auto [default])
	-F	use long filter timeout
	-t N	tuning timeout
		1 = fastest [default]
		2 = medium
		3 = slowest
	-k	generate channels.dvb for kaffeine
	-o N	VDR version / channels.conf format
		2 = VDR-1.2.x (depriciated)
		3 = VDR-1.3.x (depriciated)
		4 = VDR-1.4.x/VDR-1.5.x (default)
	-R N	radio channels
		0 = don't search radio channels
		1 = search radio channels [default]
	-T N	TV channels
		0 = don't search TV channels
		1 = search radio TV [default]
	-O N	Other Services
		0 = don't search other services [default]
		1 = search other services
	-E N	Conditional Access (encrypted channels)
		N=0 gets only Free TV channels
		N=1 search also encrypted channels [default]
	-X	tzap/czap/xine output instead of vdr channels.conf
	-x	generate initial tuning data for (dvb-)scan
	-v 	verbose (repeat for more)
	-q 	quiet   (repeat for less)
paul@Kris-desktop:~/Desktop$ 

Paul



>


=
Time Tracking System
Unitime Automated Time Keeping System for sale at Aphotoid.com. We also provide ID card systems and accessories, ID badging software, PVC card printers and more. Contact us today.
http://a8-asy.a8ww.net/a8-ads/adftrclick?redirectid=47f2e344d8d6292519d87ad047e2c1d3


-- 
Powered by Outblaze

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
