Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43373 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab2HNAAF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 20:00:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: workshop-2011@linuxtv.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] RFC: V4L2 API ambiguities
Date: Tue, 14 Aug 2012 02:00:19 +0200
Message-ID: <5403829.BeBAZV71c8@avalon>
In-Reply-To: <5028FD7E.1010402@redhat.com>
References: <201208131427.56961.hverkuil@xs4all.nl> <5028FD7E.1010402@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 13 August 2012 15:13:34 Hans de Goede wrote:

[snip]

> > 4) What should a driver return in TRY_FMT/S_FMT if the requested format is
> >     not supported (possible behaviours include returning the currently
> >     selected format or a default format).
> >     
> >     The spec says this: "Drivers should not return an error code unless
> >     the input is ambiguous", but it does not explain what constitutes an
> >     ambiguous input. Frankly, I can't think of any and in my opinion
> >     TRY/S_FMT should never return an error other than EINVAL (if the
> >     buffer type is unsupported) or EBUSY (for S_FMT if streaming is in
> >     progress).
> >     
> >     Returning an error for any other reason doesn't help the application
> >     since the app will have no way of knowing what to do next.
> 
> Ack on not returning an error for requesting an unavailable format. As for
> what the driver should do (default versus current format) I've no
> preference, I vote for letting this be decided by the driver
> implementation.

That's exactly the point that I wanted to clarify :-) I don't see a good 
reason to let the driver decide on this, and would prefer returning a default 
format as TRY_FMT would then always return the same result for a given input 
format regardless of the currently selected format.

-- 
Regards,

Laurent Pinchart

