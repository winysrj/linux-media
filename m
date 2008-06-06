Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m56DK95d021174
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 09:20:09 -0400
Received: from mailrelay005.isp.belgacom.be (mailrelay005.isp.belgacom.be
	[195.238.6.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m56DJvIl009737
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 09:19:57 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Fri, 6 Jun 2008 15:19:49 +0200
References: <484934FD.1080401@hhs.nl>
In-Reply-To: <484934FD.1080401@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806061519.50350.laurent.pinchart@skynet.be>
Cc: Elmar Kleijn <elmar_kleijn@hotmail.com>, spca50x-devs@lists.sourceforge.net,
	"need4weed@gmail.com" <need4weed@gmail.com>
Subject: Re: v4l1 compat wrapper version 0.3
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

Hi Hans,

On Friday 06 June 2008 15:00, Hans de Goede wrote:
> Hi All,
> 
> Ok, this one _really_ works with ekiga (and still works fine with spcaview)
> and also works with camorama with selected cams (not working on some cams
> due to a camorama bug).
> 
> Changes:
> * Don't allow multiple opens, in theory our code can handle it, but not all
>    v4l2 devices like it (ekiga does it and uvc doesn't like it).

Could you please elaborate ? Have you noticed a bug in the UVC driver ? It 
should support multiple opens.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
