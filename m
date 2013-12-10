Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:50302 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab3LJMR3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 07:17:29 -0500
Received: by mail-we0-f175.google.com with SMTP id t60so4826495wes.20
        for <linux-media@vger.kernel.org>; Tue, 10 Dec 2013 04:17:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+V-a8v=DS=nNQuBpVMaQMY-j_t=JRPLz78=07bGdMG-nnJ4-g@mail.gmail.com>
References: <1386596592-48678-1-git-send-email-hverkuil@xs4all.nl>
 <1386596592-48678-8-git-send-email-hverkuil@xs4all.nl> <52A6C807.6040102@xs4all.nl>
 <CA+V-a8v=DS=nNQuBpVMaQMY-j_t=JRPLz78=07bGdMG-nnJ4-g@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 10 Dec 2013 17:47:06 +0530
Message-ID: <CA+V-a8sVkK-sKJgqASVxAbHe81FwndBW==cffJM4dNBoBqoPXA@mail.gmail.com>
Subject: Re: [RFCv4 PATCH 7/8] vb2: return ENODATA in start_streaming in case
 of too few buffers.
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 10, 2013 at 3:26 PM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:
> Hi Hans,
>
> On Tue, Dec 10, 2013 at 1:21 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> As Guennadi mentioned in his review, ENODATA will be replaced by ENOBUFS, which is
>> more appropriate.
>>
>> Prabhakar, Kamil, Tomasz, are you OK with this patch provided s/ENODATA/ENOBUFS/ ?
>>
> +1 for ENOBUFS.
>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regrads,
--Prabhakar Lad
