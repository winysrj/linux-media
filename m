Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBMDGNf7011941
	for <video4linux-list@redhat.com>; Mon, 22 Dec 2008 08:16:23 -0500
Received: from mailrelay008.isp.belgacom.be (mailrelay008.isp.belgacom.be
	[195.238.6.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBMDFe9F015096
	for <video4linux-list@redhat.com>; Mon, 22 Dec 2008 08:15:42 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 22 Dec 2008 14:15:42 +0100
References: <1229889214.3050.8.camel@johannes>
	<200812221050.57039.laurent.pinchart@skynet.be>
	<569cef5eecd374b8343a566c1e65a4a3@localhost>
In-Reply-To: <569cef5eecd374b8343a566c1e65a4a3@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812221415.42804.laurent.pinchart@skynet.be>
Cc: video4linux-list <video4linux-list@redhat.com>, lkml@vger.kernel.org
Subject: Re: uvcvideo prints lots of "unknown event"
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

Hi Johannes,

On Monday 22 December 2008, Johannes Berg wrote:
> On Mon, 22 Dec 2008 10:50:56 +0100, Laurent Pinchart
>
> <laurent.pinchart@skynet.be> wrote:
> > Could you please try the attached patched ?
>
> Ok, that looks like it'll fix it (not tested yet), do you think there would
> be any value in reverse engineering the proprietary status protocol?

That's hard to tell, as I have no idea what the camera outputs :-)

> Should be fairly simple, if you think it has some useful information I'll
> take a look.

If you have time to take a look please do. I'm quite curious to know what the 
interrupt endpoint is used for. Whether or not the UVC driver will use the 
data will obviously depend on their usefulness.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
