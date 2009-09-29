Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpd3.aruba.it ([62.149.128.208]:35007 "HELO smtp5.aruba.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753405AbZI2K0y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Sep 2009 06:26:54 -0400
Subject: compile the driver
From: Mauro Cominale <m.cominale@cnsat.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Tue, 29 Sep 2009 12:26:56 +0200
Message-Id: <1254220016.10556.19.camel@mauro-XPS>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm trying to compile the v4l driver but I' the following error:

CC [M]  /home/lidia/v4l-dvb/v4l/adv7175.o
  CC [M]  /home/lidia/v4l-dvb/v4l/adv7180.o
/home/lidia/v4l-dvb/v4l/adv7180.c:169: error: array type has incomplete
element type
/home/lidia/v4l-dvb/v4l/adv7180.c:181: warning: initialization from
incompatible pointer type
/home/lidia/v4l-dvb/v4l/adv7180.c:183: error: unknown field 'id_table'
specified in initializer
make[3]: *** [/home/lidia/v4l-dvb/v4l/adv7180.o] Error 1
make[2]: *** [_module_/home/lidia/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.24-16-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/lidia/v4l-dvb/v4l'
make: *** [all] Error 2 


any suggestion?
Mauro

