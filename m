Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42474 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab1EMOmo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2011 10:42:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCHv2] v4l: Add M420 format definition
Date: Fri, 13 May 2011 16:43:40 +0200
Cc: linux-media@vger.kernel.org
References: <1305277915-8383-1-git-send-email-laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1105131356410.26356@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1105131356410.26356@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105131643.41364.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Guennadi,

On Friday 13 May 2011 14:01:32 Guennadi Liakhovetski wrote:
> Couldn't spot any problems with the patch except:
> 
> On Fri, 13 May 2011, Laurent Pinchart wrote:
> > From: Hans de Goede <hdegoede@redhat.com>
> > 
> > M420 is an hybrid YUV 4:2:2 packet/planar format. Two Y lines are
> 
> Didn't you mean "4:2:0"?

Yep. I'll fix that. Thanks for the review.

> And if I wanted to nit-pick, I think, it should be "a hybrid," I'm not a
> native-speaker though;)

I'll fix that too :-)

-- 
Regards,

Laurent Pinchart
