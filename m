Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D653EC282C5
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 20:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A43A1217D7
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 20:14:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="P5KXRuLH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730336AbfAXUOW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 15:14:22 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35352 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729658AbfAXUOV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 15:14:21 -0500
Received: by mail-qt1-f194.google.com with SMTP id v11so8230865qtc.2
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 12:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=/eLWF2nBpm4xYIb4J+nXrGXHgxha/99iWqDqjCF/hxo=;
        b=P5KXRuLHrM1JXw/KPqJrZ56CtTGz/p65b9igENNu130Zl7tjMfvMNqltUxMSlxRza0
         A2gG722/oO9+UCYEzggDE7D7sMKNbuWnhag25c3hWzGWc/DpuB6GydkuIgZk/X5YfYop
         WNw8zqLVLOAUNBIEW/TeLEwKu5GA59cQ6M9AQDKWlT/3zobTCt6XB20VQ7uOOlFPSwbX
         h7WynjvTiOwquXraaQH8r6i+1tMiAAZ0WluRqvRbfANEVShwbktHlB8nIMZaFBkqtJbW
         uXgQEdFrpktsoZtkuKBVajv/8Xcdw2ORyNxgUsBeJbj9UzJLnGQtFJHsES7alvWXazvn
         6qtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=/eLWF2nBpm4xYIb4J+nXrGXHgxha/99iWqDqjCF/hxo=;
        b=d+ZfBzWqk8QQUiPXukCHwJvXbMxS+I8lYr2uDkN/xWACBcIoZIfrlJ8TjRNl7szt8Q
         xW4hHLGVJRuglPCKGMXrYtLny7MmlocdbGCgnvXlwKTRzKkWUvK2IFrwkbff4q9U0mrj
         6+RxW0zlj0NBUR5Lbh3GKWo/3pvLhTNjI6noDzGDhJT69CE/XijYiPhGs9vgHp0kv7YF
         xChpQkeeTJg53NXJJqA9f4KbES5aj7IGN96PSRUgm3kVk/72QXgL2tUmQWGYxB+JQYxZ
         5KL4XTYfxEM7dQkDcy76j9F3zEpqYFuLN4BEQuzlpFktnOoGQgaJqMNQM9mWOSaOY/gI
         FU1w==
X-Gm-Message-State: AJcUukcbWE0JJSRKit+a6IIzUHVGfRbXUn8EHfUwKVxB9pC6dHSdwowi
        6du8M0+/p9DkvRAsSlV6LAxUvw==
X-Google-Smtp-Source: ALg8bN7sCPqhhuhQLqnV3zzkNz/+DQAxZbBpMvkozYAsPmK1x1StShsRhRfWSdDb8EAnlV+Z0zpdvw==
X-Received: by 2002:aed:2f82:: with SMTP id m2mr8375505qtd.4.1548360860574;
        Thu, 24 Jan 2019 12:14:20 -0800 (PST)
Received: from skullcanyon ([192.222.193.21])
        by smtp.gmail.com with ESMTPSA id r24sm77410788qtr.2.2019.01.24.12.14.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Jan 2019 12:14:19 -0800 (PST)
Message-ID: <0452db20a894c1c4cce263b7e07ba274a58aa8fa.camel@ndufresne.ca>
Subject: Re: [PATCH v2 2/2] media: docs-rst: Document memory-to-memory video
 encoder interface
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Hans Verkuil <hverkuil@xs4all.nl>, Tomasz Figa <tfiga@chromium.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?Q?Pawe=C5=82_O=C5=9Bciak?= <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Jourdan <maxi.jourdan@wanadoo.fr>
Date:   Thu, 24 Jan 2019 15:14:18 -0500
In-Reply-To: <75334288-69af-6680-fbe7-2dd5ef2462ea@xs4all.nl>
References: <20181022144901.113852-1-tfiga@chromium.org>
         <20181022144901.113852-3-tfiga@chromium.org>
         <4cd223f0-b09c-da07-f26c-3b3f7a8868d7@xs4all.nl>
         <CAAFQd5DthE3vL+gycEBgm+aF0YhRncrfBVBNLLF4g+oKhBHEWQ@mail.gmail.com>
         <75334288-69af-6680-fbe7-2dd5ef2462ea@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4 (3.30.4-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Le mercredi 23 janvier 2019 à 14:04 +0100, Hans Verkuil a écrit :
> > > Does this return the same set of formats as in the 'Querying Capabilities' phase?
> > > 
> > 
> > It's actually an interesting question. At this point we wouldn't have
> > the OUTPUT resolution set yet, so that would be the same set as in the
> > initial query. If we set the resolution (with some arbitrary
> > pixelformat), it may become a subset...
> 
> But doesn't setting the capture format also set the resolution?
> 
> To quote from the text above:
> 
> "The encoder will derive a new ``OUTPUT`` format from the ``CAPTURE`` format
>  being set, including resolution, colorimetry parameters, etc."
> 
> So you set the capture format with a resolution (you know that), then
> ENUM_FMT will return the subset for that codec and resolution.
> 
> But see also the comment at the end of this email.

I'm thinking that the fact that there is no "unset" value for pixel
format creates a certain ambiguity. Maybe we could create a new pixel
format, and all CODEC driver could have that set by default ? Then we
can just fail STREAMON if that format is set.

That being said, in GStreamer, I have split each elements per CODEC,
and now only enumerate the information "per-codec". That makes me think
this "global" enumeration was just a miss-use of the API / me learning
to use it. Not having to implement this rather complex thing in the
driver would be nice. Notably, the new Amlogic driver does not have
this "Querying Capabilities" phase, and with latest GStreamer works
just fine.

Nicolas

