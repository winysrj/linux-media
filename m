Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3OMYDKP024862
	for <video4linux-list@redhat.com>; Fri, 24 Apr 2009 18:34:13 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3OMXvXq000603
	for <video4linux-list@redhat.com>; Fri, 24 Apr 2009 18:33:57 -0400
Received: by yw-out-2324.google.com with SMTP id 3so771111ywj.81
	for <video4linux-list@redhat.com>; Fri, 24 Apr 2009 15:33:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090425082906.a1a3b872.erik@bcode.com>
References: <20090424170352.313f1feb.erik@bcode.com>
	<412bdbff0904240625y3902243em5a643380b036e08f@mail.gmail.com>
	<20090425080356.69e0ed9d.erik@bcode.com>
	<412bdbff0904241509r29b0859fl22abe2fe78e59daa@mail.gmail.com>
	<20090425081654.3e9932f1.erik@bcode.com>
	<412bdbff0904241522s4466fe3dh3fadd3b21113e60@mail.gmail.com>
	<20090425082906.a1a3b872.erik@bcode.com>
Date: Fri, 24 Apr 2009 18:33:57 -0400
Message-ID: <412bdbff0904241533i65ce1040x26a79b4577c4d4fb@mail.gmail.com>
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Subject: Re: Compling drivers from v4l-dvb hg tree
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

On Fri, Apr 24, 2009 at 6:29 PM, Erik de Castro Lopo <erik@bcode.com> wrote:
> On Fri, 24 Apr 2009 18:22:40 -0400
> Devin Heitmueller <devin.heitmueller@gmail.com> wrote:
>
>> Yeah, that's a bit harder.  I did it a couple of months ago for ARM.
>> I had to change the path to ensure the path to the cross-compiler's
>> version of strip was ahead of the base operating system's version.
>
> Well both my compile machine and my target are running x86 Ubuntu.
> The only really relevant difference is that they have different
> kernels, 2.6.26 on the compile machine and 2.6.29 on the target.
>
> I've looked at the top level Makefile but there doesn't seem to be
> a way os specifying compiling against another kernel.

It's the same basic issue.  To use a different kernel tree for the
headers, add "SRCDIR=" as an argument to make.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
