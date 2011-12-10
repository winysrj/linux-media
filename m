Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:60777 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab1LJJRU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Dec 2011 04:17:20 -0500
Date: Sat, 10 Dec 2011 11:17:15 +0200
From: 'Sakari Ailus' <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Kamil Debski <k.debski@samsung.com>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	'Sebastian =?iso-8859-1?Q?Dr=F6ge'?=
	<sebastian.droege@collabora.co.uk>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	'Hans Verkuil' <hans.verkuil@cisco.com>
Subject: Re: [RFC] Resolution change support in video codecs in v4l2
Message-ID: <20111210091715.GD1967@valkosipuli.localdomain>
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF36225500763A@bssrvexch01>
 <4ED905E0.5020706@redhat.com>
 <007201ccb118$633ff890$29bfe9b0$%debski@samsung.com>
 <201112061301.01010.laurent.pinchart@ideasonboard.com>
 <20111206142821.GC938@valkosipuli.localdomain>
 <4EDE29AA.8090203@redhat.com>
 <00de01ccb42a$7cddab70$76990250$%debski@samsung.com>
 <4EDE375B.6010900@redhat.com>
 <00df01ccb431$bd28d9f0$377a8dd0$%debski@samsung.com>
 <4EDE454D.5060605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDE454D.5060605@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tue, Dec 06, 2011 at 02:39:41PM -0200, Mauro Carvalho Chehab wrote:
...
> >I think that still it should contain no useful data, just *_FORMAT_CHANGED | *_ERROR
> >flags set. Then the application could decide whether it keeps the current
> >size/alignment/... or should it allocate new buffers. Then ACK the driver.
> 
> This will cause frame losses on Capture devices. It probably doesn't make sense to
> define resolution change support like this for output devices.
> 
> Eventually, we may have an extra flag: *_PAUSE. If *_PAUSE is detected, a VIDEO_DECODER_CMD
> is needed to continue.
> 
> So, on M2M devices, the 3 flags are raised and the buffer is not filled.  This would cover
> Sakari's case.

This sounds good in my opinion. I've been concentrated to memory-to-memory
devices so far, but I now reckon the data to be processed might not arrive
from the system memory.

I agree we need different behaviour in the two cases: when the data arrives
from the system memory, no loss of decoded data should happen due to
reconfiguration of the device done by the user --- which sometimes is
mandatory.

Would pause, as you propose it, be set by the driver, or by the application
in the intent to indicate the stream should be stopped whenever the format
changes, or both?

> >The thing is that we have two queues in memory-to-memory devices.
> >I think the above does apply to the CAPTURE queue:
> >- no processing is done after STREAMOFF
> >- buffers that have been queue are dequeued and their content is lost
> >Am I wrong?
> 
> This is what is there at the spec. I think we need to properly specify what
> happens for M2M devices.

I fully agree. Different device profiles have a role in this.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
