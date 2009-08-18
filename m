Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7IJ4S1w007696
	for <video4linux-list@redhat.com>; Tue, 18 Aug 2009 15:04:28 -0400
Received: from mail-yw0-f200.google.com (mail-yw0-f200.google.com
	[209.85.211.200])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7IJ4CLe025631
	for <video4linux-list@redhat.com>; Tue, 18 Aug 2009 15:04:12 -0400
Received: by ywh38 with SMTP id 38so4988863ywh.20
	for <video4linux-list@redhat.com>; Tue, 18 Aug 2009 12:04:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <80f602570908181155v71e96a45q4563cd330ee4e5f0@mail.gmail.com>
References: <80f602570908181155v71e96a45q4563cd330ee4e5f0@mail.gmail.com>
Date: Tue, 18 Aug 2009 15:04:11 -0400
Message-ID: <829197380908181204u5df55094l94b43141570f7f37@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Christian Neumair <cneumair@gnome.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
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

On Tue, Aug 18, 2009 at 2:55 PM, Christian Neumair<cneumair@gnome.org> wrote:
> Dear video4linux-list,
>
> I observed a problem with an ancient easyVDR distribution from 2007 which
> uses vdr 1.4.5 (c't vdr), fbtv 3.95, and kernel 2.6.22.5: As soon as I quit
> fbtv with ctrl-c, vdr turns into a CPU hog and has to be killed. This is
> unfortunate, because in my setup I only want to use the local fbtv frontend
> occassionally, while permanently using the remote VOMP plugin. Is this a
> known issue? Can you reproduce it with recent vdr and fbtv versions? Can I
> do anything to debug the issue?
>
> Thanks in advance!
>
> best regards,
>  Christian Neumair

You're probably not going to find a developer willing to spend the
cycles to debug an ancient version of VDR on an ancient kernel.  Your
best bet is to update to the latest version and see if the problem
still occurs.  Fortunately it seems like the issue is highly
reproducible for you, so seeing if it occurs in the latest version
should be pretty straightforward.

So if you are looking to help debug the issue, answer your own
question: "Can you reproduce it with recent vdr and fbtv versions?"

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
