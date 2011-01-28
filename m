Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id p0SHLn8F021536
	for <video4linux-list@redhat.com>; Fri, 28 Jan 2011 12:21:49 -0500
Received: from mail-wy0-f174.google.com (mail-wy0-f174.google.com
	[74.125.82.174])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0SHL3CL009769
	for <video4linux-list@redhat.com>; Fri, 28 Jan 2011 12:21:37 -0500
Received: by mail-wy0-f174.google.com with SMTP id 28so3614346wyb.33
	for <video4linux-list@redhat.com>; Fri, 28 Jan 2011 09:21:36 -0800 (PST)
MIME-Version: 1.0
From: chetan patil <chtpatil@gmail.com>
Date: Fri, 28 Jan 2011 22:51:14 +0530
Message-ID: <AANLkTikd-3NAsAFGomYV7oE=cOkozf3nZ6U2QK73C1G6@mail.gmail.com>
Subject: Error While Compiling XAWTV
To: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

Hi,

I'm trying to compile XAWTV 3.95 for arm board.

Setting configure as: ./configure
--prefix=/home/chetanpatil/workdir/filesys/ CC=arm_v5t_le-gcc --host=arm

But while doing make.
I'm getting error as:

console/fbtv.c:339: error: dereferencing pointer to incomplete type
console/fbtv.c:340: error: dereferencing pointer to incomplete type
console/fbtv.c: In function `do_capture':
console/fbtv.c:405: error: dereferencing pointer to incomplete type
console/fbtv.c:406: error: dereferencing pointer to incomplete type
console/fbtv.c:443: error: dereferencing pointer to incomplete type
console/fbtv.c:444: error: dereferencing pointer to incomplete type
console/fbtv.c: In function `main':
console/fbtv.c:755: error: dereferencing pointer to incomplete type
console/fbtv.c:773: error: dereferencing pointer to incomplete type
make: *** [console/fbtv.o] Error 1


Can any one help me out?!

Thanks.

-- 
Regards,

Chetan Arvind Patil,
+919970018364
<http://sites.google.com/site/chtpatil/>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
