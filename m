Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2RICb1a026601
	for <video4linux-list@redhat.com>; Thu, 27 Mar 2008 14:12:38 -0400
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.190])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2RICMi0005918
	for <video4linux-list@redhat.com>; Thu, 27 Mar 2008 14:12:22 -0400
Received: by ti-out-0910.google.com with SMTP id 11so1629507tim.7
	for <video4linux-list@redhat.com>; Thu, 27 Mar 2008 11:12:21 -0700 (PDT)
Message-ID: <37219a840803271112h571be84fu56a3bae24f406957@mail.gmail.com>
Date: Thu, 27 Mar 2008 14:12:20 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Edward Ludlow" <eludlow@btinternet.com>
In-Reply-To: <47EBE2E6.5090801@btinternet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47EBC75E.8040905@btinternet.com>
	<37219a840803271052h59c73235pa44932bef06388a6@mail.gmail.com>
	<37219a840803271054i174dbf1ck3953d8e78ef79ab9@mail.gmail.com>
	<47EBE2E6.5090801@btinternet.com>
Cc: video4linux-list@redhat.com
Subject: Re: Problems building v4l-dvb modules
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

On Thu, Mar 27, 2008 at 2:09 PM, Edward Ludlow <eludlow@btinternet.com> wrote:
> Michael Krufky wrote:
>
>  >>  Don't do *make load* (I'll edit the wiki entry)
>  >>
>  >>  Reboot your computer, and it should be OK.
>  >
>  >
>  > Ugh, it's too much to change and I don't have the time right now....
>  >
>  >
>  > If anybody is interested in fixing this wiki entry, please be aware
>  > that "make load" and "make reload" are *never* appropriate.  Just
>  > modprobe the module that you need.  Loading ALL modules is a terrible
>  > idea, and is only useful for debugging if you *really* know what
>  > you're doing.
>  >
>  > -Mike
>  >
>
>  Thanks Mike.
>
>  So do I stop after "make install" or do the "make unload" as per the wiki?
>
>  Is that it then?  The wiki then goes on to explain errors you may get -
>  and not a lot more.  What's the next step?
>
>  Please excuse the linux noobie questions!

If you are going to reboot, then you can do "make install" as the last
step before rebooting.

If you are going to modprobe the module that you need, then do "make
unload" beforehand, after doing "make install" first.

If you run into *any* problem, or dont know what module you need for
your device, then just reboot.

-Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
