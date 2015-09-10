Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f173.google.com ([209.85.160.173]:34528 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbbIJN6y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2015 09:58:54 -0400
Received: by ykdg206 with SMTP id g206so57841012ykd.1
        for <linux-media@vger.kernel.org>; Thu, 10 Sep 2015 06:58:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6185117c4ad70fd3e1c780689e0ad2407fdf1294.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
	<6185117c4ad70fd3e1c780689e0ad2407fdf1294.1440902901.git.mchehab@osg.samsung.com>
Date: Thu, 10 Sep 2015 15:58:53 +0200
Message-ID: <CABxcv=myNegKSr7xtrgV7BHqiTLMFCicLZtr1Md8m_wS8O52og@mail.gmail.com>
Subject: Re: [PATCH v8 01/55] [media] media: create a macro to get entity ID
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-sh@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 30, 2015 at 5:06 AM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Instead of accessing directly entity.id, let's create a macro,
> as this field will be moved into a common struct later on.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
Javier
