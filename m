Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:40981 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114AbaKPMlf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Nov 2014 07:41:35 -0500
Received: by mail-la0-f45.google.com with SMTP id gm9so389252lab.4
        for <linux-media@vger.kernel.org>; Sun, 16 Nov 2014 04:41:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1415623771-29634-3-git-send-email-hverkuil@xs4all.nl>
References: <1415623771-29634-1-git-send-email-hverkuil@xs4all.nl> <1415623771-29634-3-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Sun, 16 Nov 2014 20:34:03 +0800
Message-ID: <CAMm-=zDB6ic3mHpsJKwzzTDsFUOUAm-D+arTkyEjaThcYANa4g@mail.gmail.com>
Subject: Re: [RFCv6 PATCH 02/16] vb2: replace 'write' by 'dma_dir'
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 10, 2014 at 8:49 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> The 'write' argument is very ambiguous. I first assumed that if it is 1,
> then we're doing video output but instead it meant the reverse.
>
> Since it is used to setup the dma_dir value anyway it is now replaced by
> the correct dma_dir value which is unambiguous.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Pawel Osciak <pawel@osciak.com>

-- 
Best regards,
Pawel Osciak
