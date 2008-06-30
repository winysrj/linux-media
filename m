Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mxb.rambler.ru ([81.19.66.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nemashinist@rambler.ru>) id 1KDMcF-0006qw-7g
	for linux-dvb@linuxtv.org; Mon, 30 Jun 2008 18:52:36 +0200
Received: from maild.rambler.ru (maild.rambler.ru [81.19.66.33])
	by mxb.rambler.ru (Postfix) with ESMTP id B1A001BEE3B
	for <linux-dvb@linuxtv.org>; Mon, 30 Jun 2008 20:52:31 +0400 (MSD)
Received: from [10.200.102.204] (unknown [83.149.40.42])
	(Authenticated sender: nemashinist@rambler.ru)
	by maild.rambler.ru (Postfix) with ESMTP id CDF8C84486
	for <linux-dvb@linuxtv.org>; Mon, 30 Jun 2008 20:52:27 +0400 (MSD)
Message-ID: <48690F5E.40103@rambler.ru>
Date: Mon, 30 Jun 2008 20:52:46 +0400
From: amaora <nemashinist@rambler.ru>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Small patch for szap (from
	linuxtv-dvb-apps-1.1.1.tar.gz)
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

Hi,

I modified szap for change of a line output frequency. You could not 
include change in yours CVS/Mercurial/Downloads? It is necessary for 
szapfe (http://szapfe.sourceforge.net/), changes not greater,

69a70
 > static int refresh_rate = 1000;
87c88,89
<     "                 or -n numbers for zapping\n";
---
 >     "                 or -n numbers for zapping\n"
 >     "     -t number : refresh rate in msec (default 1000)\n";
197a200
 >    struct timeval t0, t1;
223c226,234
<       usleep(1000000);
---
 >     gettimeofday( &t0, NULL );
 >     gettimeofday( &t1, NULL );
 >     while ( abs( ( t1.tv_usec + t1.tv_sec * 1000000 ) -
 >         ( t0.tv_usec + t0.tv_sec * 1000000 ) ) < refresh_rate * 1000 )
 >     {
 >         usleep( 1000 );
 >         gettimeofday( &t1, NULL );
 >     }
 >
482c493
<    while ((opt = getopt(argc, argv, "hqrn:a:f:d:c:l:xi")) != -1) {
---
 >    while ((opt = getopt(argc, argv, "hqrn:a:f:d:c:l:xit:")) != -1) {
522a534,540
 >         break;
 >      case 't':
 >         refresh_rate = ( int ) strtoul( optarg, NULL, 0 );
 >         if ( refresh_rate <= 0 )
 >             refresh_rate = 1;
 >         break;
 >

Though I still doubt of necessity of this my software. Excuse for bad 
English. In advance thanks.

Regards,
amaora

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
