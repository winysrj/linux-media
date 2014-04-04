Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4728 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbaDDKBn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Apr 2014 06:01:43 -0400
Message-ID: <533E82E6.4020209@xs4all.nl>
Date: Fri, 04 Apr 2014 12:01:10 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: pawel@osciak.com, s.nawrocki@samsung.com, sakari.ailus@iki.fi,
	m.szyprowski@samsung.com
Subject: Re: vb2: various small fixes/improvements
References: <1394486458-9836-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1394486458-9836-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Can someone review this? That would be much appreciated!

Regards,

	Hans

On 03/10/2014 10:20 PM, Hans Verkuil wrote:
> This patch series contains a list of various vb2 fixes and improvements.
> 
> These patches were originally part of this RFC patch series:
> 
> http://www.spinics.net/lists/linux-media/msg73391.html
> 
> They are now rebased and reordered a bit. It's little stuff for the
> most part, although the first patch touches on more drivers since it
> changes the return type of stop_streaming to void. The return value was
> always ignored by vb2 and you really cannot do anything sensible with it.
> In general resource allocations can return an error, but freeing up resources
> should not. That should always succeed.
> 
> Regards,
> 
> 	Hans
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

