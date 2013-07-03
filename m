Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51600 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933022Ab3GCXzG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jul 2013 19:55:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 0/2] V4L2 OF fixes
Date: Thu, 04 Jul 2013 01:55:36 +0200
Message-ID: <1555542.WtcKWfQS8o@avalon>
In-Reply-To: <51D48B4C.3070809@gmail.com>
References: <1372848769-6390-1-git-send-email-laurent.pinchart@ideasonboard.com> <51D48B4C.3070809@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Wednesday 03 July 2013 22:36:28 Sylwester Nawrocki wrote:
> On 07/03/2013 12:52 PM, Laurent Pinchart wrote:
> > Hello,
> > 
> > Here are two small fixes for the V4L2 OF parsing code. The patches should
> > be self-explanatory.
> 
> Hi Laurent,
> 
> Thank you for fixing what I've messed up in the Guennadi's original patch.
> For both patches:
> 
>   Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

No worries :-) Thanks for your ack.

> 
> > Laurent Pinchart (2):
> >    v4l: of: Use of_get_child_by_name()
> >    v4l: of: Drop acquired reference to node when getting next endpoint
> >   
> >   drivers/media/v4l2-core/v4l2-of.c | 9 +++------
> >   1 file changed, 3 insertions(+), 6 deletions(-)

-- 
Regards,

Laurent Pinchart

