Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24298 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761234Ab3DBPYb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 11:24:31 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MKM00LTXW4AYP90@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Apr 2013 16:24:30 +0100 (BST)
Message-id: <515AF82D.1010902@samsung.com>
Date: Tue, 02 Apr 2013 17:24:29 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com
Subject: Re: [PATCH] V4L: Remove incorrect EXPORT_SYMBOL() usage at v4l2-of.c
References: <1364913818-7970-1-git-send-email-s.nawrocki@samsung.com>
 <Pine.LNX.4.64.1304021652021.31999@axis700.grange>
In-reply-to: <Pine.LNX.4.64.1304021652021.31999@axis700.grange>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 04/02/2013 04:54 PM, Guennadi Liakhovetski wrote:
> On Tue, 2 Apr 2013, Sylwester Nawrocki wrote:
> 
>> > v4l2_of_parse_parallel_bus() function is now static and
>> > EXPORT_SYMBOL() doesn't apply to it any more. Drop this
>> > meaningless statement, which was supposed to be done in
>> > the original merged patch.
>> > 
>> > While at it, edit the copyright notice so it is sorted in
>> > both the v4l2-of.c and v4l2-of.h file in newest entries
>> > on top order, and state clearly I'm just the author of
>> > parts of the code, not the copyright owner.
>> > 
>> > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>
> This is not concerning the contents of this patch, but rather the form 
> confuses me a bit - the two above Sob's: you are the author, and you're 
> sending the patch to the list, but Kyungmin Park's Sob is the last in the 
> list, which to me means that your patch went via his tree, but it's you 
> who's sending it?... I think I saw this pattern in some other your patches 
> too. What exactly does this mean?

This means just that Kyungmin approves the patch submission as our manager
and the internal tree maintainer. He is not necessarily directly involved
in the development of a patch. As you probably noticed his Signed-off is
on patches from all our team members. I agree it is not immediately obvious
what's going on here. This has been discussed in the past few times. For
instance please refer to this thread:

http://www.spinics.net/lists/linux-usb/msg74981.html

--

Regards,
Sylwester
