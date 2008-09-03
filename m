Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m83GnpeW009672
	for <video4linux-list@redhat.com>; Wed, 3 Sep 2008 12:49:51 -0400
Received: from devils.ext.ti.com (devils.ext.ti.com [198.47.26.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m83GndgB023767
	for <video4linux-list@redhat.com>; Wed, 3 Sep 2008 12:49:39 -0400
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, "video4linux-list@redhat.com"
	<video4linux-list@redhat.com>
Date: Wed, 3 Sep 2008 11:49:32 -0500
Message-ID: <A24693684029E5489D1D202277BE894411A07DFA@dlee02.ent.ti.com>
In-Reply-To: <200809020823.48163.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: 
Subject: RE: [PATCH 15/15] OMAP3 camera driver: OMAP34XXCAM: Add Sensors
 Support.
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

Hans,

This file hasn't yet been merged into Linus tree, these patches are made for applying on top of linux-omap tree, that's why you don't find it there.

We came up to the conclusion that  we will only send you all the needed (and reworked with all the comments, of course) v4l2 changes for omap3 camera operation, and send the remaining ones, which are omap-specific, to the linux-omap list.

We'll keep you updated on this between this week and next one.

I appreciate your time. Thanks.

Regards,
Sergio

-----Original Message-----
From: Hans Verkuil [mailto:hverkuil@xs4all.nl] 
Sent: Tuesday, September 02, 2008 1:24 AM
To: video4linux-list@redhat.com
Cc: Aguirre Rodriguez, Sergio Alberto
Subject: Re: [PATCH 15/15] OMAP3 camera driver: OMAP34XXCAM: Add Sensors Support.

On Saturday 30 August 2008 01:44:27 Aguirre Rodriguez, Sergio Alberto 
wrote:
> From: Sergio Aguirre <saaguirre@ti.com>
> 
> OMAP34XX: CAM: Add Sensors Support
> 
> This adds support in OMAP34xx SDP board file for Sensor and Lens
> driver.
> 
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  arch/arm/mach-omap2/board-3430sdp.c |  228 
++++++++++++++++++++++++++++++++++++
>  1 file changed, 228 insertions(+)

Can you mail the original board-3430sdp.c file? I cannot find this file 
in the linux kernel (looked in the latest git tree from Linus).

Regards,

	Hans


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
