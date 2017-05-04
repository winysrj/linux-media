Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35693 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932220AbdEDHzH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 May 2017 03:55:07 -0400
Received: by mail-wr0-f194.google.com with SMTP id g12so583328wrg.2
        for <linux-media@vger.kernel.org>; Thu, 04 May 2017 00:55:06 -0700 (PDT)
Subject: Re: [PATCH] libdvbv5: T2 delivery descriptor: fix wrong size of
 bandwidth field
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <dc2b16b2-7caa-6141-a983-c83631544f3e@ladisch.de>
 <c6f1d1cd-69ea-d454-15a8-5de9325577de@googlemail.com>
 <20170503095303.71cf3a75@vento.lan> <20170503193318.07ddf143@vento.lan>
Cc: Clemens Ladisch <clemens@ladisch.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Reinhard Speyerer <rspmn@arcor.de>
From: Gregor Jasny <gjasny@googlemail.com>
Message-ID: <00937473-581c-ecf8-58c6-616a78aa37c5@googlemail.com>
Date: Thu, 4 May 2017 09:55:04 +0200
MIME-Version: 1.0
In-Reply-To: <20170503193318.07ddf143@vento.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On 04.05.17 00:33, Mauro Carvalho Chehab wrote:
> Em Wed, 3 May 2017 09:53:03 -0300
> Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:
>> Em Tue, 2 May 2017 22:30:29 +0200
>> Gregor Jasny <gjasny@googlemail.com> escreveu:
>>> I just used your patch and another to hopefully fix
>>> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=859008
>>>
>>> But I'm a little bit hesitant to merge it to v4l-utils git without
>>> Mauros acknowledgement.

>> Patches look correct, but the T2 parser has a more serious issue that
>> will require breaking ABI/API compatibility.

> I'll cherry-pick the corresponding patches to the stable branch.

Reinhard, could you please test the latest patches on
https://git.linuxtv.org/v4l-utils.git/log/?h=stable-1.12

If they work for you, I'd release a new stable version and upload it to 
Debian Sid afterwards.

Thanks,
Gregor
