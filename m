Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA3L0q5O022930
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 16:00:52 -0500
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA3L0bFx027306
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 16:00:38 -0500
Received: from tervel.nabble.com ([192.168.236.150])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <bounces@n2.nabble.com>) id 1Kx6XN-0000lu-AB
	for video4linux-list@redhat.com; Mon, 03 Nov 2008 13:00:37 -0800
Message-ID: <1225746037211-1451395.post@n2.nabble.com>
Date: Mon, 3 Nov 2008 13:00:37 -0800 (PST)
From: Colin Brace <cb@lim.nl>
To: video4linux-list@redhat.com
In-Reply-To: <490F4ABB.1050608@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <490F2730.9090703@lim.nl> <490F4ABB.1050608@hhs.nl>
Content-Transfer-Encoding: 8bit
Subject: Re: [patch] xawtv 'webcam' & uvcvideo webcam: ioctl error
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



Hans de Goede wrote:
> 
> I think I do, xawtv contains a few v4l2 handling bugs. This patch fixes
> them 
> and most likely fixes your issue:
> http://cvs.fedoraproject.org/viewvc/devel/xawtv/xawtv-3.95-fixes.patch?revision=1.1
> 

Thanks, Hans. I downloaded and applied that patch to the source. However
when I go to compile it, 'make' returns an error:

[...]
console/fs.h:2:20: error: FSlib.h: No such file or directory
In file included from console/fbtv.c:44:
console/fs.h:6: error: expected specifier-qualifier-list before
‘FSXFontInfoHeader’
console/fs.h:58: error: expected declaration specifiers or ‘...’ before
‘FSXCharInfo’
console/fs.h:62: error: expected ‘)’ before ‘*’ token
console/fbtv.c: In function ‘text_out’:
console/fbtv.c:339: error: ‘struct fs_font’ has no member named ‘height’
console/fbtv.c:340: error: ‘struct fs_font’ has no member named ‘fontHeader’
console/fbtv.c:341: warning: pointer targets in passing argument 4 of
‘fs_puts’ differ in signedness
console/fbtv.c: In function ‘text_width’:
console/fbtv.c:347: warning: pointer targets in passing argument 2 of
‘fs_textwidth’ differ in signedness
console/fbtv.c: In function ‘do_capture’:
console/fbtv.c:405: error: ‘struct fs_font’ has no member named ‘height’
console/fbtv.c:406: error: ‘struct fs_font’ has no member named ‘height’
console/fbtv.c:443: error: ‘struct fs_font’ has no member named ‘height’
console/fbtv.c:444: error: ‘struct fs_font’ has no member named ‘height’
console/fbtv.c: In function ‘main’:
console/fbtv.c:755: error: ‘struct fs_font’ has no member named ‘height’
console/fbtv.c:773: error: ‘struct fs_font’ has no member named ‘width’
console/fbtv.c:813: warning: pointer targets in assignment differ in
signedness
make: *** [console/fbtv.o] Error 1

It looks like a file called fslib.h is missing. Neither yum nor Google turn
up a package by this name, although there are a couple of references on the
Web to this file. Any idea what I am missing?


-- 
View this message in context: http://n2.nabble.com/xawtv-%27webcam%27---uvcvideo-webcam%3A-ioctl-error-tp1450204p1451395.html
Sent from the video4linux-list mailing list archive at Nabble.com.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
