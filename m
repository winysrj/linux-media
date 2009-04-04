Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n349ws9M015169
	for <video4linux-list@redhat.com>; Sat, 4 Apr 2009 05:58:54 -0400
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n349wZoi012694
	for <video4linux-list@redhat.com>; Sat, 4 Apr 2009 05:58:35 -0400
Received: by yx-out-2324.google.com with SMTP id 8so868290yxm.81
	for <video4linux-list@redhat.com>; Sat, 04 Apr 2009 02:58:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1c9ccc7b0904040215k5b097630o2121ad521a34e8da@mail.gmail.com>
References: <1c9ccc7b0904040215k5b097630o2121ad521a34e8da@mail.gmail.com>
Date: Sat, 4 Apr 2009 05:58:35 -0400
Message-ID: <412bdbff0904040258l55993229s11ea34082f783629@mail.gmail.com>
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: =?ISO-8859-1?Q?Jean=2DFran=E7ois_Milants?= <jf.milants@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Leadtek Winfast DTV 2000H PLUS
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

On Sat, Apr 4, 2009 at 5:15 AM, Jean-François Milants
<jf.milants@gmail.com> wrote:
> Hi everybody,
> It's my first message on the list. I hope I'll find some help ;)
>
> Recently, I bought a Leadtek Winfast DTV2000H PLUS tuner card for my
> computer. It works very well on Windows (Vista 64)
>
> Now, I'm trying to use it on Linux (Gentoo X86_64) with V4L sources
> from Mercurial.
>
> Here are some information I found on Leadtek website :
>  * Chipset : CX2388x + Intel WJCE6353
>  * Tuner : XCEIVE XC4000
>
> These specifications differ from the specifications of the 'simple' DTV2000h :
>  * Chipset : CX23881  + CX22702
>  * Tuner : Philips FMD1216
>
> First, I tried to use the cx8800 module with 'card=51' as parameter.
> It worked but only if I use it on windows first, select a channel and
> then, reboot on Linux. This way, I could only watch the channel I
> selected on windows. If I coldstart on linux, Tvtime says that there
> is no signal.
>
> Then, I tried to use the patch for the DTV2000H ver J. I found on the
> list but as the DTV2000H PLUS doesn't use the same chipset/tuner, it
> didn't work any better.
>
> Does anybody knows if it could be possible to make my tuner card work
> on linux? Are the chipsets/tuner supported by V4L?
>
> Thanks for your answer!
> JF

The showstopper here is the lack of xc4000 driver support.  All the
other chips are supported.

There are no plans I know of for adding xc4000 support.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
