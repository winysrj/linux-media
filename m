Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27052 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935989Ab3DIG3P (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Apr 2013 02:29:15 -0400
Date: Tue, 9 Apr 2013 09:28:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Bill Pemberton <wfp5p@virginia.edu>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] dt3155v4l: unlock on error path
Message-ID: <20130409062850.GI23861@mwanda>
References: <20130409051540.GA1516@longonot.mountain>
 <alpine.DEB.2.02.1304090719480.2019@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1304090719480.2019@hadrien>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 09, 2013 at 07:20:19AM +0200, Julia Lawall wrote:
> On Tue, 9 Apr 2013, Dan Carpenter wrote:
> 
> > We should unlock here and do some cleanup before returning.
> >
> > We can't actually hit this return path with the current code, so this
> > patch is a basically a cleanup and doesn't change how the code works.
> 
> Why keep the return path then?  If the code is there, someone reading it
> could naturally assume that it is necessary.

There are sanity checks in vb2_queue_init() but this caller always
passes a sane "pd->q" pointer so the sanity checks always succeed.
That might change in later code.  ;)

I like the code as it is, but I just wanted to note that the impact
of this patch is zero in case anyone was backporting fixes.

regards,
dan carpenter

