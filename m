Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:11571 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbZKJMTz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 07:19:55 -0500
Received: by fg-out-1718.google.com with SMTP id d23so1126331fga.1
        for <linux-media@vger.kernel.org>; Tue, 10 Nov 2009 04:20:00 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 10 Nov 2009 12:19:59 +0000
Message-ID: <921ad39e0911100419p3ca39ea4ycd5ac84322555fc2@mail.gmail.com>
Subject: =?UTF-8?Q?tw68=2Dv2=2Ftw68=2Di2c=2Ec=3A145=3A_error=3A_unknown_field_=E2=80=98clie?=
	=?UTF-8?Q?nt=5Fregister=E2=80=99_specified_in_initializer?=
From: Roman Gaufman <hackeron@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey, I'm trying to compile tw68 and I'm getting the following:

make -C /lib/modules/2.6.31-14-generic/build M=/root/tw68-v2 modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.31-14-generic'
  CC [M]  /root/tw68-v2/tw68-core.o
  CC [M]  /root/tw68-v2/tw68-cards.o
  CC [M]  /root/tw68-v2/tw68-i2c.o
/root/tw68-v2/tw68-i2c.c:145: error: unknown field ‘client_register’
specified in initializer
/root/tw68-v2/tw68-i2c.c:145: warning: missing braces around initializer
/root/tw68-v2/tw68-i2c.c:145: warning: (near initialization for
‘tw68_adap_sw_template.dev_released’)
/root/tw68-v2/tw68-i2c.c:145: warning: initialization makes integer
from pointer without a cast
/root/tw68-v2/tw68-i2c.c:145: error: initializer element is not
computable at load time
/root/tw68-v2/tw68-i2c.c:145: error: (near initialization for
‘tw68_adap_sw_template.dev_released.done’)
make[2]: *** [/root/tw68-v2/tw68-i2c.o] Error 1
make[1]: *** [_module_/root/tw68-v2] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.31-14-generic'
make: *** [all] Error 2

Any ideas?
