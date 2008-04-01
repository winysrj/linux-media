Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m311s0df021160
	for <video4linux-list@redhat.com>; Mon, 31 Mar 2008 21:54:00 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.168])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m311rnZD027319
	for <video4linux-list@redhat.com>; Mon, 31 Mar 2008 21:53:50 -0400
Received: by wf-out-1314.google.com with SMTP id 28so2672418wfc.6
	for <video4linux-list@redhat.com>; Mon, 31 Mar 2008 18:53:49 -0700 (PDT)
Message-ID: <1dea8a6d0803311853h43b76501oab6ed6f1e10f07d9@mail.gmail.com>
Date: Tue, 1 Apr 2008 09:53:49 +0800
From: "Ben Caldwell" <benny.caldwell@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: alan@redhat.com, Nicholas.Magers@lands.nsw.gov.au
Subject: Re: Dvico Dual 4 card not working.
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

>
> ---------- Forwarded message ----------
> From: Alan Cox <alan@redhat.com>
> To: Nicholas Magers <Nicholas.Magers@lands.nsw.gov.au>
> Date: Mon, 31 Mar 2008 05:32:05 -0400
> Subject: Re: Dvico Dual 4 card not working.
> On Mon, Mar 31, 2008 at 02:22:15PM +1100, Nicholas Magers wrote:
> > Dual 4 card no longer works. I use it with Mythtv. It seems when I
> > updated my Nvidia graphics driver from Livna it had an effect. I am at
>
> Nvidia driver reports should go to Nvidia, only they have the source code
> so only they can help you
>
I have recently posted a similar problem with the dvico dual digital 4 card
on a Fedora 8 mythtv box. I don't think that this problem is due to the
nvidia driver.
My tuner card was working fine until I updated the to the latest v4l source
from the hg repository a week or two back and made new kernel modules, I
included traces in my post which can be seen in the list archives at the end
of march.
I reverted to a previous kernel that still has the kernel modules made from
an earlier version of the v4l source and everything works fine again. I am
not going to try compiling new modules for the working kernel as it could
leave me with no way at all to use my tuner card.

So tonight I will try building modules for my latest kernel (from Fedora
updates) from an older version of the v4l source and report back to this
list with the results.

- Ben Caldwell
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
