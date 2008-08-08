Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m789FI7O005159
	for <video4linux-list@redhat.com>; Fri, 8 Aug 2008 05:15:18 -0400
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m789F6S9014345
	for <video4linux-list@redhat.com>; Fri, 8 Aug 2008 05:15:07 -0400
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
In-Reply-To: <200808071237.47230.laurent.pinchart@skynet.be>
References: <489AD045.7030404@hhs.nl>
	<200808071237.47230.laurent.pinchart@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1
Date: Fri, 08 Aug 2008 11:10:36 +0200
Message-Id: <1218186636.1734.13.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Video 4 Linux <video4linux-list@redhat.com>
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

On Thu, 2008-08-07 at 12:37 +0200, Laurent Pinchart wrote:
> On Thursday 07 August 2008, Hans de Goede wrote:
> > Hi all,
> > 
> > I have this Philips SPC 200NC webcam, which has its sensor installed upside 
> > down and the sensor does not seem to support flipping the image. So I
> > believe the windows drivers fix this little problem in software.
> > 
> > I would like to add a flag somewhere to indicate this to userspace (and then 
> > add flipping code to libv4l).
> > 
> > I think the best place for this would the flags field of the v4l2_fmtdesc 
> > struct. Any other ideas / objections to this?
> 
> More often than sensors being mounted upside down in a webcam, what I've noticed frequently is webcam modules being mounted upside down in a laptop screen. There is no way that I'm aware of to check the module orientation based on the USB descriptors only. We will need a pure userspace solution.

Agree.

Having a horizontal or vertical inversion may exist in any webcam (and
tuner?), and may be the fact of wire inversion when assembling the
device. So, having a flag in the driver could not work with hardware
error.

If the sensor (or bridge?) may do H or V flip, we are done. If not, this
may be done by software, but in the userspace, i.e. at decoding time.

What I propose is to add a check of the control commands V4L2_CID_HFLIP
and V4L2_CID_VFLIP in the v4l library: if the driver does not have these
controls, the library silenctly adds them and handles their requests.
Then, at frame decoding time, the hflip and vflip may be given to the
decoding functions.

How do you feel it, Hans?

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
