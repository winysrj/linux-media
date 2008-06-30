Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5UF6gKc030048
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 11:06:42 -0400
Received: from mailrelay005.isp.belgacom.be (mailrelay005.isp.belgacom.be
	[195.238.6.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5UF6Taj007697
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 11:06:30 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: linux-uvc-devel@lists.berlios.de
Date: Mon, 30 Jun 2008 17:06:28 +0200
References: <486553B5.9070609@gmail.com> <4868CEB0.2020901@gmail.com>
In-Reply-To: <4868CEB0.2020901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806301706.28703.laurent.pinchart@skynet.be>
Cc: video4linux-list <video4linux-list@redhat.com>
Subject: Re: [Linux-uvc-devel] UVCVIDEO for 2.6.27 ?
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

Hi Maxim,

On Monday 30 June 2008, Maxim Levitsky wrote:
> Maxim Levitsky wrote:
> > Hello,
> >
> > Is UVC driver planned for inclusion in 2.6.27?
> >
> > As a new user of this driver, I confirm that it works almost perfectly.
> >
> > cheese/xawtv/kdetv/zapping/ekiga work fine.
> > tvtime complains about 'too short video frames'
> >
> > zapping crashes when trying to see settings dialog - almost for sure
> > unrelated bug, this application is not stable.
> >
> > kdetv hangs on exit, app buggy as well, but maybe it triggers some race
> > in videobuf, I have already triggered one race with this app once.
> >
> > The camera used to hang minutes after launch, but after I installed
> > latest svn of
> > uvcvideo the bug disappeared.
> >
> > Oh, almost forgot, I have Acer Crystal eye webcam integrated
> > in my new laptop. aspire 5720.
> >
> > Best regards,
> >     Maxim Levitsky
>
> Any news?

I've just submitted the Linux UVC driver to the video4linux and linux-usb 
mailing lists. Unless people report blocking issues it should get into 
2.6.27.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
