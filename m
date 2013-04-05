Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21279 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab3DEJTR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Apr 2013 05:19:17 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MKR00LXFZ5NR250@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 05 Apr 2013 10:19:14 +0100 (BST)
Message-id: <515E9711.3090302@samsung.com>
Date: Fri, 05 Apr 2013 11:19:13 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	dh09.lee@samsung.com, prabhakar.lad@ti.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de
Subject: Re: [PATCH v7] [media] Add common video interfaces OF bindings
 documentation
References: <1364313495-18635-1-git-send-email-s.nawrocki@samsung.com>
 <515DE661.2050902@wwwdotorg.org>
In-reply-to: <515DE661.2050902@wwwdotorg.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/04/2013 10:45 PM, Stephen Warren wrote:
> On 03/26/2013 09:58 AM, Sylwester Nawrocki wrote:
>> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>>
>> This patch adds a document describing common OF bindings for video
>> capture, output and video processing devices. It is curently mainly
>> focused on video capture devices, with data busses defined by
>> standards such as ITU-R BT.656 or MIPI-CSI2.
>> It also documents a method of describing data links between devices.
>>
>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> 
> Acked-by: Stephen Warren <swarren@nvidia.com>

Thanks Stephen, this patch is already queued for 3.10 in the media
tree. Hence unfortunately I cannot add more tags to it.


