Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:56106 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab0BHPJQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2010 10:09:16 -0500
From: "Maupin, Chase" <chase.maupin@ti.com>
To: Hans Verkuil <hans.verkuil@tandberg.com>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>,
	"mchehab@infradead.org" <mchehab@infradead.org>
CC: "vpss_driver_design@list.ti.com - This list is to discuss the VPSS
	driver design (May contain non-TIers)"
	<vpss_driver_design@list.ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 8 Feb 2010 09:08:37 -0600
Subject: Requested feedback on V4L2 driver design
Message-ID: <131E5DFBE7373E4C8D813795A6AA7F0802C4E0FF3E@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All,

Texas Instruments (TI) is working on the design for the V4L2 capture and display drivers for our next generation system-on-chip (SoC) processor and would like to solicit your feedback.  Our new SoCs have been improved to allow for higher video resolutions and greater frame rates.  To this end the display hardware has been moved to a separate processing block called the video processing subsystem (VPSS).  The VPSS will be running a firmware image that controls the capture/display hardware and services requests from one or more host processors.

Moving to a remote processor for the processing of video input and output data requires that commands to control the hardware be passed to this processing block using some form of inter-processor communication (IPC).  TI would like to solicit your feedback on proposal for the V4L2 driver design to get a feel for whether or not this design would be accepted into the Linux kernel.  To this end we have put together an overview of the design and usage on our wiki at http://wiki.davincidsp.com/index.php/Video_Processing_Subsystem_Driver_Design.  We would greatly appreciate feedback from community members on the acceptability of our driver design.

If you have additional questions or need more information please feel free to contact us (we have setup a mailing list at vpss_driver_design@list.ti.com) so we can answer them.

Sincerely,
Chase Maupin
Software Applications
Catalog DSP Products
e-mail: chase.maupin@ti.com

For support:
Forums - http://community.ti.com/forums/
Wiki - http://wiki.davincidsp.com/

