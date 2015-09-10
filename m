Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:35703 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbbIJOJE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2015 10:09:04 -0400
Received: by ykdu9 with SMTP id u9so59071139ykd.2
        for <linux-media@vger.kernel.org>; Thu, 10 Sep 2015 07:09:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <239d2a20505179788c7fb1aa09bbc5df00cc8453.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
	<239d2a20505179788c7fb1aa09bbc5df00cc8453.1440902901.git.mchehab@osg.samsung.com>
Date: Thu, 10 Sep 2015 16:09:03 +0200
Message-ID: <CABxcv=nWUPf4-osAcB-_9Fu9P2PLUkKT-sMS-m+DwCZxWP9Rhg@mail.gmail.com>
Subject: Re: [PATCH v8 06/55] [media] media: use media_gobj inside pads
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 30, 2015 at 5:06 AM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> PADs also need unique object IDs that won't conflict with
> the entity object IDs.
>
> The pad objects are currently created via media_entity_init()
> and, once created, never change.
>
> While this will likely change in the future in order to
> support dynamic changes, for now we'll keep PADs as arrays
> and initialize the media_gobj embedded structs when
> registering the entity.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
Javier
