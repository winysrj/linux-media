Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:35180 "EHLO
	mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423357AbcFMNh7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2016 09:37:59 -0400
Received: by mail-it0-f66.google.com with SMTP id e5so7211168ith.2
        for <linux-media@vger.kernel.org>; Mon, 13 Jun 2016 06:37:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1465436102-13827-1-git-send-email-shuahkh@osg.samsung.com>
References: <1465436102-13827-1-git-send-email-shuahkh@osg.samsung.com>
Date: Mon, 13 Jun 2016 09:37:58 -0400
Message-ID: <CABxcv==o3od4woG6EHbc9Go0HAkFF1UmmSz-gFP3dwd9LoK0LA@mail.gmail.com>
Subject: Re: [PATCH] media: s5p-mfc fix video device release double release in
 probe error path
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
	Kamil Debski <k.debski@samsung.com>, jtp.park@samsung.com,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Shuah,

On Wed, Jun 8, 2016 at 9:35 PM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
> Fix Decoder and encoder video device double release in probe error path.
> video_device_release(dev->vfd_dec) get called twice if decoder register
> fails. Also, video_device_release(dev->vfd_enc) get called twice if encoder
> register fails.
>
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---

Right, thanks for the fix.

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
Javier
