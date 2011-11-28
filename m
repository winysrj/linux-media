Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35967 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab1K1LGu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 06:06:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC] SUBDEV_S/G_SELECTION IOCTLs
Date: Mon, 28 Nov 2011 12:06:54 +0100
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, sylvester.nawrocki@gmail.com,
	g.liakhovetski@gmx.de, hverkuil@xs4all.nl, dacohen@gmail.com,
	andriy.shevchenko@linux.intel.com
References: <20111108215514.GJ22159@valkosipuli.localdomain> <201111161807.38080.laurent.pinchart@ideasonboard.com> <4ED0B07F.9010208@maxwell.research.nokia.com>
In-Reply-To: <4ED0B07F.9010208@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111281206.55316.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Saturday 26 November 2011 10:25:19 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > On Thursday 10 November 2011 23:29:34 Sakari Ailus wrote:
> >> On Thu, Nov 10, 2011 at 04:23:19PM +0100, Tomasz Stanislawski wrote:
> >>> On 11/08/2011 10:55 PM, Sakari Ailus wrote:

[snip]

> >>>> A sensor
> >>>> --------
> >>>> 
> >>>> The intent is to obtain a VGA image from a 8 MP sensor which provides
> >>>> following pipeline:
> >>>> 
> >>>> pixel_array:0 [crop] --->   0:binner:1 --->   [crop] 0:scaler:1 [crop]
> >>>> 
> >>>> Binner is an entity which can perform scaling, but only in factor of
> >>>> 1/n, where n is a positive integer. No cropping is needed. The intent
> >>>> is to get a 640x480 image from such sensor. (This doesn't involve any
> >>>> other configuration as the image size related one.)
> >>>> 
> >>>> 	The initial state of the pipeline
> >>>> 	
> >>>> 	pixel_array:0	binner:0	binner:1	scaler:0	scaler:1
> >>>> 
> >>>> compose
> >>>> (0,0)/3600x2464	(0,0)/3600x2464	(0,0)/3600x2464	(0,0)/3600x2464	(0,0)/
> >>>> 3 600x2464
> >>>> crop	(0,0)/3600x2464	(0,0)/3600x2464	(0,0)/3600x2464	(0,0)/3600x2464	(
> >>>> 0 ,0)/3600x2464 fmt	3600x2464	3600x2464	3600x2464	3600x2464	3600x2464
> >>>> 
> >>>> 	This will configure the binning on the binner subdev sink pad:
> >>>> 	
> >>>> 	SUBDEV_S_SELECTION(binner:0, COMPOSE_ACTIVE, (0,0)/1800x1232);
> >>>> 	
> >>>> 	pixel_array:0	binner:0	binner:1	scaler:0	scaler:1
> >>>> 
> >>>> compose
> >>>> (0,0)/3600x2464	(0,0)/1800x1232	(0,0)/1800x1232	(0,0)/3600x2464	(0,0)/
> >>>> 3 600x2464
> >>>> crop	(0,0)/3600x2464	(0,0)/3600x2464	(0,0)/1800x1232	(0,0)/3600x2464	(
> >>>> 0 ,0)/3600x2464 fmt	3600x2464	3600x2464	1800x1232	3600x2464	3600x2464
> >>>> 
> >>>> 	The same format must be set on the scaler pad 0 as well. This will
> >>>> 	reset the size inside the scaler to a sane default, which is no
> >>>> 	scaling:
> >>>> 	
> >>>> 	SUBDEV_S_FMT(scaler:0, 1800x1232);
> >>>> 	
> >>>> 	pixel_array:0	binner:0	binner:1	scaler:0	scaler:1
> >>>> 
> >>>> compose
> >>>> (0,0)/3600x2464	(0,0)/1800x1232	(0,0)/1800x1232	(0,0)/1800x1232	(0,0)/
> >>>> 1 800x1232
> >>>> crop	(0,0)/3600x2464	(0,0)/3600x2464	(0,0)/1800x1232	(0,0)/1800x1232	(
> >>>> 0 ,0)/1800x1232 fmt	3600x2464	3600x2464	1800x1232	1800x1232	1800x1232
> >>> 
> >>> I assume that scaler can upscale image 1800x1232 on scaler:0 to
> >>> 3600x2464 on pad scaler:1. Therefore the format and compose targets
> >>> on scaler:1 should not be changed.
> >> 
> >> Open question one: do we need a flag for other than s_selection to not
> >> to reset the following stages?
> >> 
> >> That said, we also need to define a behaviour for that: if changes must
> >> be made e.g. to crop and compose  rectangle on both sink and source
> >> pads, then how are they made?
> > 
> > Shouldn't that be left to the drivers to decide ? Different devices will
> > likely have different requirements.
> 
> That's quite possible, but still there should be a general rule that
> should be obeyed if possible, or if it makes sense; hopefully both.
> 
> I think that enabling the keep-pipeline bit should tell that the changes
> should be propagated as little as possible while not making too smart
> decisions. The expected behaviour should be defined.

Shouldn't the keep-pipeline bit prevent any propagation ?

> Say, if one has configured crop and scaling on the sink pad, how does
> the change of the sink pad format affect the two?
> 
> How about this: as the sink format still consists of the whole image,
> the crop rectangle should be scaled (by the driver) to fit to the new
> image and the scaling factor should be adjusted so that result after
> scaling in the sink pad changes as little as possible. There still may
> be changes to the image size after scaling depending on the properties
> of the hardware.
> 
> Do you think that would that make sense?

I think we should make it simpler. What about just setting all rectangles 
downstream to the same size as the sink format ? That's if the keep-pipeline 
bit isn't set, if it's set modifying the sink format should probably be 
disallowed.

> >>>> 	To perform further scaling on the scaler, the COMPOSE target is used
> >>>> 	on the scaler subdev's SOURCE pad:
> >>>> 	
> >>>> 	SUBDEV_S_SELECTION(scaler:0, COMPOSE_ACTIVE, (0,0)/640x480);
> >>>> 	
> >>>> 	pixel_array:0	binner:0	binner:1	scaler:0	scaler:1
> >>>> 
> >>>> compose
> >>>> (0,0)/3600x2464	(0,0)/1800x1232	(0,0)/1800x1232	(0,0)/640x480
> > 
> > (0,0)/640
> > 
> >>>> x480
> >>>> crop	(0,0)/3600x2464	(0,0)/3600x2464	(0,0)/1800x1232	(0,0)/1800x1232	(
> >>>> 0 ,0)/640x480 fmt	3600x2464	3600x2464	1800x1232	1800x1232	640x480
> >>> 
> >>> It is possible to compose 640x480 image into 1800x1232 data stream
> >>> produced on scaler:1. Therefore the format on scaler:1 should not be
> >>> changed. The area outside 640x480 would left undefined or filled by
> >>> some pattern configured using controls. This situation was the
> >>> reason of introducing PADDED target.
> >> 
> >> Consider the same example but scaling factor larger than 1. Should there
> >> be cropping or should the compose rectangle be changed?
> >> 
> >> Would it make sense to do as few changes as possible if the
> >> aforementioned flag is given?
> >> 
> >>>> The result is a 640x480 image from the scaler's output pad. The aspect
> >>>> ratio of the resulting image is different from 4/3 since no cropping
> >>>> was performed in this example.

-- 
Regards,

Laurent Pinchart
