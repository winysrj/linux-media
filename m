Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <guzowskip@linuxmail.org>) id 1KyRxg-0002it-1t
	for linux-dvb@linuxtv.org; Fri, 07 Nov 2008 15:05:23 +0100
Received: from wfilter.us4.outblaze.com.int (wfilter.us4.outblaze.com.int
	[192.168.9.180])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	83F3018001D4
	for <linux-dvb@linuxtv.org>; Fri,  7 Nov 2008 14:05:13 +0000 (GMT)
Content-Disposition: inline
MIME-Version: 1.0
From: "Paul Guzowski" <guzowskip@linuxmail.org>
To: "Michael Krufky" <mkrufky@linuxtv.org>
Date: Fri, 7 Nov 2008 08:05:13 -0600
Message-Id: <20081107140513.4DCE87BD53@ws5-10.us4.outblaze.com>
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

Greetings Mike,

I tried your suggestion and didn't have any success.  I know there are cable signals coming over the line because two other TVs in the house (one analog and one HDTV-capable) can tune channels.  If I connect to the RF-out from the digital set-top box, I can use mplayer tuned to channel 3 to watch TV but I'd like to be able to tune from the cable directly. Not sure what to try next.  Here's the results of my test:

paul@Kris-desktop:/media/Data/Computer/Downloads/Linux/Multimedia/w_scan-20080815$ w_scan -a0 -X > channels.conf
w_scan version 20080105
-_-_-_-_ Getting frontend capabilities-_-_-_-_ 
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_ 
ERROR: Sorry - i couldn't get any working frequency/transponder
 Nothing to scan!!
dumping lists (0 services)
Done.
paul@Kris-desktop:/media/Data/Computer/Downloads/Linux/Multimedia/w_scan-20080815$ 

Paul in NW Florida
> ----- Original Message -----
> From: "Michael Krufky" <mkrufky@linuxtv.org>
> To: "Paul Guzowski" <guzowskip@linuxmail.org>
> Cc: linux-dvb@linuxtv.org
> Subject: Re: [linux-dvb] Channel configuration files....
> Date: Wed, 5 Nov 2008 11:41:27 -0500
> 
> 
> On Wed, Nov 5, 2008 at 6:58 AM, Paul Guzowski <guzowskip@linuxmail.org> wrote:
> > Greetings,
> >
> > Does anyone on this list have a sample channel.conf file for 
> > Brighthouse Networks cable or can anyone give enough information 
> > (frequencies, transponders, etc) so that I can try to build one?  
> > Thanks in advance.
> >
> > Paul in NW Florida
> 
> Paul,
> 
> You can use "scan" from dvb-apps, using the scan file,
> "us-Cable-Standard-center-frequencies-QAM256" ...  If that doesn't
> work, you can try the other QAM256 cable scan files, located in the
> util/scan/atsc/ directory of dvb-apps.
> 
> Alternatively, you can use the latest version of w_scan WITHOUT any
> scan file.  This should produce the best results.
> 
> The latest version of w_scan with atsc / qam scanning support can be
> downloaded from here:
> 
> http://wirbel.htpc-forum.de/w_scan/w_scan-20080815.tar.bz2
> 
> You can scan cable using this command:
> 
> w_scan -A2 -X > channels.conf
> 
> Good luck.
> 
> -Mike Krufky

>


=
anti-aging hgh
Free 30-day HGH samples - Just $9.95 S&H - 25K customers since 1998.
http://a8-asy.a8ww.net/a8-ads/adftrclick?redirectid=617751771c3cb4b0b58b26b00f4d8b09


-- 
Powered by Outblaze

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
