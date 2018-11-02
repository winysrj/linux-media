Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot1-f68.google.com ([209.85.210.68]:34052 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbeKCBYb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 21:24:31 -0400
Received: by mail-ot1-f68.google.com with SMTP id e9so2191042oti.1
        for <linux-media@vger.kernel.org>; Fri, 02 Nov 2018 09:16:53 -0700 (PDT)
MIME-Version: 1.0
References: <20181005074911.47574-1-hverkuil@xs4all.nl>
In-Reply-To: <20181005074911.47574-1-hverkuil@xs4all.nl>
From: Sylwester Nawrocki <sylwester.nawrocki@gmail.com>
Date: Fri, 2 Nov 2018 17:16:40 +0100
Message-ID: <CAB_H8ru9KzstY4-qByAdfNKeDW23U93e0TRc71-knmrDOike4g@mail.gmail.com>
Subject: Re: [RFC PATCH 00/11] Convert last remaining g/s_crop/cropcap drivers
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, niklas.soderlund+renesas@ragnatech.se,
        tfiga@chromium.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, 5 Oct 2018 at 09:49, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> This patch series converts the last remaining drivers that use g/s_crop and
> cropcap to g/s_selection.

Thank you for this clean up! I remember attempting conversion of those remaining
drivers to selection API long time ago but I didn't have a good idea
then how to address
that crop and compose target inversion mess so I abandoned that efforts then.

--
Regards,
Sylwester
