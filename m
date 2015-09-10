Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:35276 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbbIJOWP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2015 10:22:15 -0400
Received: by ykdu9 with SMTP id u9so59542691ykd.2
        for <linux-media@vger.kernel.org>; Thu, 10 Sep 2015 07:22:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
References: <510dc75bdef5462b55215ba8aed120b1b7c4997d.1440902901.git.mchehab@osg.samsung.com>
	<ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
Date: Thu, 10 Sep 2015 16:22:14 +0200
Message-ID: <CABxcv=k5vMhTx_Bw2YZV5xDij10Zet8tdkPb23V86g5Mpwc51g@mail.gmail.com>
Subject: Re: [PATCH v8 14/55] [media] media: add functions to allow creating interfaces
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Sep 6, 2015 at 2:02 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Interfaces are different than entities: they represent a
> Kernel<->userspace interaction, while entities represent a
> piece of hardware/firmware/software that executes a function.
>
> Let's distinguish them by creating a separate structure to
> store the interfaces.
>
> Later patches should change the existing drivers and logic
> to split the current interface embedded inside the entity
> structure (device nodes) into a separate object of the graph.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
Javier
