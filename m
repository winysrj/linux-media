Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81ED6C43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 02:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A4A2205C9
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 02:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbfAQCpZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 21:45:25 -0500
Received: from mail-ed1-f54.google.com ([209.85.208.54]:38196 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfAQCpZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 21:45:25 -0500
Received: by mail-ed1-f54.google.com with SMTP id h50so7148958ede.5
        for <linux-media@vger.kernel.org>; Wed, 16 Jan 2019 18:45:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4DHlPugfzhluIjEt9W++YzJGyNr4JmVSXvNCgQh/5c8=;
        b=QQhmGv8nmgjfLfh4edaIqq9WLHi/cs1EZW6paywClDPONT0vd/hPgkFOw3owyI0VDU
         1IuiLHQTGe2WKMXNrLgGpSRh71lANVKxfIt5XphTBz8H4y57pjHNegTBeQxhrV0RvFgP
         v7xMuMCACIZA7+n+AMxrVqVIPYh1nbhr1eWMGpWi8Qc2vVwE+bqo6PnNXzs4F4aA7xdL
         Ah+uttp7iZShbaSy58gn8R/JbRDgs/LgsndnPJnqQdTU7zN1AmugGqn+bXvjJ0BvkicY
         UKT5GRkU4ErrZQBcZkLuncI4KqQKgeitAh3vgmE8B3r1L0MxXUz+YCAYUaardWhFjP5u
         QOxA==
X-Gm-Message-State: AJcUukdQjyF7/CXO0CMIutpFeljBL7DPfJ+a75IYlB7NXqT3P4amPuvc
        DkbgZkXe6qc5gzo743oSlYNbvtj2300=
X-Google-Smtp-Source: ALg8bN75fQZRBlzk9+1jrKGR0jMPXIwCIXp22bvN9vXzGPBeDk4+rcSdzMX0+8HhVov3/eN3HqdkCw==
X-Received: by 2002:a17:906:138d:: with SMTP id f13-v6mr8964155ejc.176.1547693123175;
        Wed, 16 Jan 2019 18:45:23 -0800 (PST)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com. [209.85.221.51])
        by smtp.gmail.com with ESMTPSA id x47sm6047404eda.91.2019.01.16.18.45.22
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Jan 2019 18:45:23 -0800 (PST)
Received: by mail-wr1-f51.google.com with SMTP id t6so9207568wrr.12
        for <linux-media@vger.kernel.org>; Wed, 16 Jan 2019 18:45:22 -0800 (PST)
X-Received: by 2002:adf:891a:: with SMTP id s26mr9802232wrs.44.1547693122490;
 Wed, 16 Jan 2019 18:45:22 -0800 (PST)
MIME-Version: 1.0
References: <E1gjq1q-0002RQ-B4@www.linuxtv.org>
In-Reply-To: <E1gjq1q-0002RQ-B4@www.linuxtv.org>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Thu, 17 Jan 2019 10:45:11 +0800
X-Gmail-Original-Message-ID: <CAGb2v64nWOZ4ycEYZxUzZUXub9QLvdjdaojGdPeqjuO9hxih5Q@mail.gmail.com>
Message-ID: <CAGb2v64nWOZ4ycEYZxUzZUXub9QLvdjdaojGdPeqjuO9hxih5Q@mail.gmail.com>
Subject: Re: [git:media_tree/master] media: dt-bindings: media: sun6i:
 Separate H3 compatible from A31
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jagan Teki <jagan@amarulasolutions.com>,
        Rob Herring <robh@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On Thu, Jan 17, 2019 at 2:35 AM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> This is an automatic generated email to let you know that the following patch were queued:
>
> Subject: media: dt-bindings: media: sun6i: Separate H3 compatible from A31
> Author:  Chen-Yu Tsai <wens@csie.org>
> Date:    Fri Nov 30 02:58:44 2018 -0500
>
> The CSI controller found on the H3 (and H5) is a reduced version of the
> one found on the A31. It only has 1 channel, instead of 4 channels for
> time-multiplexed BT.656. Since the H3 is a reduced version, it cannot
> "fallback" to a compatible that implements more features than it
> supports.
>
> Split out the H3 compatible as a separate entry, with no fallback.
>
> Fixes: b7eadaa3a02a ("media: dt-bindings: media: sun6i: Add A31 and H3 compatibles")
>
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> Reviewed-by: Jagan Teki <jagan@amarulasolutions.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

I see this is applied to the master branch, which I assume is -next material.

We'd prefer if this patch, and "media: sun6i: Add H3 compatible", were applied
as fixes for 5.0-rc. That way the bindings and drivers are fixed up in the same
release as they were introduced in, and we wouldn't be carrying an incorrect
binding, even if it were only for just one release.


Thanks
ChenYu
