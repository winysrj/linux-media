Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7MJqdKK025242
	for <video4linux-list@redhat.com>; Fri, 22 Aug 2008 15:52:39 -0400
Received: from smtp-vbr11.xs4all.nl (smtp-vbr11.xs4all.nl [194.109.24.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7MJqQt1029180
	for <video4linux-list@redhat.com>; Fri, 22 Aug 2008 15:52:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Fri, 22 Aug 2008 21:52:17 +0200
References: <1219432070.2897.35.camel@morgan.walls.org>
In-Reply-To: <1219432070.2897.35.camel@morgan.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808222152.17739.hverkuil@xs4all.nl>
Cc: linux-dvb@linuxtv.org
Subject: Re: mt9m111.c in latest v4l-dvb doesn't compile under
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

On Friday 22 August 2008 21:07:50 Andy Walls wrote:
> [andy@morgan v4l-dvb]$ make
> make -C /home/andy/cx18dev/v4l-dvb/v4l
> make[1]: Entering directory `/home/andy/cx18dev/v4l-dvb/v4l'
> creating symbolic links...
> Kernel build directory is /lib/modules/2.6.25.10-86.fc9.x86_64/build
> make -C /lib/modules/2.6.25.10-86.fc9.x86_64/build
> SUBDIRS=/home/andy/cx18dev/v4l-dvb/v4l  modules make[2]: Entering
> directory `/usr/src/kernels/2.6.25.10-86.fc9.x86_64' CC [M] 
> /home/andy/cx18dev/v4l-dvb/v4l/mt9m111.o
> /home/andy/cx18dev/v4l-dvb/v4l/mt9m111.c:943: error: array type has
> incomplete element type /home/andy/cx18dev/v4l-dvb/v4l/mt9m111.c:953:
> warning: initialization from incompatible pointer type
> /home/andy/cx18dev/v4l-dvb/v4l/mt9m111.c:955: error: unknown field
> 'id_table' specified in initializer make[3]: ***
> [/home/andy/cx18dev/v4l-dvb/v4l/mt9m111.o] Error 1 make[2]: ***
> [_module_/home/andy/cx18dev/v4l-dvb/v4l] Error 2 make[2]: Leaving
> directory `/usr/src/kernels/2.6.25.10-86.fc9.x86_64' make[1]: ***
> [default] Error 2
> make[1]: Leaving directory `/home/andy/cx18dev/v4l-dvb/v4l'
> make: *** [all] Error 2
>
>
> The offending code is this:
> 943 static const struct i2c_device_id mt9m111_id[] = {
> 944         { "mt9m111", 0 },
> 945         { }
> 946 };
> 947 MODULE_DEVICE_TABLE(i2c, mt9m111_id);
> 948
> 949 static struct i2c_driver mt9m111_i2c_driver = {
> 950         .driver = {
> 951                 .name = "mt9m111",
> 952         },
> 953         .probe          = mt9m111_probe,
> 954         .remove         = mt9m111_remove,
> 955         .id_table       = mt9m111_id,
> 956 };
>
> My tags files for the kernel source and v4l-dvb don't have "struct
> i2c_device_id" in them.  My kernel's i2c_driver structure has a
> different declaration for probe [int (*probe)(struct i2c_client *);]
> than what mt9m111_probe uses, and it doesn't have an id_table member.
>
>
> Could someone add some kernel version compatibility checks?  I could
> make a swag at it, but I don't think I'll get it right.

I've fixed it in my v4l-dvb tree. I'll go through some of the other 
warnings as well and post a pull request when I'm done.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
