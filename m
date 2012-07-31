Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54812 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756055Ab2GaLlh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 07:41:37 -0400
Date: Tue, 31 Jul 2012 14:41:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	davinci-linux-open-source@linux.davincidsp.com,
	LMML <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v7 1/2] media: add new mediabus format enums for dm365
Message-ID: <20120731114132.GH26642@valkosipuli.retiisi.org.uk>
References: <1343386505-8695-1-git-send-email-prabhakar.lad@ti.com>
 <201207302119.13196.hverkuil@xs4all.nl>
 <20120731111750.GG26642@valkosipuli.retiisi.org.uk>
 <201207311328.39988.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207311328.39988.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Hans Verkuil wrote:
> On Tue 31 July 2012 13:17:50 Sakari Ailus wrote:
>> Hi Hans and Laurent,
>>
>> On Mon, Jul 30, 2012 at 09:19:13PM +0200, Hans Verkuil wrote:
...
>>> And make a new pixel format if you have hardware that doesn't use zero? I think
>>> it's overkill IMHO.
>>
>> Could be. But I've seen only zero being used.
>>
>> Applications that need to process raw bayer images optimally are often very
>> hardware specific anyway, adding the assumption that the dummy bits are zero
>> isn't a big deal. The same might not apply as universally to yuv colour
>> space but on the other hand one extra and operation just won't take that
>> much time either.
> 
> My experience is with encoders and decoders. Anyway, we're not using this format,
> and neither will we ever upstream a pixel or mbus format since it is all highly
> specific to our products, so there is no point in upstreaming. So I am actually
> OK with saying that these bits should be 0, provided 'D' is replaced by 'Z'.
> 
> But I still think keeping it 'D' and allowing for any value is more generic
> and I expect that it is sufficient.
> 
>> I'm fine with defining the bits are dummy. I just wanted we make an informed
>> decision on this, and as far as I see that's now been reached.
>>
>> Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
> 
> OK, then we all agree to keep PATCHv7 as is?

Yes. If we later see that we need to use the format (I was thinking
in-memory formats instead of media bus pixel codes, but apparently
replied to this patch instead) to tell especially the unused bits are
zero we can start creating more formats, but I feel it's unlikely we'd
get there.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
