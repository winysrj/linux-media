Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:54406 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751544AbcEXPgt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 11:36:49 -0400
Subject: Re: [PATCH/RFC v2 1/4] v4l: Add metadata buffer type and format
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1463012283-3078-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1463012283-3078-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <5742D6CC.8040909@xs4all.nl>
 <20160524152831.GF26360@valkosipuli.retiisi.org.uk>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5744750A.5070205@xs4all.nl>
Date: Tue, 24 May 2016 17:36:42 +0200
MIME-Version: 1.0
In-Reply-To: <20160524152831.GF26360@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/24/2016 05:28 PM, Sakari Ailus wrote:
> Hi Hans,
> 
>> Should it be mentioned here that changing the video format might change
>> the buffersize? In case the buffersize is always a multiple of the width?
> 
> Isn't that the case in general, as with pixel formats? buffersize could also
> be something else than a multiple of width (there's no width for metadata
> formats) due to e.g. padding required by hardware.

Well, I don't think it is obvious that the metadata buffersize depends on the
video width. Perhaps developers who are experienced with CSI know this, but
if you know little or nothing about CSI, then it can be unexpected (hey, that
was the case for me!).

I think it doesn't hurt to mention this relation.

Regards,

	Hans
