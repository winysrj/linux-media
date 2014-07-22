Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4558 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaGVHXy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 03:23:54 -0400
Message-ID: <53CE116D.8010404@xs4all.nl>
Date: Tue, 22 Jul 2014 09:23:25 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "Monica, Agnes" <Agnes.Monica@analog.com>,
	"v4l2-library@linuxtv.org" <v4l2-library@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [V4l2-library] FourCC support
References: <E2B3634EC825DA45A0EB7D5409D69FBE584D03FA@NWD2MBX6.ad.analog.com>
In-Reply-To: <E2B3634EC825DA45A0EB7D5409D69FBE584D03FA@NWD2MBX6.ad.analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Monica,

The v4l2-library is not the best mailinglist for that so I've added linux-media
as well, which is more appropriate. I've also added Lars-Peter since he does a
lot of adv work as well.

The short answer is that those colorspaces are not supported at the moment,
but that it is not a problem to add them, provided the driver you are
working on is going to be upstreamed (i.e., we'd like to have users for
the API elements we add).

One note of interest: there is currently no API mechanism to tell userspace
if the image data is limited or full range. YCbCr is always assumed to be
limited range and RGB full range. If you need to signal that, then let me
know. A flags field has been added to struct v4l2_pix_format in the last
few days that would allow you to add a 'ALT_RANGE' flag, telling userspace
that the alternate quantization range is used. This flag doesn't exist yet,
but it is no problem to add it.

Hope this helps,

	Hans

On 07/22/14 08:18, Monica, Agnes wrote:
> Hi ,
> 
> One of drivers which we are developing supports formats like sYcc ,
> AdobeRGB and AdobeYCC601 which was added recently in HDMI spec1.4. So
> can you please tell me how will these formats be supported by fmt.
> 
> Regards,
> 
> Monica

