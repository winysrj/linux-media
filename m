Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1T4J3Bo026224
	for <video4linux-list@redhat.com>; Thu, 28 Feb 2008 23:19:03 -0500
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.183])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1T4IW5e023440
	for <video4linux-list@redhat.com>; Thu, 28 Feb 2008 23:18:33 -0500
Received: by wa-out-1112.google.com with SMTP id j37so3983495waf.7
	for <video4linux-list@redhat.com>; Thu, 28 Feb 2008 20:18:32 -0800 (PST)
Message-ID: <f17812d70802282018i92090d6gc6114da677c07280@mail.gmail.com>
Date: Fri, 29 Feb 2008 12:18:32 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: [RFC] move sensor control out of kernel
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

I know some one has different opinion, but since the sensor control logic is
getting more and more complicated, and provided that differences between
sensors and vendors are already too many. Is it better to move sensor
control out of kernel.

Most sensors come with a serial control channel, I2C as can be seen
most commonly. Access to the control information can be done by
i2c-dev interface if possible, thus the driver can be freed as an I2C
stub only. So technically, this is practical.

The benefits I can think of now are:

1. simplified sensor driver design

2. sensor control related debugging can be moved to user space thus
    reducing the debugging effort

3. accessing registers in user space can be done by many other ways
    say, UART. E.g.
    ADCM2650 and ADCM2670 differs in the control channel connection,
    one by I2C and the other by UART, the user space control logic has
    only to decide which device node to open: /dev/i2c/xxx or /dev/ttyXX

Another biggest concern to the V4L2 API itself, sensor nowadays has
more control ability than it used to be, some smart sensor provides
even more like auto focus control, lens control, flash mode, and many
other features that current V4L2 API cannot cover.

Besides, along with the complicated image processing chain, it might
be better described by kinds of pipeline, like what gstreamer is doing
now. Moving some or most of the logic to user space will also significantly
reduce the effort of kernel development.

Now the problem is: we don't have a standard in user space :(

Just a topic, any comments. Thanks

-- 
Cheers
- eric

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
