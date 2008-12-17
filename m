Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBHEXCwP020206
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 09:33:12 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBHEWtuN003654
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 09:32:56 -0500
Date: Wed, 17 Dec 2008 15:33:05 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michael Krufky <mkrufky@linuxtv.org>
In-Reply-To: <49490A4B.90609@linuxtv.org>
Message-ID: <Pine.LNX.4.64.0812171527140.5465@axis700.grange>
References: <20080205012451.GA31004@plankton.ifup.org>
	<Pine.LNX.4.64.0802050815200.3863@axis700.grange>
	<20080205080038.GB8232@plankton.ifup.org>
	<20080205102409.4b7acb01@gaivota>
	<20080213202055.GA26352@plankton.ifup.org>
	<20080214174602.4ed91987@gaivota>
	<Pine.LNX.4.64.0812171444420.5465@axis700.grange>
	<49490A4B.90609@linuxtv.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, v4lm <v4l-dvb-maintainer@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] Moving to git for v4l-dvb
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

On Wed, 17 Dec 2008, Michael Krufky wrote:

> Please take a look at one of the hg patches within the repository:
> 
> http://linuxtv.org/hg/v4l-dvb/raw-rev/3cc7daa31234
> 
> This patch is the same type of output that you would get from using "hg export
> 3cc7daa31234"
> 
> Notice the "From:" line -- that line is used to indicate author.
> 
> Notice the "User" line (line 2) -- that line is used to indicate committer.
> 
> Does that help to clear it up for you?

Maybe... So, if I take a patch produced by git-format-patch, and add a 
line at the top like

# User myname <myaddress@myprovider.com>

and then "hg import" this patch, then this line will be used by hg for the 
"user" field and the "From: " line that git produced will be kept... emn 
no, it will not, because it belongs to the header. But ok, I think, I know 
what should be done. I'll just move the "From: " from the header to below 
the "Subject: ", and, optionally add one more "# User " or "From: " for 
the user... uhhh...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
