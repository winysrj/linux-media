Return-path: <linux-media-owner@vger.kernel.org>
Received: from 8.mo173.mail-out.ovh.net ([46.105.46.122]:35079 "EHLO
	8.mo173.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbcFAQDI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2016 12:03:08 -0400
Received: from player157.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo173.mail-out.ovh.net (Postfix) with ESMTP id D0492FFB53B
	for <linux-media@vger.kernel.org>; Wed,  1 Jun 2016 16:46:33 +0200 (CEST)
From: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
Subject: [RFC] SDI timings and API
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Petr Nohavica <pn@rozsnyo.com>, Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <88182a87-5ecd-e62f-a3d7-cda6f13948f6@nexvision.fr>
Date: Wed, 1 Jun 2016 16:46:30 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,
The purpose of this RFC is to define SDI timings structure and potentially the associated API in the V4L2 API.

** Context **

Currently, V4L2 API has a structure to define CEA-861 / VESA timings. If these timings are common in monitor and general market, in the industry or television context there are some components which used SDI timings with different properties.

** Issues **

There are not the notion of front/back/syncporch. Instead, there are vertical / horizontal blanking defined before the video signal. This blanking could have ancillary data used by audio signal or other metadata.
The horizontal blanking are delimited by EAV and SAV words, because of SDI is a digital interface.

Some timings are very... strange. Like the SMPTE-125M:

The organization of lines :
Line 1 to 9 : blanking
Line 10 to 20 : options (ancillary data)
Line 21 to 264 : field 1
Line 265 to 272 : blanking
Line 273 to 282 : options
Line 283 to 525 : field 2

The blanking lines are not regular: 19 then 18 lines.
The size of fields are different too: 243 then 242.

The Field signal is changed in line 266 (during the second vertical blanking !)
* Complete format size (with blanking) ; 858x525
* Image size : 720x487 (yes, a odd number)
* Pixelclock : 27 MHz
* Interlaced image

The current v4l2_bt_timings structure can not represent that correctly.

Notice that some SDI / VESA components could detect automatically input signal format. A way to represent auto-mode activation should be useful.

** Possible solutions **

Indeed, it needs a new constant: V4L2_DV__STD_SDI (or other name).

I'm working on the first new structure proposal:

struct v4l2_sdi_timings {
	__u32   width;
        __u32   height;
        __u32   interlaced;
        __u32   polarities;
        __u64   pixelclock;
        __u32   hanc;
        __u32   vanc1;
        __u32   vanc2; 		/* if interlaced */
        __u32   field1;
        __u32   field2; 	/* if interlaced */
        __u32   standards;
        __u32   flags;		/* add auto-mode flag */
        __u32   reserved[?];
} __attribute__ ((packed));

The auto-mode should be set into flags value (V4L2_DV_AUTO_MODE ?). Or add a specific field in this structure, but I think it is not necessary.
We need to add this structure into v4l2_dv_timings I think.
But, if this solution is used, we need to rewrite some generic functions about timings in the V4L2 API...

It was a RFC based on my difficulties to write a driver for GS1662. Maybe others components or elements have other issues and need a different solution.
Thanks in advance.
Regards,

Charles-Antoine Couret
