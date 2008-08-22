Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7MJ9GxM008096
	for <video4linux-list@redhat.com>; Fri, 22 Aug 2008 15:09:17 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7MJ93W9032655
	for <video4linux-list@redhat.com>; Fri, 22 Aug 2008 15:09:03 -0400
From: Andy Walls <awalls@radix.net>
To: Linux and Kernel Video <video4linux-list@redhat.com>, linux-dvb@linuxtv.org
Content-Type: text/plain
Date: Fri, 22 Aug 2008 15:07:50 -0400
Message-Id: <1219432070.2897.35.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: 
Subject: mt9m111.c in latest v4l-dvb doesn't compile under
	2.6.25.10-86.fc9.x86_64
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

[andy@morgan v4l-dvb]$ make
make -C /home/andy/cx18dev/v4l-dvb/v4l 
make[1]: Entering directory `/home/andy/cx18dev/v4l-dvb/v4l'
creating symbolic links...
Kernel build directory is /lib/modules/2.6.25.10-86.fc9.x86_64/build
make -C /lib/modules/2.6.25.10-86.fc9.x86_64/build SUBDIRS=/home/andy/cx18dev/v4l-dvb/v4l  modules
make[2]: Entering directory `/usr/src/kernels/2.6.25.10-86.fc9.x86_64'
  CC [M]  /home/andy/cx18dev/v4l-dvb/v4l/mt9m111.o
/home/andy/cx18dev/v4l-dvb/v4l/mt9m111.c:943: error: array type has incomplete element type
/home/andy/cx18dev/v4l-dvb/v4l/mt9m111.c:953: warning: initialization from incompatible pointer type
/home/andy/cx18dev/v4l-dvb/v4l/mt9m111.c:955: error: unknown field 'id_table' specified in initializer
make[3]: *** [/home/andy/cx18dev/v4l-dvb/v4l/mt9m111.o] Error 1
make[2]: *** [_module_/home/andy/cx18dev/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.25.10-86.fc9.x86_64'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/andy/cx18dev/v4l-dvb/v4l'
make: *** [all] Error 2


The offending code is this:
943 static const struct i2c_device_id mt9m111_id[] = {
944         { "mt9m111", 0 },
945         { }
946 };
947 MODULE_DEVICE_TABLE(i2c, mt9m111_id);
948 
949 static struct i2c_driver mt9m111_i2c_driver = {
950         .driver = {
951                 .name = "mt9m111",
952         },
953         .probe          = mt9m111_probe,
954         .remove         = mt9m111_remove,
955         .id_table       = mt9m111_id,
956 };

My tags files for the kernel source and v4l-dvb don't have "struct
i2c_device_id" in them.  My kernel's i2c_driver structure has a
different declaration for probe [int (*probe)(struct i2c_client *);]
than what mt9m111_probe uses, and it doesn't have an id_table member.


Could someone add some kernel version compatibility checks?  I could
make a swag at it, but I don't think I'll get it right.

Thanks,
Andy

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
