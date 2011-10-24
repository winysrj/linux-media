Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55889 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab1JXU4E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Oct 2011 16:56:04 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LTL0098W8TDB9@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 24 Oct 2011 21:56:01 +0100 (BST)
Received: from [127.0.0.1] ([106.10.22.2])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LTL00FD78T7DD@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 24 Oct 2011 21:56:01 +0100 (BST)
Date: Mon, 24 Oct 2011 22:55:56 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: Reqbufs(0) need to release queued_list
In-reply-to: <CABbt3s68q_jKf9bHPT8kuaB6donrAzmucJJseWNiX88qud273g@mail.gmail.com>
To: Angela Wan <angela.j.wan@gmail.com>
Cc: pawel@osciak.com, linux-media@vger.kernel.org, leiwen@marvell.com,
	ytang5@marvell.com, qingx@marvell.com, jwan@marvell.com
Message-id: <4EA5D0DC.6000209@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <CABbt3s68q_jKf9bHPT8kuaB6donrAzmucJJseWNiX88qud273g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2011-10-24 05:25, Angela Wan wrote:

>     As I have used videobuf2+soc_camera architecture on my camera
> driver. I find a problem when I use Reqbuf(0), which only release
> buffer, but not clear queued_list.

Thanks for pointing this bug. I will post a fix ASAP.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

