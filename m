Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB59dfXs007033
	for <video4linux-list@redhat.com>; Fri, 5 Dec 2008 04:39:41 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.232])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB59cU3e007247
	for <video4linux-list@redhat.com>; Fri, 5 Dec 2008 04:39:11 -0500
Received: by rv-out-0506.google.com with SMTP id f6so4855976rvb.51
	for <video4linux-list@redhat.com>; Fri, 05 Dec 2008 01:38:29 -0800 (PST)
Message-ID: <f17812d70812050138vafd5774od491024c89f1558e@mail.gmail.com>
Date: Fri, 5 Dec 2008 17:38:29 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0812050944440.4162@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f17812d70811271731s1473f23cn81ca782172acc1cd@mail.gmail.com>
	<Pine.LNX.4.64.0811280807120.3990@axis700.grange>
	<f17812d70811272356iddc5207rb2bb99cc7c88dcac@mail.gmail.com>
	<f17812d70811272357t5fb043e3oee6bd9a269f4efaa@mail.gmail.com>
	<Pine.LNX.4.64.0812050944440.4162@axis700.grange>
Cc: video4linux-list@redhat.com,
	ARM Linux <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: Fwd: [PATCH 2/2] V4L/DVB: pxa-camera: use memory mapped IO
	access for camera (QCI) registers
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

On Fri, Dec 5, 2008 at 4:46 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi Eric,
>
> On Fri, 28 Nov 2008, Eric Miao wrote:
>
> ...
>
>> And again, I'm OK if you can do a trivial merge and I expect
>> the final patch will be a bit different than this one.
>
> below is a version of your patch that I'm going to push upstream. Just
> removed superfluous parenthesis and one trailing tab. Please confirm that
> that is ok with you.
>

Looks fine, thanks.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
