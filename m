Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mABHBYMd014321
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 12:11:34 -0500
Received: from mailrelay009.isp.belgacom.be (mailrelay009.isp.belgacom.be
	[195.238.6.176])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mABHBMeD014279
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 12:11:23 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Date: Tue, 11 Nov 2008 18:11:34 +0100
References: <1225963052-6657-1-git-send-email-cooloney@kernel.org>
	<200811091355.05074.laurent.pinchart@skynet.be>
	<8A42379416420646B9BFAC9682273B6D065BA534@limkexm3.ad.analog.com>
In-Reply-To: <8A42379416420646B9BFAC9682273B6D065BA534@limkexm3.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811111811.35098.laurent.pinchart@skynet.be>
Cc: Bryan Wu <cooloney@kernel.org>, linux-uvc-devel@lists.berlios.de,
	video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Video/UVC: Fix unaligned exceptions in uvc video driver.
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

On Monday 10 November 2008, Hennerich, Michael wrote:
> > -----Original Message-----
> > From: Laurent Pinchart [mailto:laurent.pinchart@skynet.be]
> > Sent: Sunday, November 09, 2008 1:55 PM
> > To: Bryan Wu
> > Cc: linux-uvc-devel@lists.berlios.de; video4linux-list@redhat.com;
> > linux-kernel@vger.kernel.org; Michael Hennerich
> > Subject: Re: [PATCH] Video/UVC: Fix unaligned exceptions in uvc video
> > driver.
> >
> > Hi Bryan, Michael,
> >
> > Thanks for the patch.
> >
> > On Thursday 06 November 2008, Bryan Wu wrote:
> > > From: Michael Hennerich <michael.hennerich@analog.com>
> > >
> > > buffer can be odd aligned on some NOMMU machine such as Blackfin
> >
> > The comment is a bit misleading. Buffers can be odd-aligned independently
> > off the machine type. The issue comes from machines that can't access
> > unaligned memory. Something like "Fix access to unaligned memory" would be
> > better.
[snip]

> > What about using get_unaligned_le16 and get_unaligned_le32 directly ?
> > Lines would be shorter and could be kept behind the 80 columns limit more
> > easily.
> > Tell me if you want to resubmit or if I should make the modification
> > myself (including the patch description).
>
> Laurent,
>
> Well - I just used the same style already used in various other places
> in the uvc driver. - Just wanted to be consistent.

No worries. get_unaligned_le{16|32} has been introduced in the kernel recently 
and I haven't updated the uvcvideo driver like I should have. I'll fix that.

> If you don't mind doing the changes (including the patch description),
> please go ahead.

Ok I'll fix and submit the patch.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
