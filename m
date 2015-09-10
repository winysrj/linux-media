Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f175.google.com ([209.85.160.175]:36653 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbbIJOCY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2015 10:02:24 -0400
Received: by ykdt18 with SMTP id t18so38002225ykd.3
        for <linux-media@vger.kernel.org>; Thu, 10 Sep 2015 07:02:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8127dc64593c95072f3b5eaa820f738dc1af1920.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
	<8127dc64593c95072f3b5eaa820f738dc1af1920.1440902901.git.mchehab@osg.samsung.com>
Date: Thu, 10 Sep 2015 16:02:22 +0200
Message-ID: <CABxcv=ktXDiKiwvHfMAkXW7_=Gv0vQ4hLcsWzzNRiERpEt_Eow@mail.gmail.com>
Subject: Re: [PATCH v8 04/55] [media] media: add a common struct to be embed
 on media graph objects
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 30, 2015 at 5:06 AM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Due to the MC API proposed changes, we'll need to have an unique
> object ID for all graph objects, and have some shared fields
> that will be common on all media graph objects.
>
> Right now, the only common object is the object ID, but other
> fields will be added later on.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
Javier
