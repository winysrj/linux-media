Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1663 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaCZIuY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Mar 2014 04:50:24 -0400
Message-ID: <5332948E.4040506@xs4all.nl>
Date: Wed, 26 Mar 2014 09:49:18 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Tom <Bassai_Dai@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: why frameformat instead pixelformat?
References: <loom.20140324T174253-993@post.gmane.org>
In-Reply-To: <loom.20140324T174253-993@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/24/14 17:52, Tom wrote:
> Hello,
> 
> while reading into the media-api issue I found out that for configuring the 
> entity pads a frameformat is used.
> 
> For that I found the negotiation rfc of that topic, but I don't really get 
> the relevance of a frameformat.
> 
> http://www.spinics.net/lists/linux-media/msg10006.html
> 
> Can anyone explain why the media-api uses the frameformat instead of the 
> pixelformat and what the main differences are?

The pixelformat describes the image format in memory, the mbus_framefmt
describes the image data as it is transferred over a hardware bus.

It's as simple as that. While the two are related (i.e. to get a certain
pixelformat you probably need to set up a specific mbus_framefmt), the
details of this relationship are board or even use-case dependent.

Regards,

	Hans
