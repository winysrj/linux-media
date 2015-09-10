Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f171.google.com ([209.85.160.171]:34236 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbbIJOOw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2015 10:14:52 -0400
Received: by ykdg206 with SMTP id g206so58420649ykd.1
        for <linux-media@vger.kernel.org>; Thu, 10 Sep 2015 07:14:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <14c4b36d1413cf1e1551927dfdbc7cc446b1a354.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
	<14c4b36d1413cf1e1551927dfdbc7cc446b1a354.1440902901.git.mchehab@osg.samsung.com>
Date: Thu, 10 Sep 2015 16:14:51 +0200
Message-ID: <CABxcv=m_hbCucPsM5jQJ6=YR0adC7-t3JhwqiKS2bzTExr899A@mail.gmail.com>
Subject: Re: [PATCH v8 09/55] [media] media: add a debug message to warn about
 gobj creation/removal
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 30, 2015 at 5:06 AM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> It helps to check if the media controller is doing the
> right thing with the object creation and removal.
>
> No extra code/data will be produced if DEBUG or
> CONFIG_DYNAMIC_DEBUG is not enabled.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
Javier
