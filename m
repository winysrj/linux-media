Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f182.google.com ([209.85.160.182]:34642 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbbIJONA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2015 10:13:00 -0400
Received: by ykdg206 with SMTP id g206so58354565ykd.1
        for <linux-media@vger.kernel.org>; Thu, 10 Sep 2015 07:12:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2e64a28d41d8f02ae207ef44fbf454da09872ad4.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
	<2e64a28d41d8f02ae207ef44fbf454da09872ad4.1440902901.git.mchehab@osg.samsung.com>
Date: Thu, 10 Sep 2015 16:12:57 +0200
Message-ID: <CABxcv=mHOu8u1fzc_JPpr55JPuQhpi+H0X64NBmUcb-pxpC7dQ@mail.gmail.com>
Subject: Re: [PATCH v8 08/55] [media] media: add messages when media device
 gets (un)registered
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 30, 2015 at 5:06 AM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> We can only free the media device after being sure that no
> graph object is used.
>
> In order to help tracking it, let's add debug messages
> that will print when the media controller gets registered
> or unregistered.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
Javier
