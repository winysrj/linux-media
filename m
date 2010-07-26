Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:48715 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab0GZQMa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 12:12:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: [SAMPLE v2 04/12] v4l-subdev: Add pads operations
Date: Mon, 26 Jul 2010 18:12:55 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com> <1279723318-28943-5-git-send-email-laurent.pinchart@ideasonboard.com> <A69FA2915331DC488A831521EAE36FE4016B84FDFD@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE4016B84FDFD@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007261812.56355.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 23 July 2010 17:56:02 Karicheri, Muralidharan wrote:
> Laurent,
> 
> Could you explain the probe and active usage using an example such as
> below?
> 
>             Link1    Link2
> input sensor -> ccdc -> video node.
> 
> Assume Link2 we can have either format 1 or format 2 for capture.

Sure.

The probe and active formats are used to probe supported formats and 
getting/setting active formats.

* Enumerating supported formats on the CCDC input and output would be done 
with the following calls

ENUM_FMT(CCDC input pad)

for the input, and

S_FMT(PROBE, CCDC input pad, format)
ENUM_FMT(CCDC output pad)

for the output.

Setting the probe format on the input pad is required, as the format on an 
output pad usually depends on the format on input pads.

* Trying a format on the CCDC input and output would be done with

S_FMT(PROBE, CCDC input pad, format)

for the input, and

S_FMT(PROBE, CCDC input pad, format)
S_FMT(PROBE, CCDC output pad, format)

on the output. The S_FMT call will mangle the format given format if it can't 
be supported exactly, so there's no need to call G_FMT after S_FMT (a G_FMT 
call following a S_FMT call will return the same format as the S_FMT call).

* Setting the active format is done with

S_FMT(ACTIVE, CCDC input pad, format)
S_FMT(ACTIVE, CCDC output pad, format)

The formats will be applied to the hardware (possibly with a delay, drivers 
can delay register writes until STREAMON for instance).

Probe formats are stored in the subdev file handles, so two applications 
trying formats at the same time will not interfere with each other. Active 
formats are stored in the device structure, so modifications done by an 
application are visible to other applications.

Hope this helps clarifying the API.

-- 
Regards,

Laurent Pinchart
