Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KZRU0-0002to-Qu
	for linux-dvb@linuxtv.org; Sat, 30 Aug 2008 16:31:23 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6F001RB4B98ML0@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sat, 30 Aug 2008 10:30:45 -0400 (EDT)
Date: Sat, 30 Aug 2008 10:30:45 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <000a01c90a55$62da6e70$288f4b50$@com.au>
To: Thomas Goerke <tom@goeng.com.au>
Message-id: <48B95995.4070206@linuxtv.org>
MIME-version: 1.0
References: <20080830012407.BCB0247808F@ws1-5.us4.outblaze.com>
	<000901c90a51$72e44100$58acc300$@com.au>
	<000a01c90a55$62da6e70$288f4b50$@com.au>
Cc: linux-dvb@linuxtv.org, stev391@email.com
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

Thomas Goerke wrote:
>> Stephen,
>>
>> I downloaded latest version of v4l-dvb (30/08/08:11:30am WST), applied
>> patch
>> (which passed) and then tried a make.  This is the output:
>>
>> -- snip --
>> include/asm/io_32.h: In function 'memcpy_fromio':
>> include/asm/io_32.h:211: warning: passing argument 2 of '__memcpy'
>> discards
>> qualifiers from pointer target type
>>   CC [M]  /home/tom/source/v4l-dvb/v4l/stradis.o
>>   CC [M]  /home/tom/source/v4l-dvb/v4l/cpia.o
>> /home/tom/source/v4l-dvb/v4l/cpia.c: In function 'cpia_open':
>> /home/tom/source/v4l-dvb/v4l/cpia.c:3205: error: implicit declaration
>> of
>> function 'current_uid'
>> make[3]: *** [/home/tom/source/v4l-dvb/v4l/cpia.o] Error 1
>> make[2]: *** [_module_/home/tom/source/v4l-dvb/v4l] Error 2
>> make[2]: Leaving directory `/usr/src/linux-headers-2.6.24-19-generic'
>> make[1]: *** [default] Error 2
>> make[1]: Leaving directory `/home/tom/source/v4l-dvb/v4l'
>> make: *** [all] Error 2
>>
>> I then tried make clean, make and the same error occurred.
>>
>> Tom
>>
> Stephen,
> It seems that the latest source is at fault:
> This:
> hg clone http://linuxtv.org/hg/v4l-dvb
> cd v4l-dvb
> make
> Produces:
> -- snip ---
> include/asm/io_32.h: In function 'memcpy_fromio':
> include/asm/io_32.h:211: warning: passing argument 2 of '__memcpy' discards
> qualifiers from pointer target type
>   CC [M]  /home/tom/source/v4l-dvb/v4l/stradis.o
>   CC [M]  /home/tom/source/v4l-dvb/v4l/cpia.o
> /home/tom/source/v4l-dvb/v4l/cpia.c: In function 'cpia_open':
> /home/tom/source/v4l-dvb/v4l/cpia.c:3205: error: implicit declaration of
> function 'current_uid'
> make[3]: *** [/home/tom/source/v4l-dvb/v4l/cpia.o] Error 1
> make[2]: *** [_module_/home/tom/source/v4l-dvb/v4l] Error 2
> make[2]: Leaving directory `/usr/src/linux-headers-2.6.24-19-generic'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/home/tom/source/v4l-dvb/v4l'
> make: *** [all] Error 2
> 
> Let me know if you have a separate archive of the source tree that I can use
> to test, or alternatively let me know if I have done something wrong with
> the clone and make.

CPIA is broken

# make menuconfig

(disable the CPIA+CPIA2 moduoes)

Exit, save,

then make.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
