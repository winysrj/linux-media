Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m89J8IfZ031291
	for <video4linux-list@redhat.com>; Tue, 9 Sep 2008 15:08:19 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m89J7g3e020287
	for <video4linux-list@redhat.com>; Tue, 9 Sep 2008 15:07:43 -0400
Date: Tue, 9 Sep 2008 21:07:27 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Ming Liu <mliu@migmasys.com>
Message-ID: <20080909190727.GA2184@daniel.bse>
References: <20080908160012.574456184D5@hormel.redhat.com>
	<48C5948D.5030504@migmasys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C5948D.5030504@migmasys.com>
Cc: video4linux-list@redhat.com
Subject: Re: a multichannel capture problem
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

On Mon, Sep 08, 2008 at 05:09:33PM -0400, Ming Liu wrote:
> 1. Is there any example codes that I can follow to estimate the frame 
> rates using switch channel approach?

Motion (http://www.lavrsen.dk/twiki/bin/view/Motion/WebHome ) is said
to support multiple inputs of one card "at the same time".
I never tried it, though.

> Can I do this by using standard V4L2 APIs, or I will need to deal with
> the driver?

You can do this with V4L2.

Some time ago I made some experiments changing the input at random times
using direct hardware access while capturing. IIRC the chip will skip at
least one complete frame before it continues to capture. 

> 2. If I choose a multi-chip PCI based video capture card, is there any 
> limit from the bandwidth?

Of course. A few days ago we had a discussion about bandwidth issues when
using 5+ bt8xx cards to capture 640x480 in YUV 4:2:0. When there are
other chips using the PCI bus (f.ex. the harddisk controller), the limit
will be lower.

> Are there any sample codes available?

Motion can handle multiple devices at the same time as well.

> 3. In the program point of view, is there difference between using 
> multi-chip card and several single chip cards?

No.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
