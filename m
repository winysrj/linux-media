Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA6NvLni026225
	for <video4linux-list@redhat.com>; Thu, 6 Nov 2008 18:57:22 -0500
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.188])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA6Nrg9W011150
	for <video4linux-list@redhat.com>; Thu, 6 Nov 2008 18:53:43 -0500
Received: by fk-out-0910.google.com with SMTP id e30so1010072fke.3
	for <video4linux-list@redhat.com>; Thu, 06 Nov 2008 15:53:42 -0800 (PST)
Message-ID: <30353c3d0811061553h4c1a77e0t597bd394fa0ebdf1@mail.gmail.com>
Date: Thu, 6 Nov 2008 18:53:42 -0500
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Carl Karsten" <carl@personnelware.com>
In-Reply-To: <491339D9.2010504@personnelware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491339D9.2010504@personnelware.com>
Cc: video4linux-list@redhat.com
Subject: Re: weeding out v4l ver 1 stuff
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

On Thu, Nov 6, 2008 at 1:39 PM, Carl Karsten <carl@personnelware.com> wrote:
> Given v4l version 1 is being dropped in December 08, we should remove stuff that
> targets that api, right?
>
> For instance:
>
> http://linuxtv.org/hg/v4l-dvb/file/b45ffc93fb82/v4l2-apps/test/v4lgrab.c
>
>      94 #ifdef CONFIG_VIDEO_V4L1_COMPAT
>      194 #else
>
>      195       fprintf(stderr, "V4L1 API is not configured!\n");
>
> I'll let someone else figure out if the whole file should be removed, or if it
> has some value to v2.
>
> And assuming someone agrees we should week out v1 stuff, where is the right
> place to log this too?  http://bugzilla.kernel.org does not seem right.
>
> Carl K
>

With v4l1 going away, it would be nice to convert any drivers still
using the v4l1 interface to v4l2. Drivers using usbvideo spring to
mind. I've mentioned in the past, I've started a rewrite of ibmcam
over to the v4l2 interface but I currently don't have much time to
work on it and could use some assistance from the community. While
Mauro suggested it be written against the gspca framework, I hesitate
to do so since gspca does it's own memory management and will probably
become somewhat obsolete once the new media framework is put together.
If anyone is interested in helping, I'll happily set up a public git
repository for contributions.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
