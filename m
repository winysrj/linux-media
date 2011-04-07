Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59182 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab1DGJR7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Apr 2011 05:17:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size videobuffer management
Date: Thu, 7 Apr 2011 11:17:59 +0200
Cc: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	"Hans Verkuil" <hansverk@cisco.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange> <Pine.LNX.4.64.1104070914540.24325@axis700.grange> <058f16a20d747a5ef6b300e119fa69b4.squirrel@webmail.xs4all.nl>
In-Reply-To: <058f16a20d747a5ef6b300e119fa69b4.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104071117.59995.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Thursday 07 April 2011 09:50:13 Hans Verkuil wrote:
> > On Thu, 7 Apr 2011, Hans Verkuil wrote:

[snip]

> >> Regarding DESTROY_BUFS: perhaps we should just skip this for now and wait
> >> for the first use-case. That way we don't need to care about holes. I
> >> don't like artificial restrictions like 'no holes'. If someone has a good
> >> use-case for selectively destroying buffers, then we need to look at this
> >> again.
> > 
> > Sorry, skip what? skip the ioctl completely and rely on REQBUFS(0) /
> > close()?
> 
> Yes.

I don't really like that as it would mix CREATE and REQBUFS calls. 
Applications should either use the old API (REQBUFS) or the new one, but not 
mix both.

The fact that freeing arbitrary spans of buffers gives us uneasy feelings 
might be a sign that the CREATE/DESTROY API is not mature enough. I'd rather 
try to solve the issue now instead of postponing it for later and discover 
that our CREATE API should have been different.

-- 
Regards,

Laurent Pinchart
