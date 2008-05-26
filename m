Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4QCmtbe020838
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 08:48:55 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4QCmju3022910
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 08:48:45 -0400
Received: by yw-out-2324.google.com with SMTP id 5so957368ywb.81
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 05:48:35 -0700 (PDT)
Message-ID: <dee83fc60805260548i2ba941b2uc19cf86c8470687b@mail.gmail.com>
Date: Mon, 26 May 2008 16:48:34 +0400
From: "Paul Wolneykien" <wolneykien@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <dee83fc60805260055g63f66f17k779205b03d10feb8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dee83fc60805260055g63f66f17k779205b03d10feb8@mail.gmail.com>
Subject: Strange problem with saa7134 on amd64
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

  I've found a problem with saa7134 based analog TV card (card = 67)
on amd64 architecture: every request finishes immediately with
"Input/Output" error, ioctl code depends on the program (I've made
some tests using "cat /dev/video0", tvtime, vlc, ffmpeg). The
strangeness of the problem is in the fact, that it is only took its
place on 64-bit amd64 kernel (and applications) and there wasn't such
a problem on the same computer running 32-bit i686 kernel. The distro
environment stays the same: Debian Etch with 2.6.18-7 packaged and
2.6.24 manually compiled kernels. I also try a number of Live CDs (for
instance, Ubuntu Hardy i386 and amd64): loading the 32-bit version I
cat watch TV using tvtime, but it is always an "Input/Output" error"
with 64-bit version of the same Live CD.
  So, based on that symptoms, I can figure that the problem is related
somehow to the size and/or alignment of the data being processed by
the kernel module. Excuse me, If that sounds a little bit fondly I am
a kind of a newbie in the kernel programming. I will be very thankful
for any information about the good enough method to start the research
and, I hope,  to fix the problem.
  So, gentlemen, where should I start? :)

 Best regards,

 Paul Wolneykien

 SMTP: wolneykien [at] gmail [dot] com
 XMPP: wolneykien [at] jabber [dot] org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
