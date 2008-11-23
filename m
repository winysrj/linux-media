Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtpd4.aruba.it ([62.149.128.209] helo=smtp6.aruba.it)
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <a.venturi@avalpa.com>) id 1L4AzJ-0005br-0T
	for linux-dvb@linuxtv.org; Sun, 23 Nov 2008 10:10:42 +0100
Message-ID: <49292BD0.9070501@avalpa.com>
Date: Sun, 23 Nov 2008 11:09:20 +0100
From: Andrea Venturi <a.venturi@avalpa.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <101205.71076.qm@web38802.mail.mud.yahoo.com>
In-Reply-To: <101205.71076.qm@web38802.mail.mud.yahoo.com>
Subject: Re: [linux-dvb] [PATCH 1/2] Siano's SMS subsystems API - SmsHost
 support
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

Uri Shkolnik wrote:
> Hi Andrea,
>
> In order to use T-DMB you need FIB parser to start with. Do you have such parser? Later on you'll need service and components manager and some other stuff as well.
>   

hi, i didn't get that for T-DMB to be decoded you need to parse some
other data structure.. maybe it's because the TS mux is piggybacked on a
DAM mux scheme..

i suppose i need to download and read the relevant standards both for
DAB and DMB like TS 102 427 and TS 102 428

anyway with regard some stuff about FIC decoding, there's already some
source code to peruse and borrow, like this gnuradio software DAB receiver:

http://people.ee.ethz.ch/~andrmuel/files/gnuradio/dab-doc/thesis.pdf
http://people.ee.ethz.ch/~andrmuel/files/gnuradio/gr-dab.tgz

maybe it's a good starting point..

> Maybe I can provide you with user-space C library (binary, not source code) that does that and many other T-DMB tasks, if you'll provide me with you system characteristics.
>   

having a reference implementation, albeit binary, could be also another
interesting starting point. thank you for the offering..

we run this stuff on x86 32 bit debian distro.. if you are so kind to
provide some binary tools..

thank you again

andrea
>
> Regards,
>
> Uri
>
>
>       
>
>   



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
