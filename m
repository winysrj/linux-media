Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2RHqEc0007608
	for <video4linux-list@redhat.com>; Thu, 27 Mar 2008 13:52:14 -0400
Received: from gv-out-0910.google.com (gv-out-0910.google.com [216.239.58.187])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2RHq19K020590
	for <video4linux-list@redhat.com>; Thu, 27 Mar 2008 13:52:02 -0400
Received: by gv-out-0910.google.com with SMTP id l14so909310gvf.13
	for <video4linux-list@redhat.com>; Thu, 27 Mar 2008 10:52:01 -0700 (PDT)
Message-ID: <37219a840803271052h59c73235pa44932bef06388a6@mail.gmail.com>
Date: Thu, 27 Mar 2008 13:52:00 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Edward Ludlow" <eludlow@btinternet.com>
In-Reply-To: <47EBC75E.8040905@btinternet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47EBC75E.8040905@btinternet.com>
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

On Thu, Mar 27, 2008 at 12:12 PM, Edward Ludlow <eludlow@btinternet.com> wrote:
> I am trying to follow the guide at
>  http://linuxtv.org/v4lwiki/index.php/How_to_build_from_Mercurial to get
>  my PVR-250 card going.
>
>  I get as far as "make load" to insert the modules into the kernel, but
>  then it hangs at /sbin/insmod ./b2c2-flexcop-pci.ko
>
>  Tried there times now with the same result.
>
>  Any ideas?


Don't do *make load* (I'll edit the wiki entry)

Reboot your computer, and it should be OK.

-Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
