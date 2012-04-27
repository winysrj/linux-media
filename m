Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56200 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab2D0H7V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 03:59:21 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M34006Q9OSCV0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 08:57:48 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M34005OOOUS42@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 08:59:16 +0100 (BST)
Date: Fri, 27 Apr 2012 09:59:18 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [GIT PULL FOR v3.5] Fix for a DocBook typo
In-reply-to: <201204261303.33224.hverkuil@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4F9A51D6.9080601@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <201204261303.33224.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/26/2012 01:03 PM, Hans Verkuil wrote:
> The following changes since commit aa6d5f29534a6d1459f9768c591a7a72aadc5941:
> 
>   [media] pluto2: remove some dead code (2012-04-19 17:15:32 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git docfix
> 
> for you to fetch changes up to fada845c248be56ddba1f58a0ca69d335a22712e:
> 
>   V4L2 Spec: fix typo. (2012-04-26 12:39:14 +0200)
> 
> ----------------------------------------------------------------
> Hans Verkuil (1):
>       V4L2 Spec: fix typo.
> 
>  Documentation/DocBook/media/v4l/controls.xml |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Oops, mu fault. Thanks for spotting this. Would be nice to have it in 3.4-rc,
this way there wouldn't be those typos in any final kernel release.


Regards,
Sylwester

