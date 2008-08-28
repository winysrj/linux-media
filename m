Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hugin.unit.liu.se ([130.236.230.178])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mraspaud@free.fr>) id 1KYh8Z-0002zj-1c
	for linux-dvb@linuxtv.org; Thu, 28 Aug 2008 15:02:09 +0200
Received: from localhost (localhost [127.0.0.1])
	by hugin.unit.liu.se (Postfix) with ESMTP id 33EC4281B0A
	for <linux-dvb@linuxtv.org>; Thu, 28 Aug 2008 15:01:33 +0200 (CEST)
Received: from hugin.unit.liu.se ([127.0.0.1])
	by localhost (hugin.unit.liu.se [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cpaxjWgdR4eL for <linux-dvb@linuxtv.org>;
	Thu, 28 Aug 2008 15:01:32 +0200 (CEST)
Received: from k5717-marra.staff.itn.liu.se (unknown [130.236.136.254])
	by hugin.unit.liu.se (Postfix) with ESMTP id 6A5E728196E
	for <linux-dvb@linuxtv.org>; Thu, 28 Aug 2008 15:01:32 +0200 (CEST)
Message-ID: <48B6A1AB.2010703@free.fr>
Date: Thu, 28 Aug 2008 15:01:31 +0200
From: Martin Raspaud <mraspaud@free.fr>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] v4l-experimental and kernel 2.6.26
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

I just noticed that v4l-experimental does not compile anymore against
kernel 2.6.26. It seems the support of device_class has been removed,
and apparently v4l-experimental still makes use of it.

I use the experimental branch on debian sid for an avermedia E506R
(hybrid cardbus analog+dvb-t)

Does anyone know a workaround ?

Here is what I get when running make:

/usr/src/v4l-dvb-experimental/v4l# make
perl scripts/make_config_compat.pl /lib/modules/2.6.26-1-686/build
./.myconfig ./config-compat.h
creating symbolic links...
make -C /lib/modules/2.6.26-1-686/build
SUBDIRS=/usr/src/v4l-dvb-experimental/v4l  modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.26-1-686'
  CC [M]  /usr/src/v4l-dvb-experimental/v4l/flexcop-pci.o
  CC [M]  /usr/src/v4l-dvb-experimental/v4l/flexcop-usb.o
  CC [M]  /usr/src/v4l-dvb-experimental/v4l/flexcop.o
  CC [M]  /usr/src/v4l-dvb-experimental/v4l/flexcop-fe-tuner.o
  CC [M]  /usr/src/v4l-dvb-experimental/v4l/flexcop-i2c.o
  CC [M]  /usr/src/v4l-dvb-experimental/v4l/flexcop-sram.o
  CC [M]  /usr/src/v4l-dvb-experimental/v4l/flexcop-eeprom.o
  CC [M]  /usr/src/v4l-dvb-experimental/v4l/flexcop-misc.o
  CC [M]  /usr/src/v4l-dvb-experimental/v4l/flexcop-hw-filter.o
  CC [M]  /usr/src/v4l-dvb-experimental/v4l/flexcop-dma.o
  CC [M]  /usr/src/v4l-dvb-experimental/v4l/bttv-driver.o
In file included from
/usr/src/v4l-dvb-experimental/v4l/../linux/include/media/v4l2-common.h:29,
                 from /usr/src/v4l-dvb-experimental/v4l/bttvp.h:37,
                 from /usr/src/v4l-dvb-experimental/v4l/bttv-driver.c:41:
/usr/src/v4l-dvb-experimental/v4l/../linux/include/media/v4l2-dev.h:365:
error: field 'class_dev' has incomplete type
In file included from
/usr/src/v4l-dvb-experimental/v4l/../linux/include/media/v4l2-common.h:29,
                 from /usr/src/v4l-dvb-experimental/v4l/bttvp.h:37,
                 from /usr/src/v4l-dvb-experimental/v4l/bttv-driver.c:41:
/usr/src/v4l-dvb-experimental/v4l/../linux/include/media/v4l2-dev.h:394:
warning: 'struct class_device_attribute' declared inside parameter list
/usr/src/v4l-dvb-experimental/v4l/../linux/include/media/v4l2-dev.h:394:
warning: its scope is only this definition or declaration, which is
probably not what you want
/usr/src/v4l-dvb-experimental/v4l/../linux/include/media/v4l2-dev.h: In
function 'video_device_create_file':
/usr/src/v4l-dvb-experimental/v4l/../linux/include/media/v4l2-dev.h:396:
error: implicit declaration of function 'class_device_create_file'
/usr/src/v4l-dvb-experimental/v4l/../linux/include/media/v4l2-dev.h: At
top level:
/usr/src/v4l-dvb-experimental/v4l/../linux/include/media/v4l2-dev.h:403:
warning: 'struct class_device_attribute' declared inside parameter list
/usr/src/v4l-dvb-experimental/v4l/../linux/include/media/v4l2-dev.h: In
function 'video_device_remove_file':
/usr/src/v4l-dvb-experimental/v4l/../linux/include/media/v4l2-dev.h:405:
error: implicit declaration of function 'class_device_remove_file'
In file included from /usr/src/v4l-dvb-experimental/v4l/bttv-driver.c:41:
/usr/src/v4l-dvb-experimental/v4l/bttvp.h:94:1: warning: "clamp" redefined
In file included from include/asm/system.h:10,
                 from include/asm/processor.h:17,
                 from include/linux/prefetch.h:14,
                 from include/linux/list.h:6,
                 from include/linux/module.h:9,
                 from /usr/src/v4l-dvb-experimental/v4l/bttv-driver.c:32:
include/linux/kernel.h:379:1: warning: this is the location of the
previous definition
/usr/src/v4l-dvb-experimental/v4l/bttv-driver.c: In function 'show_card':
/usr/src/v4l-dvb-experimental/v4l/bttv-driver.c:172: warning: type
defaults to 'int' in declaration of '__mptr'
/usr/src/v4l-dvb-experimental/v4l/bttv-driver.c:172: warning:
initialization from incompatible pointer type
/usr/src/v4l-dvb-experimental/v4l/bttv-driver.c: At top level:
/usr/src/v4l-dvb-experimental/v4l/bttv-driver.c:176: error: expected ')'
before '(' token
/usr/src/v4l-dvb-experimental/v4l/bttv-driver.c: In function
'bttv_register_video':
/usr/src/v4l-dvb-experimental/v4l/bttv-driver.c:4637: error:
'class_device_attr_card' undeclared (first use in this function)
/usr/src/v4l-dvb-experimental/v4l/bttv-driver.c:4637: error: (Each
undeclared identifier is reported only once
/usr/src/v4l-dvb-experimental/v4l/bttv-driver.c:4637: error: for each
function it appears in.)
make[2]: *** [/usr/src/v4l-dvb-experimental/v4l/bttv-driver.o] Error 1
make[1]: *** [_module_/usr/src/v4l-dvb-experimental/v4l] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.26-1-686'
make: *** [default] Erreur 2


Cheers,
Martin
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAki2oasACgkQayBuE7eUetACLgCfZQbIVLlKWd4i4U3UMLI05EFi
SzkAoNn8gxOjCICANw8iEIwtbPXQN2pT
=BrSZ
-----END PGP SIGNATURE-----

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
