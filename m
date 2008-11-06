Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <guzowskip@linuxmail.org>) id 1Ky3RF-0003ap-8X
	for linux-dvb@linuxtv.org; Thu, 06 Nov 2008 12:54:14 +0100
Received: from wfilter.us4.outblaze.com.int (wfilter.us4.outblaze.com.int
	[192.168.9.180])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	3287E18001B9
	for <linux-dvb@linuxtv.org>; Thu,  6 Nov 2008 11:54:08 +0000 (GMT)
Content-Disposition: inline
MIME-Version: 1.0
From: "Paul Guzowski" <guzowskip@linuxmail.org>
To: "Michael Krufky" <mkrufky@linuxtv.org>
Date: Thu, 6 Nov 2008 05:54:08 -0600
Message-Id: <20081106115408.244CFCBBCF@ws5-11.us4.outblaze.com>
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

Thanks, Mike.  I'll give wscan a try as you suggested.

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
Free Hypnotic spiral, Test and Scripts
Custom & 1000+ premade recordings. Guaranteed. Since 1981. Catalog.
http://a8-asy.a8ww.net/a8-ads/adftrclick?redirectid=ea7146089d3a6fcf063122ca2ae816ee


-- 
Powered by Outblaze

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
