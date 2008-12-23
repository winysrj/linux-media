Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBNBZYWk028442
	for <video4linux-list@redhat.com>; Tue, 23 Dec 2008 06:35:34 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBNBZH6d019734
	for <video4linux-list@redhat.com>; Tue, 23 Dec 2008 06:35:18 -0500
Date: Tue, 23 Dec 2008 12:35:24 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0812231225520.5188@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: 
Subject: [PATCH 0/3 v2] soc-camera: camera host driver for i.MX3x SoCs
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

This patch series is based on my earlier patches for the IDMAC engine on 
i.MX3x (v6), and for soc-camera. Tested with Bayer and monochrome cameras.

Changes since v1: rebased on new dmaengine and ipu_idmac, as well as 
updated to the top of the current soc-camera stack as of my pull-request 
of 18.12. No significant functional changes otherwise.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.

DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
