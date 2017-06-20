Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:49364
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751056AbdFTNfB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 09:35:01 -0400
Date: Tue, 20 Jun 2017 10:34:54 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: linuxtv-commits@linuxtv.org
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [git:media_tree/master] foo
Message-ID: <20170620103454.3c80ed17@vento.lan>
In-Reply-To: <E1dNHGh-0002VG-7X@www.linuxtv.org>
References: <E1dNHGh-0002VG-7X@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 20 Jun 2017 11:19:56 +0000
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> This is an automatic generated email to let you know that the following patch were queued:
> 
> Subject: foo
> Author:  Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Date:    Tue Jun 20 08:19:56 2017 -0300

This one was just to see if people are paying atention...
It turns that people were, as I got two reports already
about it! :-D

Seriously, I was doing a test with gcc warnings, before writing a
real fix for double const.

Once I noticed I merged it by mistake, I folded it with the right
fix and rebased, before applying other patches at the tree. So,
hopefully, no harm done (except that sfr pulled from my tree on
that time, so, we may have some noise on today's -next).

Thanks,
Mauro
