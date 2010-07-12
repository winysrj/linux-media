Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442Ab0GLV2k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jul 2010 17:28:40 -0400
Message-ID: <4C3B8923.1040109@redhat.com>
Date: Mon, 12 Jul 2010 18:29:07 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Pawel Osciak <p.osciak@samsung.com>
CC: "'Linux Media Mailing List'" <linux-media@vger.kernel.org>,
	"'Hans Verkuil'" <hverkuil@xs4all.nl>,
	"'Hans de Goede'" <hdegoede@redhat.com>, kyungmin.park@samsung.com
Subject: Re: [RFC v4] Multi-plane buffer support for V4L2 API
References: <004b01cb1f98$e586ae10$b0940a30$%osciak@samsung.com>
In-Reply-To: <004b01cb1f98$e586ae10$b0940a30$%osciak@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

Em 09-07-2010 15:59, Pawel Osciak escreveu:
> Hello,
> 
> This is the fourth version of the multi-plane API extensions proposal.
> I think that we have reached a stage at which it is more or less finalized.
> 
> Rationale can be found at the beginning of the original thread:
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/11212

With Hans proposed changes that you've already acked, I think the proposal is ok,
except for one detail:
 
> 4. Format enumeration
> ----------------------------------
> struct v4l2_fmtdesc, used for format enumeration, does include the v4l2_buf_type
> enum as well, so the new types can be handled properly here as well.
> For drivers supporting both versions of the API, 1-plane formats should be
> returned for multiplanar buffer types as well, for consistency. In other words,
> for multiplanar buffer types, the formats returned are a superset of those
> returned when enumerating with the old buffer types.
> 

We shouldn't mix types here. If the userspace is asking for multi-planar types,
the driver should return just the multi-planar formats.

If the userspace wants to know about both, it will just call for both types of
formats.

Cheers,
Mauro
