Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:35534 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbeHXSOU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 14:14:20 -0400
Received: by mail-yb0-f195.google.com with SMTP id o17-v6so3562110yba.2
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2018 07:39:24 -0700 (PDT)
Received: from mail-yw1-f46.google.com (mail-yw1-f46.google.com. [209.85.161.46])
        by smtp.gmail.com with ESMTPSA id w7-v6sm1904241ywc.82.2018.08.24.07.39.22
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Aug 2018 07:39:22 -0700 (PDT)
Received: by mail-yw1-f46.google.com with SMTP id l9-v6so3145669ywc.11
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2018 07:39:22 -0700 (PDT)
MIME-Version: 1.0
References: <20180824082156.6986-1-hverkuil@xs4all.nl>
In-Reply-To: <20180824082156.6986-1-hverkuil@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 24 Aug 2018 23:39:09 +0900
Message-ID: <CAAFQd5A472-ij=v9zM4wk+foGotbbEnh+ipFMbAXm3nFVP=C2A@mail.gmail.com>
Subject: Re: [PATCH 0/5] Post-v18: Request API updates
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Aug 24, 2018 at 5:22 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Hi all,
>
> This patch series sits on top of my v18 series for the Request API.
> It makes some final (?) changes as discussed in:
>
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg134419.html
>
> and:
>
> https://www.spinics.net/lists/linux-media/msg138596.html
>

For all patches except "[PATCH 4/5] videodev2.h: add new capabilities
for buffer types":

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz
