Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBM9q5t6021777
	for <video4linux-list@redhat.com>; Mon, 22 Dec 2008 04:52:05 -0500
Received: from mailrelay008.isp.belgacom.be (mailrelay008.isp.belgacom.be
	[195.238.6.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBM9otcr006333
	for <video4linux-list@redhat.com>; Mon, 22 Dec 2008 04:50:55 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 22 Dec 2008 10:50:56 +0100
References: <1229889214.3050.8.camel@johannes>
In-Reply-To: <1229889214.3050.8.camel@johannes>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_BM2TJ7sRyP4yMG0"
Message-Id: <200812221050.57039.laurent.pinchart@skynet.be>
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

--Boundary-00=_BM2TJ7sRyP4yMG0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Johannes,

On Sunday 21 December 2008, Johannes Berg wrote:
> On my new macbook (unibody):
>
> [ 2309.876354] uvcvideo: unknown event type 128.
> [ 2310.080360] uvcvideo: unknown event type 128.
> [ 2310.280361] uvcvideo: unknown event type 86.
> [ 2310.480362] uvcvideo: unknown event type 86.
> [ 2310.680360] uvcvideo: unknown event type 42.
> [ 2310.884357] uvcvideo: unknown event type 86.
> [ 2311.084355] uvcvideo: unknown event type 86.
> [ 2311.288227] uvcvideo: unknown event type 86.
> [ 2311.484355] uvcvideo: unknown event type 170.
>
> And lots of them, as long as the camera is active. 2.6.28-rc8.

Could you please try the attached patched ?

Best regards,

Laurent Pinchart

--Boundary-00=_BM2TJ7sRyP4yMG0
Content-Type: text/x-diff;
  charset="utf-8";
  name="isight.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="isight.patch"

diff -r 7ec490a64a56 linux/drivers/media/video/uvc/uvc_driver.c
--- a/linux/drivers/media/video/uvc/uvc_driver.c	Tue Dec 16 14:41:57 2008 +0100
+++ b/linux/drivers/media/video/uvc/uvc_driver.c	Mon Dec 22 10:50:29 2008 +0100
@@ -1147,8 +1147,13 @@
 		buffer += buffer[0];
 	}
 
-	/* Check if the optional status endpoint is present. */
-	if (alts->desc.bNumEndpoints == 1) {
+	/* Check if the optional status endpoint is present. Built-in iSight
+	 * webcams have an interrupt endpoint but spit proprietary data that
+	 * don't conform to the UVC status endpoint messages. Don't try to
+	 * handle the interrupt endpoint for those cameras.
+	 */
+	if (alts->desc.bNumEndpoints == 1 &&
+	    !(dev->quirks & UVC_QUIRK_BUILTIN_ISIGHT)) {
 		struct usb_host_endpoint *ep = &alts->endpoint[0];
 		struct usb_endpoint_descriptor *desc = &ep->desc;
 

--Boundary-00=_BM2TJ7sRyP4yMG0
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--Boundary-00=_BM2TJ7sRyP4yMG0--
