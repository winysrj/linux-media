Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7BEe3ed011223
	for <video4linux-list@redhat.com>; Tue, 11 Aug 2009 10:40:03 -0400
Received: from mail-yw0-f203.google.com (mail-yw0-f203.google.com
	[209.85.211.203])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n7BEd3px004018
	for <video4linux-list@redhat.com>; Tue, 11 Aug 2009 10:39:50 -0400
Received: by mail-yw0-f203.google.com with SMTP id 41so5381728ywh.23
	for <video4linux-list@redhat.com>; Tue, 11 Aug 2009 07:39:50 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 11 Aug 2009 09:39:50 -0500
Message-ID: <549053140908110739v56e186ebycbb9a7e32df1ccc9@mail.gmail.com>
From: Carl Karsten <carl@personnelware.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: v4l to dv
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

I am trying to use a usb web cam in place of a dv over firewwire cam.
for testing I am using vivi, but get the following:

$ sudo modprobe vivi
$ dmesg
vivi: V4L2 device registered as /dev/video0
$ ffmpeg -i /dev/video0 -target ntsc-dv -y foo.dv
 /dev/video0: Unknown format

How do I tell what format it is?

foo.dv will be replaced with:

ffmpeg -i /dev/video0 -target ntsc-dv -y - | dvsource-file -

dvsource-file expects a dv stream like what dvgrab produces.

-- 
Carl K

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
