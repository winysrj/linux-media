Return-path: <mchehab@gaivota>
Received: from moutng.kundenserver.de ([212.227.17.9]:50606 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab1EMMBe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2011 08:01:34 -0400
Date: Fri, 13 May 2011 14:01:32 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCHv2] v4l: Add M420 format definition
In-Reply-To: <1305277915-8383-1-git-send-email-laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1105131356410.26356@axis700.grange>
References: <1305277915-8383-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Couldn't spot any problems with the patch except:

On Fri, 13 May 2011, Laurent Pinchart wrote:

> From: Hans de Goede <hdegoede@redhat.com>
> 
> M420 is an hybrid YUV 4:2:2 packet/planar format. Two Y lines are

Didn't you mean "4:2:0"? And if I wanted to nit-pick, I think, it should 
be "a hybrid," I'm not a native-speaker though;)

Thanks
Guennadi

> followed by an interleaved U/V line.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
