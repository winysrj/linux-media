Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m26MOUBs001728
	for <video4linux-list@redhat.com>; Thu, 6 Mar 2008 17:24:30 -0500
Received: from mailrelay001.isp.belgacom.be (mailrelay001.isp.belgacom.be
	[195.238.6.51])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m26MNvss006149
	for <video4linux-list@redhat.com>; Thu, 6 Mar 2008 17:23:57 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Thierry Merle <thierry.merle@free.fr>
Date: Thu, 6 Mar 2008 23:30:45 +0100
References: <1202916257-10421-1-git-send-email-jirislaby@gmail.com>
	<200803042350.55996.laurent.pinchart@skynet.be>
	<47D05022.2070207@free.fr>
In-Reply-To: <47D05022.2070207@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200803062330.46622.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [RFC 1/1] v4l2_extension: helper daemon commands passing
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

Hi Thierry,

On Thursday 06 March 2008, Thierry Merle wrote:
> Laurent Pinchart a écrit :
> > On Monday 03 March 2008, Thierry Merle wrote:
> >> Jiri Slaby a écrit :
> >>> Here I would like to know if the the commands passing interface to the
> >>> helper daemon introduced in this patch is OK, or alternatively propose
> >>> some other idea ;).
> >>
> >> I have committed your patch as is
> >> http://linuxtv.org/hg/~tmerle/v4l2_extension/
> >> Now will begin a driver enhancement. I will do that on usbvision because
> >> I know it.
> >> The first step will be to extend the supported video formats (2
> >> sub-steps: 1-just enable hardware pixel format capabilities in
> >> usbvision, 2-allow the helper daemon to extend usbvision pixel format
> >> capabilities).
> >
> > I haven't followed v4l2_extension development closely, so I'm a bit
> > puzzled by this. Are the modifications you made to the usbvision module
> > for testing purpose only ? My understanding of v4l2_extension is that it
> > should work completely transparently and must not require any change to
> > v4l2 drivers.
>
> In fact I meant remove from usbvision the software decompression
> algorithm in order to put it in the helper daemon.
> I will restrict the list of supported pixel formats to the ones that the
> hardware can output without software decompression.

That's the whole point of having userspace decompression. Those changes are 
perfectly ok.

> I hope that the sole modification for a standard base driver will be the
> add of v4l2ext_register/v4l2ext_unregister calls.

I'm not very happy with that. Couldn't this be done automatically at the 
videodev level ? As "v4l2ext" is a temporary solution, I'd hate seeing all 
drivers being modified. This should be transparent to the driver itself, 
otherwise we will have to modify them back again when v4l2ext will be 
replaced by a real userspace library.

Cheers,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
