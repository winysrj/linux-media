Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3HITIov010065
	for <video4linux-list@redhat.com>; Fri, 17 Apr 2009 14:29:18 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.229])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3HISxYR023787
	for <video4linux-list@redhat.com>; Fri, 17 Apr 2009 14:28:59 -0400
Received: by rv-out-0506.google.com with SMTP id f6so437927rvb.3
	for <video4linux-list@redhat.com>; Fri, 17 Apr 2009 11:28:59 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 17 Apr 2009 11:28:58 -0700
Message-ID: <edc06e0a0904171128x3296dee0wcd7a23fde352930d@mail.gmail.com>
From: Justin Smith <justinsmith2009@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: au0828/au8522 v4l
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

Hi,

I have a Hauppauge card which uses the au0828 and au8522 kernel
modules. Whenever I load them, it also loads videodev, v4l1_compat,
etc.

However it appears that the original videodev kernel module is
replaced by the videodev module that comes with v4l-dvb.

I have another v4l driver in my system which cannot be loaded because
of this. The error message that I get is, "disagrees about version of
symbol video_devdata"

Can anyone tell me what might be causing this. I tried make
kernel-links but that does not seem to help

Thanks,
Justin

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
