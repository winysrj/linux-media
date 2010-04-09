Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4868 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab0DIG6q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Apr 2010 02:58:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: V4L2 and Media controller mini-summit in Helsinki 14.--16. June
Date: Fri, 9 Apr 2010 08:58:52 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Cohen <david.cohen@nokia.com>,
	"Koskipaa Antti (Nokia-D/Helsinki)" <antti.koskipaa@nokia.com>,
	"'vimarsh.zutshi@nokia.com'" <vimarsh.zutshi@nokia.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	Hans de Goede <hdegoede@redhat.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Zhang, Xiaolin" <xiaolin.zhang@intel.com>,
	Guru Raj <gururaj.nagendra@intel.com>
References: <4BBA3BC3.2060205@maxwell.research.nokia.com>
In-Reply-To: <4BBA3BC3.2060205@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004090858.52251.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 05 April 2010 21:36:35 Sakari Ailus wrote:
> Hello everyone,
> 
> I'm glad to announce Nokia will be hosting a V4L2 and Media controller
> mini-summit in Helsinki, Finland from 14th to 16th June --- that's from
> Monday to Wednesday. The event replaces the V4L2 Media Controller
> mini-summit in Oslo in April / May proposed by Hans Verkuil. Just the
> location is different; Hans is still responsible for the technical content.

Then I'd better start on that technical content :-)

Here is a short overview of the topics I want to put on the agenda (in no
particular order):

- Media controller progress. Especially with regards to the roadmap of getting
  this merged.

- Memory handling. See this link for a report on a preliminary meeting:
  http://www.mail-archive.com/linux-media@vger.kernel.org/msg16618.html
  It would be nice if we can spend some more time on the memory pool
  concept.

- V4L1 removal. We need to decide how we are going to do this. In particular
  the role that libv4l1 can play in this is of interest. Also: which
  unmaintained applications should we 'adopt' and convert from V4L1 to V4L2.

- Work on the V4L core framework: what is in place, what still needs to be
  done, what other parts can be moved to the core.

- Compliance tests. I'd like to start discussing this as well. I think we
  have to start work on a tool that will do basic compliance testing of new
  (and existing) drivers. The API is so big that it is way too easy to forget
  things. My guess is that at least 80% of all drivers violate the spec in
  one way or another. Relates as well to the framework topic: if we can move
  more into the core, then it is much easier to enforce spec compliance.

- Anything else someone wants to discuss?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
