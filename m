Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 203.161.84.42.static.amnet.net.au ([203.161.84.42]
	helo=goeng.com.au) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tom@goeng.com.au>) id 1KZHEq-0000j4-Da
	for linux-dvb@linuxtv.org; Sat, 30 Aug 2008 05:35:01 +0200
From: "Thomas Goerke" <tom@goeng.com.au>
To: stev391@email.com, "'jackden'" <jackden@gmail.com>
References: <20080830012407.BCB0247808F@ws1-5.us4.outblaze.com>
In-Reply-To: <20080830012407.BCB0247808F@ws1-5.us4.outblaze.com>
Date: Sat, 30 Aug 2008 11:35:23 +0800
Message-ID: <000901c90a51$72e44100$58acc300$@com.au>
MIME-Version: 1.0
Content-Language: en-au
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

> Tom,
> (Jackden please try first patch and provide feedback, if that doesn't
> work for your card, then try this and provide feedback)
> 
> The second dmesg (with debugging) didn't show me what I was looking
> for, but from past experience I will try something else.  I was looking
> for some dma errors from the cx23885 driver, these usually occured
> while streaming is being attempted.
> 
> Attached to this email is another patch.  The difference between the
> first one and the second one is that I load an extra module (cx25840),
> which normally is not required for DVB as it is part of the analog side
> of this card.  This does NOT mean analog will be supported.
> 
> As of today the main v4l-dvb can be used with this patch and this means
> that the cx23885-leadtek tree will soon disappear. So step 2 above has
> been modified to: "Check out the latest v4l-dvb source".
> 
> Other then that step 4 has a different file name for the patch.
> 
> Steps that need to be completed are: 2, 3, 4, 5, 7, 9, 10 & 11. (As you
> have completed the missing steps already).
> 
> If the patch works, please do not stop communicating, as I have to
> perform one more patch to prove that cx25840 is required and my
> assumptions are correct. Once this is completed I will send it to
> Steven Toth for inclusion in his test tree. This will need to be tested
> by you again, and if all is working well after a week or more it will
> be included into the main tree.
> 
> Regards,
> Stephen
> 
> 
> --
> Nothing says Labor Day like 500hp of American muscle Visit OnCars.com
> today.
Stephen,

I downloaded latest version of v4l-dvb (30/08/08:11:30am WST), applied patch
(which passed) and then tried a make.  This is the output:

-- snip --
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:211: warning: passing argument 2 of '__memcpy' discards
qualifiers from pointer target type
  CC [M]  /home/tom/source/v4l-dvb/v4l/stradis.o
  CC [M]  /home/tom/source/v4l-dvb/v4l/cpia.o
/home/tom/source/v4l-dvb/v4l/cpia.c: In function 'cpia_open':
/home/tom/source/v4l-dvb/v4l/cpia.c:3205: error: implicit declaration of
function 'current_uid'
make[3]: *** [/home/tom/source/v4l-dvb/v4l/cpia.o] Error 1
make[2]: *** [_module_/home/tom/source/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.24-19-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/tom/source/v4l-dvb/v4l'
make: *** [all] Error 2

I then tried make clean, make and the same error occurred.

Tom


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
