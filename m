Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m826O1wo029787
	for <video4linux-list@redhat.com>; Tue, 2 Sep 2008 02:24:01 -0400
Received: from smtp-vbr15.xs4all.nl (smtp-vbr15.xs4all.nl [194.109.24.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m826NnuF011648
	for <video4linux-list@redhat.com>; Tue, 2 Sep 2008 02:23:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Tue, 2 Sep 2008 08:23:48 +0200
References: <A24693684029E5489D1D202277BE89441191E347@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89441191E347@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809020823.48163.hverkuil@xs4all.nl>
Cc: 
Subject: Re: [PATCH 15/15] OMAP3 camera driver: OMAP34XXCAM: Add Sensors
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
