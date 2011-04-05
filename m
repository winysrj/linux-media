Return-path: <mchehab@pedra>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:2719 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab1DEMkf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 08:40:35 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size videobuffer management
Date: Tue, 5 Apr 2011 14:40:16 +0200
Cc: "Hans Verkuil" <hverkuil@xs4all.nl>,
	"Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange> <56f5dd2ffa0a55d09a5f391f0fa2e9d0.squirrel@webmail.xs4all.nl> <201104051402.17836.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201104051402.17836.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104051440.16449.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, April 05, 2011 14:02:17 Laurent Pinchart wrote:
> On Monday 04 April 2011 10:06:47 Hans Verkuil wrote:
> > > On Mon, 4 Apr 2011, Hans Verkuil wrote:
> > >> On Friday, April 01, 2011 10:13:02 Guennadi Liakhovetski wrote:
> 
> [snip]
> 
> > BTW, REQBUFS and CREATE/DESTROY_BUFS should definitely co-exist. REQBUFS
> > is compulsory, while CREATE/DESTROY are optional.
> 
> Drivers must support REQBUFS and should support CREATE/DESTROY, but I think 
> applications should not be allowed to mix calls.

Why not? The videobuf2-core.c implementation shouldn't care about that, so
I don't see why userspace should care.

Regards,

	Hans

> 
> -- 
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
