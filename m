Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f195.google.com ([209.85.167.195]:40886 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729816AbeKLRAR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 12:00:17 -0500
Received: by mail-oi1-f195.google.com with SMTP id u130-v6so6342901oie.7
        for <linux-media@vger.kernel.org>; Sun, 11 Nov 2018 23:08:22 -0800 (PST)
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com. [209.85.167.179])
        by smtp.gmail.com with ESMTPSA id z16sm5443140otc.22.2018.11.11.23.08.20
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Nov 2018 23:08:20 -0800 (PST)
Received: by mail-oi1-f179.google.com with SMTP id p82-v6so6319251oih.11
        for <linux-media@vger.kernel.org>; Sun, 11 Nov 2018 23:08:20 -0800 (PST)
MIME-Version: 1.0
References: <20181109095613.28272-1-hverkuil@xs4all.nl> <20181109095613.28272-2-hverkuil@xs4all.nl>
In-Reply-To: <20181109095613.28272-2-hverkuil@xs4all.nl>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 12 Nov 2018 16:08:09 +0900
Message-ID: <CAPBb6MUtuWbQ+pjTVUWtqr8bdT6-=TN7fUrGNNHiWQJqzxCFaQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] videodev2.h: add cookie support
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 9, 2018 at 6:56 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Add support for 'cookies' to struct v4l2_buffer. These can be used to

This "to" seems unneeded.
