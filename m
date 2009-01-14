Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:52423 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbZANOze convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2009 09:55:34 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	"Nagalla, Hari" <hnagalla@ti.com>
Date: Wed, 14 Jan 2009 08:55:08 -0600
Subject: RE: Patch series in Tarball submitted (RE: [REVIEW PATCH 00/14]
 OMAP3 camera + ISP + MT9P012 sensor driver v2)
Message-ID: <A24693684029E5489D1D202277BE8944164DFC34@dlee02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739403ECF70CEB@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Hiremath, Vaibhav
> Sent: Wednesday, January 14, 2009 8:51 AM

<snip>

> [Hiremath, Vaibhav] I tried to build camera driver as module and got
> following error -
> 
> ERROR: "ispmmu_get_mapeable_space" [drivers/media/video/omap34xxcam.ko]
> undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> You have missed to export this symbol, please correct in next version of
> patches.
> 

Oops, good catch. Thanks, I'll correct that. No problem.

Regards,
Sergio
