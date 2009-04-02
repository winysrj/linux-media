Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4632 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbZDBSjk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2009 14:39:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Alexey Klimov <klimov.linux@gmail.com>
Subject: Re: [RFC] BKL in open functions in drivers
Date: Thu, 2 Apr 2009 20:39:12 +0200
Cc: linux-media@vger.kernel.org,
	Alessio Igor Bogani <abogani@texware.it>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <1238619656.3986.88.camel@tux.localhost> <200904020929.22359.hverkuil@xs4all.nl> <208cbae30904021125y4597a04crc3b201b6c88ae79c@mail.gmail.com>
In-Reply-To: <208cbae30904021125y4597a04crc3b201b6c88ae79c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904022039.12719.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 02 April 2009 20:25:10 Alexey Klimov wrote:
> On Thu, Apr 2, 2009 at 11:29 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
> [...]
> 
> >> So, questions are:
> >>
> >> 1) What for is lock/unlock_kernel() used in open?
> >
> > It's pointless. Just remove it.
> 
> Actually, i can see lock/unlock_kernel() in open in other V4L drivers too.
> What for is it used in other drivers?

If I remember correctly these lock/unlock_kernel() calls were originally
handled in the part of the kernel that calls us in turn. An effort was made
not too long ago to move it this out of the core kernel and into each driver,
allowing each driver to replace these calls by proper mutexes, or remove it
altogether if it isn't needed. I strongly suspect that in 80-90% of the cases
the v4l driver does not actually need to use it and in the remaining 10-20% 
it can be replaced by a regular mutex.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
