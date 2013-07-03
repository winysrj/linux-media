Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:58426 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933205Ab3GCUgc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jul 2013 16:36:32 -0400
Received: by mail-bk0-f52.google.com with SMTP id d7so286488bkh.39
        for <linux-media@vger.kernel.org>; Wed, 03 Jul 2013 13:36:31 -0700 (PDT)
Message-ID: <51D48B4C.3070809@gmail.com>
Date: Wed, 03 Jul 2013 22:36:28 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 0/2] V4L2 OF fixes
References: <1372848769-6390-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1372848769-6390-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/03/2013 12:52 PM, Laurent Pinchart wrote:
> Hello,
>
> Here are two small fixes for the V4L2 OF parsing code. The patches should be
> self-explanatory.

Hi Laurent,

Thank you for fixing what I've messed up in the Guennadi's original patch.
For both patches:

  Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> Laurent Pinchart (2):
>    v4l: of: Use of_get_child_by_name()
>    v4l: of: Drop acquired reference to node when getting next endpoint
>
>   drivers/media/v4l2-core/v4l2-of.c | 9 +++------
>   1 file changed, 3 insertions(+), 6 deletions(-)

Thanks,
Sylwester
