Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1996dQM027427
	for <video4linux-list@redhat.com>; Mon, 9 Feb 2009 04:06:39 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.169])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n1995VvL022518
	for <video4linux-list@redhat.com>; Mon, 9 Feb 2009 04:05:31 -0500
Received: by wf-out-1314.google.com with SMTP id 25so1871515wfc.6
	for <video4linux-list@redhat.com>; Mon, 09 Feb 2009 01:05:31 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 9 Feb 2009 17:05:31 +0800
Message-ID: <147fc4b90902090105h1a9e27d2ib4a69f27c42e7f4a@mail.gmail.com>
From: richard cinema <richard.cinema@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: motv can't save preference and small preview window problem
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

just compile xawtv.3.x from source, in my opinion, motv is better than
xawtv, at least, in interface:D

but the problems:

1 : i changed some options in the preference such as mixer setting and mixer
control, close motv, rerun it, and all the options i changed just  grey out
again:( in the man page, seems no related info there.

2 : video preview window is alway 320x240, i tried to set below Xresouce and
restart X but not work, seems motv doesn't respect this resource setting,
change to 720x576 still get the same result:

xawtv.geometry: 768x576

3. audio mode is always mono even i manually choose stereo.

on the contrary, xawtv is ok on this.

4. i set debug verbose to level 2, if don't, there will be a error info
window popup and keep saying something like this, although this doesn't
impact on recording/viewing, it's boring to see this again and again, does
there exist a way to disable this error msg permantly ?
:

ioctl: VIDIOC_REQBUFS(count=2;type=VIDEO_CAPTURE;memory=MMAP): temporary
unavailable
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
