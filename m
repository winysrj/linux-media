Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47587
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750710AbdEBUtN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 May 2017 16:49:13 -0400
Date: Tue, 2 May 2017 17:49:07 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Clemens Ladisch <clemens@ladisch.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] libdvbv5: T2 delivery descriptor: fix wrong size of
 bandwidth field
Message-ID: <20170502174907.1b691336@vento.lan>
In-Reply-To: <c6f1d1cd-69ea-d454-15a8-5de9325577de@googlemail.com>
References: <dc2b16b2-7caa-6141-a983-c83631544f3e@ladisch.de>
        <c6f1d1cd-69ea-d454-15a8-5de9325577de@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 2 May 2017 22:30:29 +0200
Gregor Jasny <gjasny@googlemail.com> escreveu:

> Hello Clemens,
> 
> On 4/1/17 5:50 PM, Clemens Ladisch wrote:
> > ETSI EN 300 468 V1.11.1 § 6.4.4.2 defines the bandwith field as having
> > four bits.  
> 
> I just used your patch and another to hopefully fix
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=859008
> 
> But I'm a little bit hesitant to merge it to v4l-utils git without
> Mauros acknowledgement.

I'll take a look on them likely tomorrow.

Thanks!
Mauro
