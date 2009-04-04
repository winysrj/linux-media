Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n349FWeS003184
	for <video4linux-list@redhat.com>; Sat, 4 Apr 2009 05:15:32 -0400
Received: from mail-ew0-f170.google.com (mail-ew0-f170.google.com
	[209.85.219.170])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n349FF8R011228
	for <video4linux-list@redhat.com>; Sat, 4 Apr 2009 05:15:16 -0400
Received: by ewy18 with SMTP id 18so1149349ewy.3
	for <video4linux-list@redhat.com>; Sat, 04 Apr 2009 02:15:15 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 4 Apr 2009 11:15:15 +0200
Message-ID: <1c9ccc7b0904040215k5b097630o2121ad521a34e8da@mail.gmail.com>
From: =?ISO-8859-1?Q?Jean=2DFran=E7ois_Milants?= <jf.milants@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Leadtek Winfast DTV 2000H PLUS
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

Hi everybody,
It's my first message on the list. I hope I'll find some help ;)

Recently, I bought a Leadtek Winfast DTV2000H PLUS tuner card for my
computer. It works very well on Windows (Vista 64)

Now, I'm trying to use it on Linux (Gentoo X86_64) with V4L sources
from Mercurial.

Here are some information I found on Leadtek website :
 * Chipset : CX2388x + Intel WJCE6353
 * Tuner : XCEIVE XC4000

These specifications differ from the specifications of the 'simple' DTV2000h :
 * Chipset : CX23881  + CX22702
 * Tuner : Philips FMD1216

First, I tried to use the cx8800 module with 'card=51' as parameter.
It worked but only if I use it on windows first, select a channel and
then, reboot on Linux. This way, I could only watch the channel I
selected on windows. If I coldstart on linux, Tvtime says that there
is no signal.

Then, I tried to use the patch for the DTV2000H ver J. I found on the
list but as the DTV2000H PLUS doesn't use the same chipset/tuner, it
didn't work any better.

Does anybody knows if it could be possible to make my tuner card work
on linux? Are the chipsets/tuner supported by V4L?

Thanks for your answer!
JF

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
