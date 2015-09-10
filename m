Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:35676 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbbIJOEt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2015 10:04:49 -0400
Received: by ykdu9 with SMTP id u9so58916732ykd.2
        for <linux-media@vger.kernel.org>; Thu, 10 Sep 2015 07:04:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3dad0210717d61927a2c6f370a3b1eb145f1580b.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
	<3dad0210717d61927a2c6f370a3b1eb145f1580b.1440902901.git.mchehab@osg.samsung.com>
Date: Thu, 10 Sep 2015 16:04:48 +0200
Message-ID: <CABxcv=mZkNMPvQTYmwGY1tFszYS8LPe9YJWzoDVaToPg6N42tQ@mail.gmail.com>
Subject: Re: [PATCH v8 05/55] [media] media: use media_gobj inside entities
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 30, 2015 at 5:06 AM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> As entities are graph objects, let's embed media_gobj
> on it. That ensures an unique ID for entities that can be
> global along the entire media controller.
>
> For now, we'll keep the already existing entity ID. Such
> field need to be dropped at some point, but for now, let's
> not do this, to avoid needing to review all drivers and
> the userspace apps.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
Javier
