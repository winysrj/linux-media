Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab2HQNWZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 09:22:25 -0400
Message-ID: <502E45CB.6090103@redhat.com>
Date: Fri, 17 Aug 2012 15:23:23 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: workshop-2011@linuxtv.org, Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] V4L2 API ambiguities: workshop presentation
References: <201208171235.58094.hverkuil@xs4all.nl> <502E3D97.3090502@redhat.com> <201208171455.13961.hverkuil@xs4all.nl> <70803480.BV5Mjk80If@avalon>
In-Reply-To: <70803480.BV5Mjk80If@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/17/2012 02:57 PM, Laurent Pinchart wrote:

<Snip>

>> Regarding ENUM_FRAMESIZES: it makes sense to add an aspect ratio here for
>> use with sensors. But for video receivers ENUM_FRAMESIZES isn't applicable.
>
> Do we have sensors with non-square pixels ?

Short answer: not that I know of.

Long answer: that depends on the optics (so the sensor pixels may be square,
but the optics could make them non-square from a proper mapping to a real world
picture pov).

As I've done too much with weird old webcams I actually now webcams which do
this, the vicam cameras to be precise. The 3 com HomeConnect (04c1:009) has
a sensor with a native resolution of 512x244, yeah widescreen baby!

But it stems from an area where widescreen was unheard of in computer graphics,
so it actually has optics which force that cool widescreen resolution back into
a 4x3 field of view. So for a proper square pixels image form that camera its
image needs to be scaled from 512x244 to 512x384 (*). But with that one exception
proving the rule (Dutch expression), I think all sensors have square pixels.

Regards,

Hans

*) Really? Yes really!
