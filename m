Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:58442 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753256AbcGDJQl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 05:16:41 -0400
Subject: Re: [PATCH RFC v2 0/2] pxa_camera transition to v4l2 standalone
 device
To: Robert Jarzmik <robert.jarzmik@free.fr>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1459607213-15774-1-git-send-email-robert.jarzmik@free.fr>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8b280912-1c4b-17f2-167f-1b30dc7e73f9@xs4all.nl>
Date: Mon, 4 Jul 2016 11:15:58 +0200
MIME-Version: 1.0
In-Reply-To: <1459607213-15774-1-git-send-email-robert.jarzmik@free.fr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

On 04/02/2016 04:26 PM, Robert Jarzmik wrote:
> Hi Hans and Guennadi,
> 
> This is the second opus of this RFC. The goal is still to see how close our
> ports are to see if there are things we could either reuse of change.
> 
> From RFCv1, the main change is cleaning up in function names and functions
> grouping, and fixes to make v4l2-compliance happy while live tests still show no
> regression.
> 
> For the next steps, I'll have to :
>  - split the second patch, which will be a headache task, into :
>    - first functions grouping and renaming
>      => this to ensure the "internal functions" are almost untouched
>    - the the port itself
> 
> I'm leaving soc_mediabus for now, that's another task.
> 
> I'm not seeing a big review traction, especially on the vb2 conversion, so I'll
> leave this patchset in RFC form until vb2 patch is reviewed and merged, and then
> will come back to this work.

I'm going to review this today.

I have been trying on-and-off to convert the sh_mobile_ceu_camera to a regular
driver with basically no success. One major problem is that the sh driver doesn't
use the device tree, so I can't copy code from the new rcar-vin driver. The scaling
and cropping code is also tightly coupled to soc-camera.

It is of course possible to do given enough time, but I don't think it is worth it.

So instead I am going for plan B: convert all other soc-camera drivers to 'regular'
drivers so in the end soc-camera is only used by the sh driver. Then I can turn
soc-camera into an sh driver, making it impossible for other drivers to use the
framework.

In other words, it would be great if you can continue this work, because after
this driver is converted only the atmel-isi driver remains (besides the sh driver,
of course).

Regards,

	Hans
