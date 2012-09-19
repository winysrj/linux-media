Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:22427 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636Ab2ISQzE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 12:55:04 -0400
Received: from eusync3.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAL002VCWCF3340@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 19 Sep 2012 17:55:27 +0100 (BST)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MAL006FIWBQFI40@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 19 Sep 2012 17:55:03 +0100 (BST)
Message-id: <5059F8E6.1060100@samsung.com>
Date: Wed, 19 Sep 2012 18:55:02 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 2/6] videobuf2-core: use vb2_queue in
 __verify_planes_array
References: <1348065460-1624-1-git-send-email-hverkuil@xs4all.nl>
 <09515c88fe0760fddd124ec86995dc2cfdd56e7a.1348064901.git.hans.verkuil@cisco.com>
In-reply-to: <09515c88fe0760fddd124ec86995dc2cfdd56e7a.1348064901.git.hans.verkuil@cisco.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/19/2012 04:37 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Since num_planes has been moved to vb2_queue, the __verify_planes_array()
> function can now switch to a vb2_queue argument as well.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

