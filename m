Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBJ88ih4006365
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 03:08:44 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.224])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBJ880UB020177
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 03:08:00 -0500
Received: by rv-out-0506.google.com with SMTP id f6so900004rvb.51
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 00:07:59 -0800 (PST)
Message-ID: <aec7e5c30812190007j411489e0k2af01b9821dc7d60@mail.gmail.com>
Date: Fri, 19 Dec 2008 17:07:59 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0812180949460.3963@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0812180949460.3963@axis700.grange>
Cc: video4linux-list@redhat.com
Subject: Re: partial linux kernel repository and backwards compatibility for
	platform-based video devices
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

Hi Guennadi,

On Thu, Dec 18, 2008 at 6:16 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Could we maybe come up with some adjustment / extension to the current
> development model to make the process more simple? This would mean either
> skipping the hg stage completely, or at least removing all
> backwards-compatibility code from platform-based drivers?

I can't say that I have any interest in the hg repository. Actually, I
wasn't aware of any backwards-compatibility code. =)

I usually stick to the arch git tree (superh in my case) and do work
there. I may do linux-next if needed. If there are many outstanding
patches that I depend on then I may cherry pick those patches or get a
patch series from a friendly maintainer and work from there. =)

Cheers,

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
