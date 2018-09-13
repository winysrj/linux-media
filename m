Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:41957 "EHLO smtp.anw.at"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727807AbeINC5c (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 22:57:32 -0400
Subject: Re: RFC: stop support for 2.6 kernel in the daily build
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <9e0a811d-f403-ae89-38fa-947356f2c026@xs4all.nl>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <ae5e070e-4d5c-801a-cdde-120e312b10cf@anw.at>
Date: Thu, 13 Sep 2018 23:32:25 +0200
MIME-Version: 1.0
In-Reply-To: <9e0a811d-f403-ae89-38fa-947356f2c026@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans!

> I'm inclined to drop support for 2.6 altogether.
RHEL 6 is on kernel 2.6.32, which we do not support since long time.
Most other distributions switched to 3.x also years in the past.
So lets drop 2.6.x then!

As you know I maintain a media-tree DKMS package and this should work for older
Kernels. I personally have a VDR based on Ubuntu 14.04 system with the original
3.13 Kernel. So this is the minimum version for me.

When you want to support RHEL 7, then the version goes down to 3.10.

> Whether we should also drop support for 3.0-3.9 is another matter.
We can decide now to remove those versions also and wait if people are
complaining. At least this is what I would do.

I would suggest to remove all kernels prior to 3.10 from your build system and
wait what people will say over the next months.

BR,
   Jasmin
