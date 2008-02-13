Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1DNDJOu031150
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 18:13:19 -0500
Received: from rv-out-0910.google.com (rv-out-0910.google.com [209.85.198.188])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1DNCvN3006090
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 18:12:57 -0500
Received: by rv-out-0910.google.com with SMTP id k15so113621rvb.51
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 15:12:56 -0800 (PST)
Date: Wed, 13 Feb 2008 15:12:44 -0800
From: Brandon Philips <brandon@ifup.org>
To: Martin Rubli <v4l2-lists@rubli.info>
Message-ID: <20080213231244.GA15895@plankton.ifup.org>
References: <op.t3hn72busxcvug@mrubli-nb.am.logitech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.t3hn72busxcvug@mrubli-nb.am.logitech.com>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: [PATCH] Support for write-only controls
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

On 01:01 Tue 18 Dec 2007, Martin Rubli wrote:
> Thanks a lot for all your feedback and the constructive discussion and sorry 
> for the delay while I was without Internet on the weekend. I'll try to 
> summarize what we have so far:
>
> Write-only controls:
>
> It seems, everybody likes EACCES. Michael, maybe we could get some feedback 
> from you on this? It would be nice to change the spec, so that EACCES also 
> becomes the error for writing read-only controls--it seems appropriate. But 
> if for some reason we can't change that we should probably make the 
> write-only controls consistent and return EINVAL as well.
>
> Unusable controls due to device communication error:
>
> The easiest solution seems to be to set the V4L2_CTRL_FLAG_DISABLED flag as 
> was suggested. The documentation currently says "permanently disabled and 
> should be ignored by the application" which I think is exactly what applies 
> to the situation. The V4L2_CTRL_FLAG_NEXT_CTRL would still be respected by 
> drivers supporting the extended control enumeration, so no need to the spec 
> is required. But I would still add a short paragraph about the first part as 
> a guide for future implementations and a witness of this thread. ;-)
>
> As soon as everyone agrees on this, I will propose new patches. Let me know 
> what you think ...

Did you ever send out patches on this?  I can't seem to find them.

Cheers,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
