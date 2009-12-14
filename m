Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nBEJYUsI002344
	for <video4linux-list@redhat.com>; Mon, 14 Dec 2009 14:34:30 -0500
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.159])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nBEJYIdF017146
	for <video4linux-list@redhat.com>; Mon, 14 Dec 2009 14:34:19 -0500
Received: by fg-out-1718.google.com with SMTP id 16so90609fgg.9
	for <video4linux-list@redhat.com>; Mon, 14 Dec 2009 11:34:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B268C96.2020605@home.se>
References: <4B268C96.2020605@home.se>
Date: Mon, 14 Dec 2009 14:34:17 -0500
Message-ID: <829197380912141134o49ec613du97600464c23fe49@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andreas Lunderhage <lunderhage@home.se>
Content-Type: text/plain; charset=ISO-8859-1
Cc: video4linux-list@redhat.com
Subject: Re: Pinnacle Hybrid Pro Stick USB scan problems
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

On Mon, Dec 14, 2009 at 2:05 PM, Andreas Lunderhage <lunderhage@home.se> wrote:
> Hi,
>
> I have problems scanning with my Pinnacle Hybrid Pro Stick (320E). When
> using the scan command, it finds the channels in the first mux in the mux
> file but it fails to tune the next ones. If I use Kaffeine to scan, it gives
> the same result but I can also see that the signal strength shows 99% on
> those muxes it fails to scan.
>
> I thinks this is a problem with the tuning since if I watch one channel and
> switch to another (on another mux), it fails to tune. If I stop the viewing
> of the current channel first, then it will succeed tuning the next.
>
> I'm running Ubuntu 9.04 32-bit (kernel 2.6.28-17-generic) with the code
> built from the repository today.
> I'm also running Ubuntu 9.10 64-bit (kernel 2.6.31-16) (on another machine),
> but it gives the same problem.

First, make sure you are running the latest v4l-dvb code (instructions
at http://linuxtv.org/repo), and then try commenting out line 181 of
em28xx-cards.c and see if that fixes the issue.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
