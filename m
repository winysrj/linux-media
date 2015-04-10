Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:57979 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbbDJJuw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2015 05:50:52 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NML00LMK4VABA40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Apr 2015 10:54:46 +0100 (BST)
Message-id: <55279CF7.4040800@samsung.com>
Date: Fri, 10 Apr 2015 11:50:47 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v4 3/4] v4l: of: Parse variable length properties ---
 link-frequencies
References: <1428614706-8367-1-git-send-email-sakari.ailus@iki.fi>
 <1428614706-8367-4-git-send-email-sakari.ailus@iki.fi>
In-reply-to: <1428614706-8367-4-git-send-email-sakari.ailus@iki.fi>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/04/15 23:25, Sakari Ailus wrote:
> The link-frequencies property is a variable length array of link frequencies
> in an endpoint. The array is needed by an increasing number of drivers, so
> it makes sense to add it to struct v4l2_of_endpoint.
> 
> However, the length of the array is variable and the size of struct
> v4l2_of_endpoint is fixed since it is allocated by the caller. The options
> here are
> 
> 1. to define a fixed maximum limit of link frequencies that has to be the
> global maximum of all boards. This is seen as problematic since the maximum
> could be largish, and everyone hitting the problem would need to submit a
> patch to fix it, or
> 
> 2. parse the property in every driver. This doesn't sound appealing as two
> of the three implementations submitted to linux-media were wrong, and one of
> them was even merged before this was noticed, or
> 
> 3. change the interface so that allocating and releasing memory according to
> the size of the array is possible. This is what the patch does.
> 
> v4l2_of_alloc_parse_endpoint() is just like v4l2_of_parse_endpoint(), but it
> will allocate the memory resources needed to store struct v4l2_of_endpoint
> and the additional arrays pointed to by this struct. A corresponding release
> function v4l2_of_free_endpoint() is provided to release the memory allocated
> by v4l2_of_alloc_parse_endpoint().
> 
> In addition to this, the link-frequencies property is parsed as well, and
> the result is stored to struct v4l2_of_endpoint field link_frequencies.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

It's a bit sad we need to introduce the ERR_PTR() patter, nevertheless
I can't see a better alternative now. I think in long term we need to
get rid of v4l2_of_parse_endpoint() function.

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

-- 
Regards,
Sylwester
