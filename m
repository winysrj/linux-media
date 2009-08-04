Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1802 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932787AbZHDRkw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2009 13:40:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: Linux Plumbers Conference 2009: V4L2 API discussions
Date: Tue, 4 Aug 2009 19:40:39 +0200
Cc: davinci-linux-open-source@linux.davincidsp.com,
	linux-omap@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>,
	eduardo.valentin@nokia.com
References: <200908040912.24718.hverkuil@xs4all.nl>
In-Reply-To: <200908040912.24718.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908041940.40601.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 04 August 2009 09:12:24 Hans Verkuil wrote:
> Hi all,
> 
> During this years Plumbers Conference I will be organizing a session (or
> possibly more than one) on what sort of new V4L2 APIs are needed to
> support the new SoC devices. These new APIs should also solve the problem
> of how to find all the related alsa/fb/ir/dvb devices that a typical video
> device might create.
> 
> A proposal was made about a year ago (note that this is a bit outdated
> by now, but the basics are still valid):
> 
> http://www.archivum.info/video4linux-list%40redhat.com/2008-07/msg00371.html
> 
> In the past year the v4l2 core has evolved enough so that we can finally
> start thinking about this for real.
> 
> I would like to know who will be attending this conference. I also urge
> anyone who is working in this area and who wants to have a say in this to
> attend the conference. The goal is to prepare a new RFC with a detailed
> proposal on the new APIs that are needed to fully support all the new
> SoCs. So the more input we get, the better the end-result will be.
> 
> Early-bird registration is still possible up to August 5th (that's
> tomorrow :-) ).

Just a quick follow-up: I am also attending the co-located LinuxCon
(http://events.linuxfoundation.org/events/linuxcon), so I'm in Portland the
whole week. If someone is there only for LinuxCon but still wants to discuss
something with me, then let me know beforehand. Ditto if you prefer to have
some preliminary discussions before the Plumbers Conference starts.

I will also update the RFC referred to above and repost it early September.
That way we have a proper starting point for our discussions.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
