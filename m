Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7INKHem000517
	for <video4linux-list@redhat.com>; Tue, 18 Aug 2009 19:20:17 -0400
Received: from mail-bw0-f218.google.com (mail-bw0-f218.google.com
	[209.85.218.218])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7INK2Fi027650
	for <video4linux-list@redhat.com>; Tue, 18 Aug 2009 19:20:02 -0400
Received: by bwz18 with SMTP id 18so3078347bwz.7
	for <video4linux-list@redhat.com>; Tue, 18 Aug 2009 16:20:01 -0700 (PDT)
From: Christian Neumair <cneumair@gnome.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
In-Reply-To: <829197380908181204u5df55094l94b43141570f7f37@mail.gmail.com>
References: <80f602570908181155v71e96a45q4563cd330ee4e5f0@mail.gmail.com>
	<829197380908181204u5df55094l94b43141570f7f37@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 19 Aug 2009 01:19:58 +0200
Message-Id: <1250637598.4012.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: fbtv 3.95 & vdr 1.4.5: closing fbtv causes vdr freeze
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

Am Dienstag, den 18.08.2009, 15:04 -0400 schrieb Devin Heitmueller:
> On Tue, Aug 18, 2009 at 2:55 PM, Christian Neumair<cneumair@gnome.org> wrote:
> > Dear video4linux-list,
> >
> > I observed a problem with an ancient easyVDR distribution from 2007 which
> > uses vdr 1.4.5 (c't vdr), fbtv 3.95, and kernel 2.6.22.5: As soon as I quit
> > fbtv with ctrl-c, vdr turns into a CPU hog and has to be killed. This is
> > unfortunate, because in my setup I only want to use the local fbtv frontend
> > occassionally, while permanently using the remote VOMP plugin. Is this a
> > known issue? Can you reproduce it with recent vdr and fbtv versions? Can I
> > do anything to debug the issue?
> >
> > Thanks in advance!
> >
> > best regards,
> >  Christian Neumair
> 
> You're probably not going to find a developer willing to spend the
> cycles to debug an ancient version of VDR on an ancient kernel.  Your
> best bet is to update to the latest version and see if the problem
> still occurs.  Fortunately it seems like the issue is highly
> reproducible for you, so seeing if it occurs in the latest version
> should be pretty straightforward.
> 
> So if you are looking to help debug the issue, answer your own
> question: "Can you reproduce it with recent vdr and fbtv versions?"

Come on, we are all developers.

In an attempt to keep my running and carefully configured system intact,
I can not blindly upgrade anything. I prefer to apply a patch for this
very specific issue. Upgrading the entire system wouldn't help either
because it does not help me to isolate the cause of the bug.

Unfortunately, I don't have a clue about the precise vdr/fbtv/v4l IPC.
If anybody could give me an overview over the mechanisms or code paths,
I could try to grep in the sources myself.

Thanks in advance!

best regards,
 Christian Neumair

PS: As a Nautilus maintainer, the "please upgrade to the latest
version(s)" hint is well-known from GNOME bugzilla, and I don't like it
at all, to say the least. From a developer perspective, it is always
desirable to find out why and how an issue was fixed because otherwise
you can't guarantee that it was really fixed, but instead it may have
been obfuscated by another issue.

-- 
Christian Neumair <cneumair@gnome.org>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
