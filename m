Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:56292 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbZCISwg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 14:52:36 -0400
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: DongSoo Kim <dongsoo.kim@gmail.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Toivonen Tuukka Olli Artturi <tuukka.o.toivonen@nokia.com>,
	=?iso-8859-1?Q?Koskip=E4=E4_Antti_Jussi_Petteri?=
	<antti.koskipaa@nokia.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Alexey Klimov <klimov.linux@gmail.com>
Date: Mon, 9 Mar 2009 13:52:21 -0500
Subject: RE: OMAP3 ISP and camera drivers (update)
Message-ID: <A24693684029E5489D1D202277BE89442E40F5B2@dlee02.ent.ti.com>
In-Reply-To: <49B141F6.6040301@maxwell.research.nokia.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Sakari Ailus [mailto:sakari.ailus@maxwell.research.nokia.com]
> Sent: Friday, March 06, 2009 9:32 AM
> To: linux-media@vger.kernel.org
> Cc: Aguirre Rodriguez, Sergio Alberto; DongSoo Kim; Hiremath, Vaibhav;
> Toivonen Tuukka Olli Artturi; Koskipää Antti Jussi Petteri; Cohen David
> Abraham; Alexey Klimov
> Subject: OMAP3 ISP and camera drivers (update)
> 
> Hi,
> 
> I've updated the patchset in Gitorious.
> 
> <URL:http://www.gitorious.org/projects/omap3camera>
> 
> Changes include
> 
> - Power management support. ISP suspend/resume should work now.
> 
> - Reindented and cleaned up everything. There are still some warnings
> from checkpatch.pl from the CSI2 code.
> 
> - Fix for crash in device registration, posted to list already. (Thanks,
> Vaibhav, Alexey!)
> 
> - LSC errors should be handled properly now.

Hi Sakari,

Doing a pull like you suggested in past release:
 
$ git pull http://git.gitorious.org/omap3camera/mainline.git v4l \
   iommu omap3camera base

Brings the same code than before...

I see that omap3isp branch is updated on gitorious, but trying to pull that branch gives merge errors.

Regards,
Sergio

