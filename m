Return-path: <linux-media-owner@vger.kernel.org>
Received: from isis.lip6.fr ([132.227.60.2]:52077 "EHLO isis.lip6.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751091AbcIIJo2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Sep 2016 05:44:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Fri, 09 Sep 2016 17:34:57 +0800
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Andrey Utkin <andrey_utkin@fastmail.com>
Cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        kernel-janitors@vger.kernel.org, Abylay Ospan <aospan@netup.ru>,
        Sergey Kozlov <serjk@netup.ru>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        kernel-janitors-owner@vger.kernel.org
Subject: Re: [PATCH] [media] pci: constify vb2_ops structures
In-Reply-To: <20160909091741.re5ll3jelooeitpv@zver>
References: <1473379158-17344-1-git-send-email-Julia.Lawall@lip6.fr>
 <20160909091741.re5ll3jelooeitpv@zver>
Message-ID: <9947c295765da5bca33efda310e874e6@newmail.lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 09.09.2016 17:17, Andrey Utkin a écrit :
> On Fri, Sep 09, 2016 at 01:59:18AM +0200, Julia Lawall wrote:
>> Check for vb2_ops structures that are only stored in the ops field of 
>> a
>> vb2_queue structure.  That field is declared const, so vb2_ops 
>> structures
>> that have this property can be declared as const also.
> 
>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>> 
>> ---
>>  drivers/media/pci/cx23885/cx23885-417.c            |    2 +-
>>  drivers/media/pci/cx23885/cx23885-dvb.c            |    2 +-
>>  drivers/media/pci/cx23885/cx23885-video.c          |    2 +-
>>  drivers/media/pci/cx25821/cx25821-video.c          |    2 +-
>>  drivers/media/pci/cx88/cx88-blackbird.c            |    2 +-
>>  drivers/media/pci/cx88/cx88-dvb.c                  |    2 +-
>>  drivers/media/pci/cx88/cx88-video.c                |    2 +-
>>  drivers/media/pci/netup_unidvb/netup_unidvb_core.c |    2 +-
>>  drivers/media/pci/saa7134/saa7134-empress.c        |    2 +-
>>  drivers/media/pci/saa7134/saa7134-video.c          |    2 +-
>>  drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |    2 +-
>>  drivers/media/pci/tw68/tw68-video.c                |    2 +-
>>  drivers/media/pci/tw686x/tw686x-video.c            |    2 +-
>>  13 files changed, 13 insertions(+), 13 deletions(-)
> 
> Applies and compiles cleanly on media tree.
> But please regenerate this patch on git://linuxtv.org/media_tree.git -
> it has a new driver by me, drivers/media/pci/tw5864 , which is 
> affected.

Do you want the whole patch again, or would a patch on the new driver by 
itself be sufficient?  The changes in the different files are all 
independent.

julia

> Otherwise
> 
> Acked-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> 
> (however this time I'm writing from another email.)
> --
> To unsubscribe from this list: send the line "unsubscribe 
> kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
