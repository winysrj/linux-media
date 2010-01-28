Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o0S9wHhH005129
	for <video4linux-list@redhat.com>; Thu, 28 Jan 2010 04:58:17 -0500
Received: from mail-pw0-f52.google.com (mail-pw0-f52.google.com
	[209.85.160.52])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0S9w2mR014028
	for <video4linux-list@redhat.com>; Thu, 28 Jan 2010 04:58:02 -0500
Received: by pwi8 with SMTP id 8so401726pwi.11
	for <video4linux-list@redhat.com>; Thu, 28 Jan 2010 01:58:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <fe6fd5f61001280147gd26f70cl8f8dcb8a80b20071@mail.gmail.com>
References: <fe6fd5f61001280147gd26f70cl8f8dcb8a80b20071@mail.gmail.com>
Date: Thu, 28 Jan 2010 10:58:01 +0100
Message-ID: <fe6fd5f61001280158q2bf27d2cud2bb08301a7b98a7@mail.gmail.com>
Subject: Re: do soc_camera has "VIDIOC_S_FMT"?
From: Carlos Lavin <carlos.lavin@vista-silicon.com>
To: video4linux-list <video4linux-list@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

sorry, I have a problem with the copy&paste, I want to say the
VIDIOC_S_PARM...
Hello,I am working with an application of video with a driver that works
with soc-camera subsytem in version 2.6.30, I need work in this version, so
in the negotation of format of data and params, I have an error with the
ioctl "VIDIOC_S_PARM". I have looking at in the file soc-camera but I
haven't found equivalence with this ioctl, mi question is: how can I
implemented this Ioctl?
>
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
