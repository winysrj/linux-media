Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55241 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab1DHOcu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 10:32:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC/PATCH 1/2] v4l: videobuf2: Handle buf_queue errors
Date: Fri, 8 Apr 2011 16:32:53 +0200
Cc: "'Sylwester Nawrocki'" <snjw23@gmail.com>,
	"'Pawel Osciak'" <pawel@osciak.com>, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl
References: <1298830353-9797-1-git-send-email-laurent.pinchart@ideasonboard.com> <201104081453.21999.laurent.pinchart@ideasonboard.com> <000001cbf5ee$21cbff70$6563fe50$%szyprowski@samsung.com>
In-Reply-To: <000001cbf5ee$21cbff70$6563fe50$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104081632.53536.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Marek,

On Friday 08 April 2011 15:09:02 Marek Szyprowski wrote:
> On Friday, April 08, 2011 2:53 PM Laurent Pinchart wrote:

[snip]

> > buf_queue is called with a spinlock help, so you can't perform I2C
> > communication there.
> 
> In videobuf2 buf_queue() IS NOT called with any spinlock held. buf_queue
> can call functions that require sleeping. This makes a lot of sense
> especially for drivers that need to perform a lot of operations for
> enabling/disabling hardware.

Oops, my bad.

> I remember we discussed your solution where you wanted to add a spinlock
> for calling buf_queue. This case shows one more reason not go that way. :)

Hehe. I totally agree with you that we should avoid locking wherever possible. 
We still have no solution for the disconnection problem though.

> AFAIR buf_queue callback in old videobuf was called with spinlock held.

That's correct, yes.

> I agree that we definitely need more documentation for vb2 and clarification
> what is allowed in each callback...

-- 
Regards,

Laurent Pinchart
