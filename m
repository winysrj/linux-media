Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1353 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab0GZTnE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 15:43:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [SAMPLE v2 04/12] v4l-subdev: Add pads operations
Date: Mon, 26 Jul 2010 21:42:49 +0200
Cc: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com> <A69FA2915331DC488A831521EAE36FE4016B84FDFD@dlee06.ent.ti.com> <201007261812.56355.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201007261812.56355.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007262142.49879.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 26 July 2010 18:12:55 Laurent Pinchart wrote:
> On Friday 23 July 2010 17:56:02 Karicheri, Muralidharan wrote:
> > Laurent,
> > 
> > Could you explain the probe and active usage using an example such as
> > below?
> > 
> >             Link1    Link2
> > input sensor -> ccdc -> video node.
> > 
> > Assume Link2 we can have either format 1 or format 2 for capture.
> 
> Sure.
> 
> The probe and active formats are used to probe supported formats and 
> getting/setting active formats.

Just to verify: we are dealing with mediabus formats here, right?

One thing that I don't like is the name 'probe'. I would prefer the name
'proposed'. You propose an input format and based on that you can enumerate
a list of proposed output format. I think that name fits better than 'probe'
which I find confusing in this context.

> 
> * Enumerating supported formats on the CCDC input and output would be done 
> with the following calls
> 
> ENUM_FMT(CCDC input pad)
> 
> for the input, and
> 
> S_FMT(PROBE, CCDC input pad, format)
> ENUM_FMT(CCDC output pad)
> 
> for the output.

How does ENUM_FMT know if it has to use the proposed or actual input formats?
Or is it supposed to always act on proposed formats?

> 
> Setting the probe format on the input pad is required, as the format on an 
> output pad usually depends on the format on input pads.
> 
> * Trying a format on the CCDC input and output would be done with
> 
> S_FMT(PROBE, CCDC input pad, format)
> 
> for the input, and
> 
> S_FMT(PROBE, CCDC input pad, format)
> S_FMT(PROBE, CCDC output pad, format)
> 
> on the output. The S_FMT call will mangle the format given format if it can't 
> be supported exactly, so there's no need to call G_FMT after S_FMT (a G_FMT 
> call following a S_FMT call will return the same format as the S_FMT call).
> 
> * Setting the active format is done with
> 
> S_FMT(ACTIVE, CCDC input pad, format)
> S_FMT(ACTIVE, CCDC output pad, format)
> 
> The formats will be applied to the hardware (possibly with a delay, drivers 
> can delay register writes until STREAMON for instance).
> 
> Probe formats are stored in the subdev file handles, so two applications 
> trying formats at the same time will not interfere with each other. Active 
> formats are stored in the device structure, so modifications done by an 
> application are visible to other applications.
> 
> Hope this helps clarifying the API.

You know that I have never been happy with this approach, but I also have to
admit that I haven't found a better way of doing it.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
