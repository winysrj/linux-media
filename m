Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4369 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab1KXIr7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 03:47:59 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <snjw23@gmail.com>
Subject: Re: [Query] V4L2 Integer (?) menu control
Date: Thu, 24 Nov 2011 09:47:22 +0100
Cc: "linux-media" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
References: <4ECD730E.3080808@gmail.com>
In-Reply-To: <4ECD730E.3080808@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111240947.22895.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, November 23, 2011 23:26:22 Sylwester Nawrocki wrote:
> Hi,
> 
> I was wondering how to implement in v4l2 a standard menu control having integer 
> values as the menu items. The menu item values would be irregular, e.g. ascending
> logarithmically and thus the step value would not be a constant.
> I'm not interested in private control and symbolic enumeration for each value at
> the series. It should be a standard control where drivers could define an array 
> of integers reflecting the control menu items. And then the applications could
> enumerate what integer values are valid and can be happily applied to a device.  
> 
> I don't seem to find a way to implement this in current v4l2 control framework. 
> Such functionality isn't there, or is it ?

No it doesn't exist.

I'd have sworn that I saw a proposal for adding something like that on the
mailinglist some time ago, but I can't find it anymore. It wouldn't be
difficult to add.

Regards,

	Hans
