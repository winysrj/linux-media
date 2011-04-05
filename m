Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43840 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab1DEMBo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 08:01:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size videobuffer management
Date: Tue, 5 Apr 2011 14:02:17 +0200
Cc: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange> <Pine.LNX.4.64.1104040915590.4668@axis700.grange> <56f5dd2ffa0a55d09a5f391f0fa2e9d0.squirrel@webmail.xs4all.nl>
In-Reply-To: <56f5dd2ffa0a55d09a5f391f0fa2e9d0.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104051402.17836.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday 04 April 2011 10:06:47 Hans Verkuil wrote:
> > On Mon, 4 Apr 2011, Hans Verkuil wrote:
> >> On Friday, April 01, 2011 10:13:02 Guennadi Liakhovetski wrote:

[snip]

> BTW, REQBUFS and CREATE/DESTROY_BUFS should definitely co-exist. REQBUFS
> is compulsory, while CREATE/DESTROY are optional.

Drivers must support REQBUFS and should support CREATE/DESTROY, but I think 
applications should not be allowed to mix calls.

-- 
Regards,

Laurent Pinchart
