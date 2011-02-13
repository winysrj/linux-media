Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:8143 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755029Ab1BMVfy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Feb 2011 16:35:54 -0500
Subject: Re: radio tuner but no V4L2_CAP_RADIO ?
From: Andy Walls <awalls@md.metrocast.net>
To: Martin Dauskardt <martin.dauskardt@gmx.de>
Cc: linux-media@vger.kernel.org
In-Reply-To: <201102132039.07632.martin.dauskardt@gmx.de>
References: <201102132039.07632.martin.dauskardt@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Feb 2011 16:35:56 -0500
Message-ID: <1297632956.2401.11.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 2011-02-13 at 20:39 +0100, Martin Dauskardt wrote:
> The following cards have a Multi Standard tuner with radio:
> KNC One TV-Station DVR (saa7134) FMD1216MEX
> HVR1300 (cx88-blackbird) Philips FMD1216ME
> /dev/radio0 is present and working.
> 
> Both drivers do not report the radio when using VIDIOC_QUERYCAP.
> 
> Is this a bug, or is there no clear specification that a driver must report 
> this?

The V4L2 API spec is unclear on this subject in most places, but it is
*very* clear here:

http://linuxtv.org/downloads/v4l-dvb-apis/radio.html#id2682669

"Devices supporting the radio interface set the V4L2_CAP_RADIO and
V4L2_CAP_TUNER or V4L2_CAP_MODULATOR flag in the capabilities field of
struct v4l2_capability returned by the VIDIOC_QUERYCAP ioctl."

Those drivers have bugs.

Regards,
Andy

> Is there are any other way to check radio for support (besides trying to open 
> a matching radio device) ?



> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


