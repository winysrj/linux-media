Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:34265 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751340AbdGNJAk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 05:00:40 -0400
Received: by mail-it0-f67.google.com with SMTP id o202so11470799itc.1
        for <linux-media@vger.kernel.org>; Fri, 14 Jul 2017 02:00:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABxcv=nKHs6nFvbNdwMxsGjbj-JpHAOXd1Lt8FCXk3RHjCZgwA@mail.gmail.com>
References: <ea42b2bdf113f7c2533c83986657647934b4e839.1499859983.git.mchehab@s-opensource.com>
 <20170713153842.xupjvsf2nfkvtkyy@valkosipuli.retiisi.org.uk> <CABxcv=nKHs6nFvbNdwMxsGjbj-JpHAOXd1Lt8FCXk3RHjCZgwA@mail.gmail.com>
From: Javier Martinez Canillas <javier@dowhile0.org>
Date: Fri, 14 Jul 2017 11:00:38 +0200
Message-ID: <CABxcv=kThAbvFnNRBZJgVABr1YpS9qQpfVgcmUBtDMYFBTUx4w@mail.gmail.com>
Subject: Re: [PATCH] media: vimc: cleanup a few warnings
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Helen Koike <helen.koike@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 13, 2017 at 5:47 PM, Javier Martinez Canillas
<javier@dowhile0.org> wrote:
> On Thu, Jul 13, 2017 at 5:38 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:

[snip]

>>
>> Shouldn't these be set to the corresponding driver structs' id_table
>> fields? Or do I miss something...?
>>
>
> Agreed, the real problem is that the .id_table is not set for these
> drivers. The match only works because the platform subsystem fallbacks
> to the driver's name if an .id_table isn't defined:
>

I just posted a patch fixing the build warning in the driver as
suggested by Sakari:

https://patchwork.linuxtv.org/patch/42480/

Best regards,
Javier
