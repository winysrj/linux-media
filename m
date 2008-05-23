Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4NJBjHc014484
	for <video4linux-list@redhat.com>; Fri, 23 May 2008 15:11:45 -0400
Received: from lxorguk.ukuu.org.uk (earthlight.etchedpixels.co.uk
	[81.2.110.250])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4NJBXgm019145
	for <video4linux-list@redhat.com>; Fri, 23 May 2008 15:11:33 -0400
Date: Fri, 23 May 2008 19:58:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: corbet@lwn.net (Jonathan Corbet)
Message-ID: <20080523195822.5c6fe260@core>
In-Reply-To: <15168.1211558968@vena.lwn.net>
References: <20080523163956.6e93746c@core>
	<15168.1211558968@vena.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
	mchehab@infradead.org
Subject: Re: [PATCH] video4linux: Push down the BKL
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

> BTW, drop me a pointer if you'd like this series pulled into the
> ever-growing bkl-removal tree.

Its a single big patch right now and I need to split it up further and
tidy it, plus see what the maintainers take and think. Once I've done
that I'd be in favour of actually patching ->ioctl out of the bkl-removal
tree and letting people fix the other architectures by neccessity ;)

Alan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
