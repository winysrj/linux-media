Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m42McmEI014095
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 18:38:48 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m42Mca5x021986
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 18:38:36 -0400
Received: from [192.168.1.2] (02-138.155.popsite.net [66.217.132.138])
	(authenticated bits=0)
	by mail1.radix.net (8.13.4/8.13.4) with ESMTP id m42McUdq021148
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 18:38:35 -0400 (EDT)
From: Andy Walls <awalls@radix.net>
To: video4linux-list@redhat.com
Content-Type: text/plain
Date: Fri, 02 May 2008 18:37:36 -0400
Message-Id: <1209767856.19893.12.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: tcm825x.c:892: warning: initialization from incompatible pointer
	type
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

Making the latest v4l-dvb tree on my system yields this warning:

$ make
make -C /home/andy/cx18dev/v4l-dvb/v4l 
make[1]: Entering directory `/home/andy/cx18dev/v4l-dvb/v4l'
creating symbolic links...
Kernel build directory is /lib/modules/2.6.23.15-80.fc7/build
make -C /lib/modules/2.6.23.15-80.fc7/build SUBDIRS=/home/andy/cx18dev/v4l-dvb/v4l  modules
make[2]: Entering directory `/usr/src/kernels/2.6.23.15-80.fc7-x86_64'
  CC [M]  /home/andy/cx18dev/v4l-dvb/v4l/tcm825x.o
/home/andy/cx18dev/v4l-dvb/v4l/tcm825x.c:892: warning: initialization from incompatible pointer type


On my 2.6.23.15 kernel, the probe member of struct i2c_driver is a
pointer to a functions that takes only one argument.  

struct i2c_driver {
[...]
        int (*probe)(struct i2c_client *);
[...]
};

but in tcm825x.c in the latest v4l-dvb repo it's a 2 argument function:

static int tcm825x_probe(struct i2c_client *client,
                         const struct i2c_device_id *did)


I'm not sure how far back the hg repository aims to ensure working with
older kernels, but I thought someone may care.

Regards,
Andy

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
