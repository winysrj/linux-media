Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:51305 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab0GZQTP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 12:19:15 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
Date: Mon, 26 Jul 2010 11:19:05 -0500
Subject: RE: [SAMPLE v2 04/12] v4l-subdev: Add pads operations
Message-ID: <A69FA2915331DC488A831521EAE36FE4016B8E5FD0@dlee06.ent.ti.com>
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1279723318-28943-5-git-send-email-laurent.pinchart@ideasonboard.com>
 <A69FA2915331DC488A831521EAE36FE4016B84FDFD@dlee06.ent.ti.com>
 <201007261812.56355.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201007261812.56355.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent,

Thanks for clarifying this. I guess this will also get documented in the
v4l2 specs (if not already done) as part of this patch.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
>Sent: Monday, July 26, 2010 12:13 PM
>To: Karicheri, Muralidharan
>Cc: linux-media@vger.kernel.org; sakari.ailus@maxwell.research.nokia.com
>Subject: Re: [SAMPLE v2 04/12] v4l-subdev: Add pads operations
>
>On Friday 23 July 2010 17:56:02 Karicheri, Muralidharan wrote:
>> Laurent,
>>
>> Could you explain the probe and active usage using an example such as
>> below?
>>
>>             Link1    Link2
>> input sensor -> ccdc -> video node.
>>
>> Assume Link2 we can have either format 1 or format 2 for capture.
>
>Sure.
>
>The probe and active formats are used to probe supported formats and
>getting/setting active formats.
>
>* Enumerating supported formats on the CCDC input and output would be done
>with the following calls
>
>ENUM_FMT(CCDC input pad)
>
>for the input, and
>
>S_FMT(PROBE, CCDC input pad, format)
>ENUM_FMT(CCDC output pad)
>
>for the output.
>
>Setting the probe format on the input pad is required, as the format on an
>output pad usually depends on the format on input pads.
>
>* Trying a format on the CCDC input and output would be done with
>
>S_FMT(PROBE, CCDC input pad, format)
>
>for the input, and
>
>S_FMT(PROBE, CCDC input pad, format)
>S_FMT(PROBE, CCDC output pad, format)
>
>on the output. The S_FMT call will mangle the format given format if it
>can't
>be supported exactly, so there's no need to call G_FMT after S_FMT (a G_FMT
>call following a S_FMT call will return the same format as the S_FMT call).
>
>* Setting the active format is done with
>
>S_FMT(ACTIVE, CCDC input pad, format)
>S_FMT(ACTIVE, CCDC output pad, format)
>
>The formats will be applied to the hardware (possibly with a delay, drivers
>can delay register writes until STREAMON for instance).
>
>Probe formats are stored in the subdev file handles, so two applications
>trying formats at the same time will not interfere with each other. Active
>formats are stored in the device structure, so modifications done by an
>application are visible to other applications.
>
>Hope this helps clarifying the API.
>
>--
>Regards,
>
>Laurent Pinchart
