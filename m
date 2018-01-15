Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:46698 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751604AbeAOHMQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 02:12:16 -0500
Received: by mail-it0-f44.google.com with SMTP id c16so15550525itc.5
        for <linux-media@vger.kernel.org>; Sun, 14 Jan 2018 23:12:16 -0800 (PST)
Received: from mail-it0-f45.google.com (mail-it0-f45.google.com. [209.85.214.45])
        by smtp.gmail.com with ESMTPSA id f20sm15491334ioh.19.2018.01.14.23.12.14
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Jan 2018 23:12:14 -0800 (PST)
Received: by mail-it0-f45.google.com with SMTP id f143so15864382itb.0
        for <linux-media@vger.kernel.org>; Sun, 14 Jan 2018 23:12:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180110160732.7722-2-gustavo@padovan.org>
References: <20180110160732.7722-1-gustavo@padovan.org> <20180110160732.7722-2-gustavo@padovan.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 15 Jan 2018 16:11:53 +0900
Message-ID: <CAPBb6MV6ErW-Z7n1aK55TxJNRDkt2SkWGEJiXkxrLmZ_GabJOA@mail.gmail.com>
Subject: Re: [PATCH v7 1/6] [media] vb2: add is_unordered callback for drivers
To: Gustavo Padovan <gustavo@padovan.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 11, 2018 at 1:07 AM, Gustavo Padovan <gustavo@padovan.org> wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
>
> Explicit synchronization benefits a lot from ordered queues, they fit
> better in a pipeline with DRM for example so create a opt-in way for
> drivers notify videobuf2 that the queue is unordered.
>
> Drivers don't need implement it if the queue is ordered.

This is going to make user-space believe that *all* vb2 drivers use
ordered queues by default, at least until non-ordered drivers catch up
with this change. Wouldn't it be less dangerous to do the opposite
(make queues non-ordered by default)?
