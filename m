Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A51BC282C0
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 05:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0FA4218D2
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 05:07:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="F3lDethz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbfAYFHk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 25 Jan 2019 00:07:40 -0500
Received: from mail-oi1-f175.google.com ([209.85.167.175]:46331 "EHLO
        mail-oi1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbfAYFHk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Jan 2019 00:07:40 -0500
Received: by mail-oi1-f175.google.com with SMTP id x202so6798598oif.13
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 21:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SVk6PpSa7qAHm7aAiACjjjZ5bj3uz71MtT6HUO7y4RI=;
        b=F3lDethz/t0BkMbaIHbNJf5Bt2HHTzqT2ChA1QbJHe4cyZUs+kwBYt/Th6ArQIn8Y7
         TXVnNcxi37L3no+7AOhavxZdNgMEX0UkYqbi3HVB+C4Z/Fyr7QaFH4czemQJeHzhO7Yq
         YwzcAofiLhw55auIRHzUfe6HQjN4YNc/XqQkQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SVk6PpSa7qAHm7aAiACjjjZ5bj3uz71MtT6HUO7y4RI=;
        b=L5lkCONk5YE2R0htZy4CyfUz8HFzyZnEUcjxpE8S16/VhunVXQGhXSDaIrB8Y/4DEx
         qVUqrEOIZ9Pvw/HLwqWsmCPmPUaSRW5j/Y53Vr8q5SIBwtpfk8EdZdFnTcN3yPRymM+/
         /ToZ9jH1D/EgLG3ZQ9LzPUGu9OmOojb8GvLaNTqs89hZN22q7J8t6dG9Y3M+kHA6eV64
         7GSTwfzu+RpRKvg+FnRNYaoonlivzW/3la96pavEKKJXTLkefK0HrQ6ZkJ3U3weSTfCS
         3nvPv/mnRtcT23dP5cxc3fQ9x6l49cQfak2OIovpBMIvYqZo24IbQYz42ITgB78ocYzC
         QlAA==
X-Gm-Message-State: AHQUAuZTplAbPCmTY0WMv3OHOAM3wYiBHVTZmFoJnktbEEQwWeK4QbzN
        8e+on6SSiylruf3oAaBJ0zRjLBMOBfK7iw==
X-Google-Smtp-Source: AHgI3IYbx14L/wfFyQaV9pLPsdQjUOERcwqj+X6xGrUhA7uktrUFmxkj0mIcs4cGo4t3CBI3bJbO3A==
X-Received: by 2002:aca:3c06:: with SMTP id j6mr391443oia.126.1548392858698;
        Thu, 24 Jan 2019 21:07:38 -0800 (PST)
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com. [209.85.210.54])
        by smtp.gmail.com with ESMTPSA id c9sm877246otb.38.2019.01.24.21.07.37
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 21:07:38 -0800 (PST)
Received: by mail-ot1-f54.google.com with SMTP id k98so7475855otk.3
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 21:07:37 -0800 (PST)
X-Received: by 2002:a05:6830:1193:: with SMTP id u19mr6715966otq.152.1548392857521;
 Thu, 24 Jan 2019 21:07:37 -0800 (PST)
MIME-Version: 1.0
References: <20181119110903.24383-1-hverkuil@xs4all.nl> <20181119110903.24383-5-hverkuil@xs4all.nl>
In-Reply-To: <20181119110903.24383-5-hverkuil@xs4all.nl>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Fri, 25 Jan 2019 14:07:26 +0900
X-Gmail-Original-Message-ID: <CAAFQd5Cmaq7+UDMki3Vj8Q-CXmw8fKHjtfnkiNmQWDFTFMygZQ@mail.gmail.com>
Message-ID: <CAAFQd5Cmaq7+UDMki3Vj8Q-CXmw8fKHjtfnkiNmQWDFTFMygZQ@mail.gmail.com>
Subject: Re: [PATCHv2 4/4] vivid: add queue_setup_(un)lock ops
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Nov 19, 2018 at 8:09 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Add these ops to serialize queue_setup with VIDIOC_S_FMT.
>
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  drivers/media/platform/vivid/vivid-core.c    | 14 ++++++++++++++
>  drivers/media/platform/vivid/vivid-core.h    |  3 +++
>  drivers/media/platform/vivid/vivid-sdr-cap.c |  2 ++
>  drivers/media/platform/vivid/vivid-vbi-cap.c |  2 ++
>  drivers/media/platform/vivid/vivid-vbi-out.c |  2 ++
>  drivers/media/platform/vivid/vivid-vid-cap.c |  2 ++
>  drivers/media/platform/vivid/vivid-vid-out.c |  2 ++
>  7 files changed, 27 insertions(+)
>

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz
