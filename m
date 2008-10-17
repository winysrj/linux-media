Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9HFMRkf030029
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 11:22:28 -0400
Received: from mail11b.verio-web.com (mail11b.verio-web.com [204.202.242.87])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9HFLnZe023031
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 11:22:00 -0400
Received: from mx63.stngva01.us.mxservers.net (204.202.242.133)
	by mail11b.verio-web.com (RS ver 1.0.95vs) with SMTP id 4-0877866909
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 11:21:49 -0400 (EDT)
From: Pete <pete@sensoray.com>
To: video4linux-list@redhat.com
Content-Type: text/plain
Date: Fri, 17 Oct 2008 08:21:51 -0700
Message-Id: <1224256911.6327.11.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Greg KH <greg@kroah.com>, Dean Anderson <dean@sensoray.com>
Subject: go7007 development
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

Hello,

I am working on adding the Sensoray 2250 to the go7007 staging tree,
starting from GregKH's staging patch here:
http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
gregkh-05-staging-2.6.27.patch   

In particular, we are stuck how to change the MPEG format with standard 
IOCTL calls.  In particular, this comment in the driver go7007.h below 
needs explanation:

/* DEPRECATED -- use V4L2_PIX_FMT_MPEG and then call GO7007IOC_S_MPEG_PARAMS
 * to select between MPEG1, MPEG2, and MPEG4 */
#define V4L2_PIX_FMT_MPEG4     v4l2_fourcc('M','P','G','4') /* MPEG4         */

The existing driver, for backward-compatibility , allowed
V4L2_PIX_FMT_MPEG4 to be used for v4l2_format.pixelformat with
VIDIOC_S_FMT.

GO7007IOC_S_MPEG_PARAMS is a custom ioctl call and we would rather have
this done through v4l2 calls. We also can't seem to find where MPEG1,
MPEG2, and MPEG4 elementary streams are defined in the V4L2 API.  We
checked other drivers, but could not find anything.  The closest thing
we found was the V4L2_CID_MPEG_STREAM_TYPE control, but the enums do not
define elementary streams nor MPEG4.

Your advice is appreciated.

Thanks.
-- 
Pete Eberlein
Sensoray Co., Inc.
Email: pete@sensoray.com
http://www.sensoray.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
