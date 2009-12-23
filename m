Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp133.mail.ukl.yahoo.com ([77.238.184.64]:25221 "HELO
	smtp133.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752015AbZLWLlk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2009 06:41:40 -0500
Message-ID: <4B320062.6080600@yahoo.it>
Date: Wed, 23 Dec 2009 12:34:58 +0100
From: SebaX <sebax75@yahoo.it>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Error during compile on Fedora 11, revision after 13823
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I'm trying to compile v4l on Fedora 11, latest available RPM kernel, but 
there are many problem.
I've tried to go in the past with revision (hg update <revision>), and 
the last revision I can compile without problem is 13823.
Is this a know bug/error due to have not last kernel?

Thanks for the help you can provide,
Sebastian

P.S.: here are more information about compiling process and error received:

Kernel version: Linux localhost 2.6.30.9-102.fc11.i686.PAE #1 SMP Fri 
Dec 4 00:19:26 EST 2009 i686 i686 i386 GNU/Linux

Revison 13840
   CC [M]  /home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.o
/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c:20:23: error: 
sound/aci.h: No such file or directory 

/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c: In function 
'pcm20_mute':
/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c:46: error: implicit 
declaration of function 'snd_aci_cmd' 

/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c:46: error: 
'ACI_SET_TUNERMUTE' undeclared (first use in this function) 

/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c:46: error: (Each 
undeclared identifier is reported only once 

/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c:46: error: for each 
function it appears in.) 

/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c: In function 
'pcm20_stereo':
/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c:51: error: 
'ACI_SET_TUNERMONO' undeclared (first use in this function) 

/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c: In function 
'pcm20_setfreq':
/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c:63: error: dereferencing 
pointer to incomplete type 

/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c:63: error: dereferencing 
pointer to incomplete type 

/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c:70: error: 
'ACI_WRITE_TUNE' undeclared (first use in this function) 

/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c: In function 
'pcm20_init':
/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c:225: error: implicit 
declaration of function 'snd_aci_get_aci' 

/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c:225: warning: assignment 
makes pointer from integer without a cast 

make[3]: *** [/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.o] Error 1 

make[2]: *** [_module_/home/sebhack/src/v4l-dvb/v4l] Error 2 

make[2]: Leaving directory `/usr/src/kernels/2.6.30.9-102.fc11.i686.PAE' 

make[1]: *** [default] Error 2 

make[1]: Leaving directory `/home/sebhack/src/v4l-dvb/v4l' 

make: *** [all] Error 2

Revison 13830
   CC [M]  /home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.o
/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c:20:23: error: 
sound/aci.h: No such file or directory
/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c: In function 'pcm20_mute':
/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c:46: error: implicit 
declaration of function 'snd_aci_cmd'
/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c:46: error: 
'ACI_SET_TUNERMUTE' undeclared (first use in this function)
/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c:46: error: (Each 
undeclared identifier is reported only once
/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c:46: error: for each 
function it appears in.)
/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c: In function 'pcm20_stereo':
/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c:51: error: 
'ACI_SET_TUNERMONO' undeclared (first use in this function)
/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c: In function 
'pcm20_setfreq':
/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c:63: error: dereferencing 
pointer to incomplete type
/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c:63: error: dereferencing 
pointer to incomplete type
/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c:70: error: 
'ACI_WRITE_TUNE' undeclared (first use in this function)
/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c: In function 'pcm20_init':
/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c:225: error: implicit 
declaration of function 'snd_aci_get_aci'
/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.c:225: warning: assignment 
makes pointer from integer without a cast
make[3]: *** [/home/sebhack/src/v4l-dvb/v4l/radio-miropcm20.o] Error 1
make[2]: *** [_module_/home/sebhack/src/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.30.9-102.fc11.i686.PAE'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/sebhack/src/v4l-dvb/v4l'
make: *** [all] Error 2

Revison 13825
   CC [M]  /home/sebhack/src/v4l-dvb/v4l/au0828-cards.o
In file included from /home/sebhack/src/v4l-dvb/v4l/dmxdev.h:33,
                  from /home/sebhack/src/v4l-dvb/v4l/au0828.h:29,
                  from /home/sebhack/src/v4l-dvb/v4l/au0828-cards.c:22:
/home/sebhack/src/v4l-dvb/v4l/compat.h:396: error: redefinition of 
'usb_endpoint_type'
include/linux/usb/ch9.h:376: note: previous definition of 
'usb_endpoint_type' was here
make[3]: *** [/home/sebhack/src/v4l-dvb/v4l/au0828-cards.o] Error 1
make[2]: *** [_module_/home/sebhack/src/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.30.9-102.fc11.i686.PAE'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/sebhack/src/v4l-dvb/v4l'
make: *** [all] Error 2

Revison 13824
   CC [M]  /home/sebhack/src/v4l-dvb/v4l/mantis_input.o
/home/sebhack/src/v4l-dvb/v4l/mantis_input.c: In function 
'mantis_input_init':
/home/sebhack/src/v4l-dvb/v4l/mantis_input.c:121: error: too many 
arguments to function 'ir_input_init'
make[3]: *** [/home/sebhack/src/v4l-dvb/v4l/mantis_input.o] Error 1
make[2]: *** [_module_/home/sebhack/src/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.30.9-102.fc11.i686.PAE'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/sebhack/src/v4l-dvb/v4l'
make: *** [all] Error 2

Revison 13823: this revision compile without problem
