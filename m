Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9K0CMWh031655
	for <video4linux-list@redhat.com>; Sun, 19 Oct 2008 20:12:22 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.155])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9K0BauD028565
	for <video4linux-list@redhat.com>; Sun, 19 Oct 2008 20:11:36 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1231694fga.7
	for <video4linux-list@redhat.com>; Sun, 19 Oct 2008 17:11:35 -0700 (PDT)
Message-ID: <30353c3d0810191711y7be7c7f2i83d6a3a8ff46b6a0@mail.gmail.com>
Date: Sun, 19 Oct 2008 20:11:35 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Alexey Klimov" <klimov.linux@gmail.com>
In-Reply-To: <208cbae30810190758x2f0c70f5m5856ce9ea84b26ae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <208cbae30810161146g69d5d04dq4539de378d2dba7f@mail.gmail.com>
	<208cbae30810190758x2f0c70f5m5856ce9ea84b26ae@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: [patch] radio-mr800: remove warn- and err- messages
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

2008/10/19 Alexey Klimov <klimov.linux@gmail.com>:
> Hello, all
> Thanks for input.
> This is re-created version of patch. What do you think about this version ?
>
> radio-mr800: remove warn-, err- and info-messages
>
> Patch removes warn(), err() and info() statements in
> radio/radio-mr800.c, and place dev_warn, dev_info in right places.
> Printk changed on pr_info and pr_err macro.
>
> Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

In the future, please inline the patch as well so it's easier to
review and comment on. That said, it looks better than the last.
Although, I'm still a bit undecided about this patch as it includes
the module/driver name directly in some of the dev_warn calls. I
understand why this was done due to how dev_warn behaves, but I think
the name should either be defined in a macro or removed entirely. It
would be nice to hear what others think about this.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
