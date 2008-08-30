Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KZYcj-0006Rc-Ns
	for linux-dvb@linuxtv.org; Sun, 31 Aug 2008 00:08:51 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	5A7E21800FDE
	for <linux-dvb@linuxtv.org>; Sat, 30 Aug 2008 22:08:14 +0000 (GMT)
Content-Disposition: inline
MIME-Version: 1.0
From: stev391@email.com
To: "Thomas Goerke" <tom@goeng.com.au>
Date: Sun, 31 Aug 2008 08:08:14 +1000
Message-Id: <20080830220814.5F194BE4078@ws1-9.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and analog
 TV/FM capture card
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
> From: "Steven Toth" <stoth@linuxtv.org>
> To: "Thomas Goerke" <tom@goeng.com.au>
> Subject: Re: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and analog TV/FM capture card
> Date: Sat, 30 Aug 2008 10:30:45 -0400
> 
> 
> Thomas Goerke wrote:
> >> Stephen,
> >>
> >> I downloaded latest version of v4l-dvb (30/08/08:11:30am WST), applied
> >> patch
> >> (which passed) and then tried a make.  This is the output:
> >>
> >> -- snip --
> >> include/asm/io_32.h: In function 'memcpy_fromio':
> >> include/asm/io_32.h:211: warning: passing argument 2 of '__memcpy'
> >> discards
> >> qualifiers from pointer target type
> >>   CC [M]  /home/tom/source/v4l-dvb/v4l/stradis.o
> >>   CC [M]  /home/tom/source/v4l-dvb/v4l/cpia.o
> >> /home/tom/source/v4l-dvb/v4l/cpia.c: In function 'cpia_open':
> >> /home/tom/source/v4l-dvb/v4l/cpia.c:3205: error: implicit declaration
> >> of
> >> function 'current_uid'
> >> make[3]: *** [/home/tom/source/v4l-dvb/v4l/cpia.o] Error 1
> >> make[2]: *** [_module_/home/tom/source/v4l-dvb/v4l] Error 2
> >> make[2]: Leaving directory `/usr/src/linux-headers-2.6.24-19-generic'
> >> make[1]: *** [default] Error 2
> >> make[1]: Leaving directory `/home/tom/source/v4l-dvb/v4l'
> >> make: *** [all] Error 2
> >>
> >> I then tried make clean, make and the same error occurred.
> >>
> >> Tom
> >>
> > Stephen,
> > It seems that the latest source is at fault:
> > This:
> > hg clone http://linuxtv.org/hg/v4l-dvb
> > cd v4l-dvb
> > make
> > Produces:
> > -- snip ---
> > include/asm/io_32.h: In function 'memcpy_fromio':
> > include/asm/io_32.h:211: warning: passing argument 2 of '__memcpy' discards
> > qualifiers from pointer target type
> >   CC [M]  /home/tom/source/v4l-dvb/v4l/stradis.o
> >   CC [M]  /home/tom/source/v4l-dvb/v4l/cpia.o
> > /home/tom/source/v4l-dvb/v4l/cpia.c: In function 'cpia_open':
> > /home/tom/source/v4l-dvb/v4l/cpia.c:3205: error: implicit declaration of
> > function 'current_uid'
> > make[3]: *** [/home/tom/source/v4l-dvb/v4l/cpia.o] Error 1
> > make[2]: *** [_module_/home/tom/source/v4l-dvb/v4l] Error 2
> > make[2]: Leaving directory `/usr/src/linux-headers-2.6.24-19-generic'
> > make[1]: *** [default] Error 2
> > make[1]: Leaving directory `/home/tom/source/v4l-dvb/v4l'
> > make: *** [all] Error 2
> >
> > Let me know if you have a separate archive of the source tree that I can use
> > to test, or alternatively let me know if I have done something wrong with
> > the clone and make.
> 
> CPIA is broken
> 
> # make menuconfig
> 
> (disable the CPIA+CPIA2 moduoes)
> 
> Exit, save,
> 
> then make.

Tom,

As a secondary option to Steve's email you can also try the previously downloaded cx23885-leadtek tree, the cx23885 driver will behave the same as it was recently merged into the main tree. (Make sure it is not the copy that the original patch was applied to).  However I do recommend trying to get the main tree working first.

I just updated my main tree and it compiled ok (Ubuntu Hardy Heron, kernel: 2.6.24-19-generic)

Regards,
Stephen.


-- 
Nothing says Labor Day like 500hp of American muscle
Visit OnCars.com today.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
