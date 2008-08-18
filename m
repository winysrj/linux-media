Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7IMF8cH001433
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 18:15:08 -0400
Received: from web34507.mail.mud.yahoo.com (web34507.mail.mud.yahoo.com
	[66.163.178.173])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m7IMEuKw028181
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 18:14:56 -0400
Date: Mon, 18 Aug 2008 15:14:51 -0700 (PDT)
From: Carlos Limarino <climarino@yahoo.com.ar>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <85083.26186.qm@web34507.mail.mud.yahoo.com>
Content-Transfer-Encoding: 8bit
Subject: Progress with Compro VideoMate X50 (xc2038)
Reply-To: climarino@yahoo.com.ar
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello,

I'm trying to add that card in CX88. I added the corresponding GPIO for VMUX0 (television, I didn't test S-Video), the driver loads OK and I have video (PAL-N, but it doesn't work correct, the image is black & white). I suspect there is a problem related with the tuner. The module output is this:

tuner' 2-0061: chip found @ 0xc2 (cx88[0])
xc2028 2-0061: creating new instance
xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27.fw
firmware: requesting xc3028-v27.fw
xc2028 2-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
xc2028 2-0061: Loading firmware for type=(0), id 000000000000b700.
xc2028 2-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
xc2028 2-0061: Loading firmware for type=(0), id 000000000000b700.
xc2028 2-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.

And if I unload the modules and reload them immediately, I get this:

tuner' 2-0061: chip found @ 0xc2 (cx88[0])
xc2028 2-0061: creating new instance
xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27.fw
firmware: requesting xc3028-v27.fw
xc2028 2-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
xc2028 2-0061: i2c output error: rc = -5 (should be 64)
xc2028 2-0061: -5 returned from send
xc2028 2-0061: Error -22 while loading base firmware
xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
xc2028 2-0061: i2c output error: rc = -5 (should be 64)
xc2028 2-0061: -5 returned from send
xc2028 2-0061: Error -22 while loading base firmware
xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
xc2028 2-0061: i2c output error: rc = -5 (should be 64)
xc2028 2-0061: -5 returned from send
xc2028 2-0061: Error -22 while loading base firmware
xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
xc2028 2-0061: i2c output error: rc = -5 (should be 64)
xc2028 2-0061: -5 returned from send
xc2028 2-0061: Error -22 while loading base firmware
xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
xc2028 2-0061: i2c output error: rc = -5 (should be 64)
xc2028 2-0061: -5 returned from send
xc2028 2-0061: Error -22 while loading base firmware
xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
xc2028 2-0061: i2c output error: rc = -5 (should be 64)
xc2028 2-0061: -5 returned from send
xc2028 2-0061: Error -22 while loading base firmware
xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
xc2028 2-0061: i2c output error: rc = -5 (should be 64)
xc2028 2-0061: -5 returned from send
xc2028 2-0061: Error -22 while loading base firmware
xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
xc2028 2-0061: i2c output error: rc = -5 (should be 64)
xc2028 2-0061: -5 returned from send
xc2028 2-0061: Error -22 while loading base firmware
xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
xc2028 2-0061: i2c output error: rc = -5 (should be 64)
xc2028 2-0061: -5 returned from send
xc2028 2-0061: Error -22 while loading base firmware
xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
xc2028 2-0061: i2c output error: rc = -5 (should be 64)
xc2028 2-0061: -5 returned from send
xc2028 2-0061: Error -22 while loading base firmware
xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
xc2028 2-0061: i2c output error: rc = -5 (should be 64)
xc2028 2-0061: -5 returned from send
xc2028 2-0061: Error -22 while loading base firmware
xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
xc2028 2-0061: i2c output error: rc = -5 (should be 64)
xc2028 2-0061: -5 returned from send
xc2028 2-0061: Error -22 while loading base firmware

I have seen different callbacks functions for certain cards, tested them and the result was the same. I added a delay that cx88_setup_xc3028() establishes for the Powercolor Real Angel, it didn't work. Also, I tried with the firmware extraced from the card's Windows driver (VMXVid.sys) using 'firmware-tool' with the same result (it seems identical to the one from the driver referenced in the perl script included with the kernel).

Any pointers about what's happening? I suspect the tuner is not being resetted correctly. 

Regards,
Carlos



      Yahoo! Cocina
Recetas prácticas y comida saludable
http://ar.mujer.yahoo.com/cocina/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
