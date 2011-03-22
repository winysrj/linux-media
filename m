Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50625 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab1CVJWM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 05:22:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC PATCH RESEND v2 2/3] v4l2-ctrls: modify uvc driver to use new menu type of V4L2_CID_FOCUS_AUTO
Date: Tue, 22 Mar 2011 10:22:28 +0100
Cc: riverful.kim@samsung.com,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"???/Mobile S/W Platform Lab(DMC?)/E4(??)/????"
	<sw0312.kim@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
References: <4D6EFA00.80009@samsung.com> <201103031110.44920.laurent.pinchart@ideasonboard.com> <4D87ED00.1050406@redhat.com>
In-Reply-To: <4D87ED00.1050406@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103221022.28563.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Tuesday 22 March 2011 01:27:44 Mauro Carvalho Chehab wrote:
> Em 03-03-2011 07:10, Laurent Pinchart escreveu:
> > On Thursday 03 March 2011 03:16:32 Kim, HeungJun wrote:
> >> As following to change the boolean type of V4L2_CID_FOCUS_AUTO to menu
> >> type, this uvc is modified the usage of V4L2_CID_FOCUS_AUTO, maintaining
> >> v4l2 menu index.
> >> 
> >> Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > 
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> I'm assuming that you'll be applying those patches on your tree and sending
> me a pull request, right?

The patch depends on other V4L2 core patches in the same series, so I wasn't 
planning to push it through my tree, but it can be done. There are still 
issues with this series though, as we haven't reached an agreement on the 
auto-focus ABI yet.

-- 
Regards,

Laurent Pinchart
