Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3F0nT1F013192
	for <video4linux-list@redhat.com>; Mon, 14 Apr 2008 20:49:29 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.170])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3F0n7hA030771
	for <video4linux-list@redhat.com>; Mon, 14 Apr 2008 20:49:08 -0400
Received: by wf-out-1314.google.com with SMTP id 28so1763813wfc.6
	for <video4linux-list@redhat.com>; Mon, 14 Apr 2008 17:49:07 -0700 (PDT)
Date: Mon, 14 Apr 2008 17:44:16 -0700
From: Brandon Philips <brandon@ifup.org>
To: Martin Rubli <v4l2-lists@rubli.info>, linux1@rubli.info,
	Laurent Pinchart <laurent.pinchart@skynet.be>
Message-ID: <20080415004416.GA11071@plankton.ifup.org>
References: <op.t3hn72busxcvug@mrubli-nb.am.logitech.com>
	<20080213231244.GA15895@plankton.ifup.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213231244.GA15895@plankton.ifup.org>
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

On 15:12 Wed 13 Feb 2008, Brandon Philips wrote:
> On 01:01 Tue 18 Dec 2007, Martin Rubli wrote:
> > Thanks a lot for all your feedback and the constructive discussion and sorry 
> > for the delay while I was without Internet on the weekend. I'll try to 
> > summarize what we have so far:
> >
> > Write-only controls:
> >
> > It seems, everybody likes EACCES. Michael, maybe we could get some feedback 
> > from you on this? It would be nice to change the spec, so that EACCES also 
> > becomes the error for writing read-only controls--it seems appropriate. But 
> > if for some reason we can't change that we should probably make the 
> > write-only controls consistent and return EINVAL as well.
> >
> > Unusable controls due to device communication error:
> >
> > The easiest solution seems to be to set the V4L2_CTRL_FLAG_DISABLED flag as 
> > was suggested. The documentation currently says "permanently disabled and 
> > should be ignored by the application" which I think is exactly what applies 
> > to the situation. The V4L2_CTRL_FLAG_NEXT_CTRL would still be respected by 
> > drivers supporting the extended control enumeration, so no need to the spec 
> > is required. But I would still add a short paragraph about the first part as 
> > a guide for future implementations and a witness of this thread. ;-)
> >
> > As soon as everyone agrees on this, I will propose new patches. Let me know 
> > what you think ...
> 

Ping.  I never saw patches come across for this.

Thanks,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
