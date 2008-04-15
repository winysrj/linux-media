Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3F2qQqk031032
	for <video4linux-list@redhat.com>; Mon, 14 Apr 2008 22:52:26 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3F2qEia031006
	for <video4linux-list@redhat.com>; Mon, 14 Apr 2008 22:52:14 -0400
Received: by wf-out-1314.google.com with SMTP id 28so1800360wfc.6
	for <video4linux-list@redhat.com>; Mon, 14 Apr 2008 19:52:14 -0700 (PDT)
Date: Mon, 14 Apr 2008 19:52:00 -0700
From: Brandon Philips <brandon@ifup.org>
To: =?utf-8?B?546L57Sg?= <wangsu820@163.com>
Message-ID: <20080415025200.GB11071@plankton.ifup.org>
References: <3756097.129681208226547847.JavaMail.coremail@bj163app29.163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3756097.129681208226547847.JavaMail.coremail@bj163app29.163.com>
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: Re: I wanna write a v4l camera driver on blackfin ADSP-BF537
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

On 10:29 Tue 15 Apr 2008, 王素 wrote:
> I wanna write a v4l camera driver on blackfin ADSP-BF537. And I do it
> with v4l1 not v4l2, also I know v4l2 is not realized on blackfin.

V4L1 is deprecated.  Please don't write new drivers that use V4L1.

> so my question is : is there any v4l camera driver code be for
> reference in the blackfin uclinux trunk? the blackfin_cam.c okay?

I don't follow what you are asking.

Thanks,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
