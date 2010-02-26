Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:38156 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965022Ab0BZPVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2010 10:21:42 -0500
From: "Maupin, Chase" <chase.maupin@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hans.verkuil@tandberg.com>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>,
	"mchehab@infradead.org" <mchehab@infradead.org>,
	"vpss_driver_design@list.ti.com - This list is to discuss the VPSS
	driver design (May contain non-TIers)"
	<vpss_driver_design@list.ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 26 Feb 2010 09:21:24 -0600
Subject: RE: Requested feedback on V4L2 driver design
Message-ID: <131E5DFBE7373E4C8D813795A6AA7F0802E84A29AE@dlee06.ent.ti.com>
References: <131E5DFBE7373E4C8D813795A6AA7F0802C4E0FF3E@dlee06.ent.ti.com>
 <201002120222.38816.laurent.pinchart@ideasonboard.com>
 <131E5DFBE7373E4C8D813795A6AA7F0802E7F9CB88@dlee06.ent.ti.com>
 <201002260135.23333.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201002260135.23333.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent,

Responses inline.

Sincerely,
Chase Maupin
Software Applications
Catalog DSP Products
e-mail: chase.maupin@ti.com
phone: (281) 274-3285

For support:
Forums - http://community.ti.com/forums/
Wiki - http://wiki.davincidsp.com/

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Thursday, February 25, 2010 6:35 PM
> To: Maupin, Chase
> Cc: Hans Verkuil; sakari.ailus@maxwell.research.nokia.com;
> mchehab@infradead.org; vpss_driver_design@list.ti.com - This list is to
> discuss the VPSS driver design (May contain non-TIers); linux-
> media@vger.kernel.org
> Subject: Re: Requested feedback on V4L2 driver design
> 
> Hi Chase,
> 
> On Tuesday 16 February 2010 14:00:11 Maupin, Chase wrote:
> > Laurent,
> >
> > To follow up with some of the comments I made before I got additional
> > clarification about the commands supported by the proxy driver running
> on
> > the VPSS MCU.  The proxy will support all of the commands used by V4L2
> as
> > well as those proposed extensions to V4L2 that Hans has mentioned.
> > Basically, the list of commands supported at initial release is not only
> > those required today, but a full set for all the features of the VPSS.
> In
> > this was as new APIs are added to V4L2 the support for those features
> will
> > already be supported by the VPSS MCU proxy driver.
> 
> Thank you for the clarification.
> 
> A few things are still uncleared to me, as stated in my previous mail
> (from a
> few minutes ago). My main question is, if the VPSS API is full-featured
> and
> accessible from the master CPU, why do we need a proxy driver in the
> firmware
> at all ?

The proxy driver is the piece of code in the firmware that is actually exposing the VPSS API to the master CPU.  It is responsible for listening for requests from the master CPU and then executing those requests on the VPSS CPU.  Without the proxy there is no way to tell the VPSS CPU which functions to execute.

> 
> > As for the license of the firmware this is still being worked.  It is
> > currently under TI proprietary license and will be distributed as binary
> > under Technical Software Publicly Available (TSPA) which means it can be
> > obtained by anyone.  If you feel that source code is required for the
> > firmware at launch to gain acceptance please let us know and we can
> start
> > working that issue.
> 
> I think it would definitely help keeping the Linux driver and the VPSS
> firmware in sync if the VPSS firmware source was available. The firmware
> source code could even be distributed along with the Linux driver.

Thanks for the input.  We'll keep this in mind and see what we can do.

> 
> By the way, will the firmware be loaded at runtime by the driver, or will
> it
> be stored internally in the chip ?

The firmware will not be stored internally on the chip and will have to be loaded at runtime.  We have not settled on how the loading will be done.  Currently we are thinking on loading it from u-boot similar to an FPGA firmware load but it could also be done from the kernel.

> 
> --
> Regards,
> 
> Laurent Pinchart
