Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:42137 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439Ab0DEWdR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Apr 2010 18:33:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: RFC: new V4L control framework
Date: Tue, 6 Apr 2010 00:34:00 +0200
Cc: linux-media@vger.kernel.org
References: <201004041741.51869.hverkuil@xs4all.nl>
In-Reply-To: <201004041741.51869.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004060034.01223.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sunday 04 April 2010 17:41:51 Hans Verkuil wrote:
> Hi all,
> 
> The support in drivers for the V4L2 control API is currently very chaotic.
> Few if any drivers support the API correctly. Especially the support for
> the new extended controls is very much hit and miss.
> 
> Combine that with the requirements for the upcoming embedded devices that
> will want to use controls much more actively and you end up with a big
> mess.
> 
> I've wanted to fix this for a long time and last week I finally had the
> time.
> 
> The new framework works like a charm and massively reduces the complexity
> in drivers when it comes to control handling. And just as importantly, any
> driver that uses it is fully compliant to the V4L spec. Something that
> application writers will appreciate.

Thanks for working on this.

[snip]

> There is one thing though that needs to be proven first: can uvc use it as
> well? The UVC driver is unusual in that it can dynamically add controls.
> 
> The framework should be able to handle this, but it would be great if
> Laurent can take a good look at it.

I really wish I could do it now, but I won't have time to work on this before 
two weeks. I'm sorry about that.

-- 
Regards,

Laurent Pinchart
