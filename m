Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38496 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727145AbeIEDWK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Sep 2018 23:22:10 -0400
MIME-Version: 1.0
References: <20180904014559.15765-1-gagallo7@gmail.com> <529ce419-bba7-7e90-cb7d-e9a94fe64ac2@xs4all.nl>
In-Reply-To: <529ce419-bba7-7e90-cb7d-e9a94fe64ac2@xs4all.nl>
From: Guilherme Alcarde Gallo <gagallo7@gmail.com>
Date: Tue, 4 Sep 2018 19:54:18 -0300
Message-ID: <CAF2jNbj+MJV-U9JbwRmfw6Qwbow1n8JzHzP7ZRaMwfqAcHSO4Q@mail.gmail.com>
Subject: Re: [PATCH v2] media: vimc: implement basic v4l2-ctrls
To: hverkuil@xs4all.nl
Cc: Helen Koike <helen.koike@collabora.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        lkcamp@lists.libreplanetbr.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 4, 2018 at 3:40 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Hi Guilherme,
Hi Hans.

>
> On 09/04/2018 03:45 AM, Guilherme Gallo wrote:
> > Add brightness, contrast, hue and saturation controls in vimc-sensor
> >
> > Signed-off-by: Guilherme Alcarde Gallo <gagallo7@gmail.com>
> > Signed-off-by: Guilherme Gallo <gagallo7@gmail.com>
>
> Looks good, but you have (probably unintended) two Signed-off-by lines.
> Just let me know which one I should use and I'll drop the other one.

Yeah, it was unintended. Sorry for that.

Please pick this one:
Signed-off-by: Guilherme Alcarde Gallo <gagallo7@gmail.com>

Thanks for pointing that.
Guilherme
