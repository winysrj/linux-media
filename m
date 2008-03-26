Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2QGOgOu019665
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 12:24:42 -0400
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.187])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2QGNLHj007868
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 12:23:46 -0400
Received: by ti-out-0910.google.com with SMTP id 11so1310373tim.7
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 09:23:11 -0700 (PDT)
Message-ID: <9618a85a0803260923j26eb1052gb32d179d853e0887@mail.gmail.com>
Date: Thu, 27 Mar 2008 00:23:10 +0800
From: "kevin liu" <lwtbenben@gmail.com>
To: "Edward Ludlow" <eludlow@btinternet.com>
In-Reply-To: <47EA0E5B.2050604@btinternet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9618a85a0803251823x6962b6b2hfc2ceda8e6fbeb34@mail.gmail.com>
	<37219a840803251833l5103a709q116a323951cf95e5@mail.gmail.com>
	<47EA0E5B.2050604@btinternet.com>
Cc: linux-dvb@linuxtv.org, Linux and Kernel Video <video4linux-list@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [linux-dvb] PVR-250 on Ubuntu 7.10
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

For digital tv program, I suggest VLC.
mplayer can player digital tv, but not works well in my case.
once you tell VLC the frequency, the modulation and the subchannel
you can enjoy your program.

8VSB, QAM64 and QAM256 are tested in my ubuntu gutsy machine.
Good luck.

On 3/26/08, Edward Ludlow <eludlow@btinternet.com> wrote:
> Michael Krufky wrote:
>
> > The PVR250 is supported by the 'ivtv' driver, which is included by
> > default with Ubuntu Gutsy, the version that you are running.
>
> OK, thanks.
>
> In that case can one of you find fellows recommend an app to download
> that will let me use the card / driver?
>
> Ed
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
