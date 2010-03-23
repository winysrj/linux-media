Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:35443 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134Ab0CWOoj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Mar 2010 10:44:39 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 23 Mar 2010 20:14:33 +0530
Subject: RE: [Resubmit: PATCH-V2] Introducing ti-media directory
Message-ID: <19F8576C6E063C45BE387C64729E7394044DE0EBC5@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
 <1268991350-549-1-git-send-email-hvaibhav@ti.com>
 <201003231241.00281.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201003231241.00281.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Tuesday, March 23, 2010 5:11 PM
> To: davinci-linux-open-source@linux.davincidsp.com
> Cc: Hiremath, Vaibhav; linux-media@vger.kernel.org
> Subject: Re: [Resubmit: PATCH-V2] Introducing ti-media directory
> 
> On Friday 19 March 2010 10:35:50 hvaibhav@ti.com wrote:
> > From: Vaibhav Hiremath <hvaibhav@ti.com>
> >
> > Looking towards the number of files which are cluttering in media/video/
> > directory, it is required to introduce seperate working
> > directory for TI devices.
> 
> You should then move the omap24xxcam driver as well.
[Hiremath, Vaibhav] I wanted to move this file to ti-media directory, but left it only because it is based on V4L2-Int framework (legacy).

> 
> > Again the IP's are being re-used across the devices which makes it very
> > difficuilt to re-use the driver code. For example, DM6446 and AM3517 both
> > uses exactly same VPFE/CCDC IP, but the driver is encapsulated under
> > DAVINCI which makes it impossible to re-use.
> 
> I'm not too sure to like the ti-media name. It will soon get quite crowded,
> and name collisions might occur (look at the linux-omap-camera tree and the
> ISP driver in there for instance). Isn't there an internal name to refer to
> both the DM6446 and AM3517 that could be used ?
[Hiremath, Vaibhav] Laurent,

ti-media directory is top level directory where we are putting all TI devices drivers. So having said that, we should worrying about what goes inside this directory.
For me ISP is more generic, if you compare davinci and OMAP. 

Frankly, there are various naming convention we do have from device to device, even if the IP's are being reused. For example, the internal name for OMAP is ISP but Davinci refers it as a VPSS.

Thanks,
Vaibhav

> 
> > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> --
> Regards,
> 
> Laurent Pinchart
