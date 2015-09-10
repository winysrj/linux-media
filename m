Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:33555 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbbIJOTj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2015 10:19:39 -0400
Received: by ykei199 with SMTP id i199so58938172yke.0
        for <linux-media@vger.kernel.org>; Thu, 10 Sep 2015 07:19:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4bf60081a6756f559407052aa92e343456697a08.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
	<4bf60081a6756f559407052aa92e343456697a08.1440902901.git.mchehab@osg.samsung.com>
Date: Thu, 10 Sep 2015 16:19:39 +0200
Message-ID: <CABxcv=m-3Ex-LtSZ36pAenpnrGXYF13FVf17r3_cJycpgkpNZA@mail.gmail.com>
Subject: Re: [PATCH v8 13/55] [media] uapi/media.h: Declare interface types
 for V4L2 and DVB
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-api@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 30, 2015 at 5:06 AM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Declare the interface types that will be used by the new
> G_TOPOLOGY ioctl that will be defined latter on.
>
> For now, we need those types, as they'll be used on the
> internal structs associated with the new media_interface
> graph object defined on the next patch.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
Javier
