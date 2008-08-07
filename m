Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m77Ac5Rh019873
	for <video4linux-list@redhat.com>; Thu, 7 Aug 2008 06:38:05 -0400
Received: from mailrelay005.isp.belgacom.be (mailrelay005.isp.belgacom.be
	[195.238.6.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m77AbrZq024831
	for <video4linux-list@redhat.com>; Thu, 7 Aug 2008 06:37:54 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Thu, 7 Aug 2008 12:37:46 +0200
References: <489AD045.7030404@hhs.nl>
In-Reply-To: <489AD045.7030404@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808071237.47230.laurent.pinchart@skynet.be>
Cc: 
Subject: Re: RFC: adding a flag to indicate a webcam sensor is installed
	upside down
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

On Thursday 07 August 2008, Hans de Goede wrote:
> Hi all,
> 
> I have this Philips SPC 200NC webcam, which has its sensor installed upside 
> down and the sensor does not seem to support flipping the image. So I
> believe the windows drivers fix this little problem in software.
> 
> I would like to add a flag somewhere to indicate this to userspace (and then 
> add flipping code to libv4l).
> 
> I think the best place for this would the flags field of the v4l2_fmtdesc 
> struct. Any other ideas / objections to this?

More often than sensors being mounted upside down in a webcam, what I've noticed frequently is webcam modules being mounted upside down in a laptop screen. There is no way that I'm aware of to check the module orientation based on the USB descriptors only. We will need a pure userspace solution.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
