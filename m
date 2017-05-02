Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35140 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751005AbdEBUac (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 May 2017 16:30:32 -0400
Received: by mail-wm0-f68.google.com with SMTP id d79so7535537wmi.2
        for <linux-media@vger.kernel.org>; Tue, 02 May 2017 13:30:32 -0700 (PDT)
Subject: Re: [PATCH] libdvbv5: T2 delivery descriptor: fix wrong size of
 bandwidth field
To: Clemens Ladisch <clemens@ladisch.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <dc2b16b2-7caa-6141-a983-c83631544f3e@ladisch.de>
From: Gregor Jasny <gjasny@googlemail.com>
Message-ID: <c6f1d1cd-69ea-d454-15a8-5de9325577de@googlemail.com>
Date: Tue, 2 May 2017 22:30:29 +0200
MIME-Version: 1.0
In-Reply-To: <dc2b16b2-7caa-6141-a983-c83631544f3e@ladisch.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Clemens,

On 4/1/17 5:50 PM, Clemens Ladisch wrote:
> ETSI EN 300 468 V1.11.1 § 6.4.4.2 defines the bandwith field as having
> four bits.

I just used your patch and another to hopefully fix
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=859008

But I'm a little bit hesitant to merge it to v4l-utils git without
Mauros acknowledgement.

Thanks,
Gregor
