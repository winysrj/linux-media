Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f169.google.com ([209.85.160.169]:35046 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbbIJOKj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2015 10:10:39 -0400
Received: by ykdu9 with SMTP id u9so59131878ykd.2
        for <linux-media@vger.kernel.org>; Thu, 10 Sep 2015 07:10:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ad2546861368b99bfd31110be76d2c9707ddd229.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
	<ad2546861368b99bfd31110be76d2c9707ddd229.1440902901.git.mchehab@osg.samsung.com>
Date: Thu, 10 Sep 2015 16:10:38 +0200
Message-ID: <CABxcv=nDikg3jUQ_FG9iGUU=ecKyg9ZgY0TbeauYiwDery=K1w@mail.gmail.com>
Subject: Re: [PATCH v8 07/55] [media] media: use media_gobj inside links
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 30, 2015 at 5:06 AM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Just like entities and pads, links also need to have unique
> Object IDs along a given media controller.
>
> So, let's add a media_gobj inside it and initialize
> the object then a new link is created.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
Javier
