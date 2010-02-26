Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45901 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935641Ab0BZMFE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2010 07:05:04 -0500
Message-ID: <4B87B8E6.6040608@infradead.org>
Date: Fri, 26 Feb 2010 09:04:54 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Pawel Osciak <p.osciak@samsung.com>
CC: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	linux-media@vger.kernel.org
Subject: Re: More videobuf and streaming I/O questions
References: <201002201500.21118.hverkuil@xs4all.nl> <201002220012.20797.laurent.pinchart@ideasonboard.com> <000901cab45b$a8c55a10$fa500e30$%osciak@samsung.com> <201002260046.16878.laurent.pinchart@ideasonboard.com> <001b01cab6b6$631d05f0$295711d0$%osciak@samsung.com>
In-Reply-To: <001b01cab6b6$631d05f0$295711d0$%osciak@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pawel Osciak wrote:
>> On Tuesday 23 February 2010 08:41:49 Pawel Osciak wrote:
>>>> On Mon, 22 Feb 2010 00:12:18 +0100
>>>> Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
>>> As for the REQBUF, I've always thought it'd be nice to be able to ask the
>>> driver for the "recommended" number of buffers that should be used by
>>> issuing a REQBUF with count=0...
>> How would the driver come up with the number of recommended buffers ?
> 
> From the top of my head: when encoding a video stream, a codec driver could
> decide on the minimum number of input frames required (including reference
> frames, etc.).
> 
> Or maybe I am missing something, what is your opinion on that?

There are some cases where this feature could be useful. For example, there are
some devices used for surveillance that have one decoder connected to several
inputs. For example, several bttv boards have one bt848 chip for each 8 inputs.
Each input is connected to one camera. The minimum recommended number of buffers
is 16 (2 per each input). This is poorly documented, on some wikis for some of
the boards with such usage.

That's said, there's currently a few missing features for surveillance: the user
software need to manually switch from one input to another, and the video buffer
metadata doesn't indicate the input. 

The better would be to provide a way to let the driver to switch to the next camera 
just after the reception of a new buffer (generally at the IRQ time), instead of 
letting the userspace software to do it at the DQBUF.

-- 

Cheers,
Mauro
