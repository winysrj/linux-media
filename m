Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:48960 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab3JHKAa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Oct 2013 06:00:30 -0400
Message-id: <5253D7BB.3020701@samsung.com>
Date: Tue, 08 Oct 2013 12:00:27 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vb2: Allow STREAMOFF for io emulator
References: <1380894598-11242-1-git-send-email-ricardo.ribalda@gmail.com>
 <5253B2BE.5090209@samsung.com>
 <CAPybu_0-b2BfuTVd09B4dreFHCsYSg=SjjrDCHXKrqNGzFSX2w@mail.gmail.com>
In-reply-to: <CAPybu_0-b2BfuTVd09B4dreFHCsYSg=SjjrDCHXKrqNGzFSX2w@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Racardo,

On 2013-10-08 09:58, Ricardo Ribalda Delgado wrote:
> Hi Marek
>
> Thanks for your comments. I was just trying to find a way to stop
> streaming while in read/write mode without having to close the
> descriptor. I thought reusing streamoff was more clever than creating
> a new ioctl.

Read()/write() mode is mainly designed for old and legacy applications. 
Those applications assume that the only reliable way to stop streaming 
is to close the fd. New tools should use libv4l and ioctl-based api.

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland

