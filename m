Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m24MieX0022765
	for <video4linux-list@redhat.com>; Tue, 4 Mar 2008 17:44:40 -0500
Received: from mailrelay003.isp.belgacom.be (mailrelay003.isp.belgacom.be
	[195.238.6.53])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m24Mi7pS002325
	for <video4linux-list@redhat.com>; Tue, 4 Mar 2008 17:44:07 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Tue, 4 Mar 2008 23:50:55 +0100
References: <1202916257-10421-1-git-send-email-jirislaby@gmail.com>
	<47CC365B.8010003@free.fr>
In-Reply-To: <47CC365B.8010003@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200803042350.55996.laurent.pinchart@skynet.be>
Cc: Jiri Slaby <jirislaby@gmail.com>
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

On Monday 03 March 2008, Thierry Merle wrote:
> Jiri Slaby a écrit :
> > Here I would like to know if the the commands passing interface to the
> > helper daemon introduced in this patch is OK, or alternatively propose
> > some other idea ;).
>
> I have committed your patch as is
> http://linuxtv.org/hg/~tmerle/v4l2_extension/
> Now will begin a driver enhancement. I will do that on usbvision because
> I know it.
> The first step will be to extend the supported video formats (2
> sub-steps: 1-just enable hardware pixel format capabilities in
> usbvision, 2-allow the helper daemon to extend usbvision pixel format
> capabilities).

I haven't followed v4l2_extension development closely, so I'm a bit puzzled by 
this. Are the modifications you made to the usbvision module for testing 
purpose only ? My understanding of v4l2_extension is that it should work 
completely transparently and must not require any change to v4l2 drivers.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
