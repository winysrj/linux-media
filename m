Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:53114 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751098AbeELTnA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 May 2018 15:43:00 -0400
Subject: Re: [PATCH 5/7] Header location fix for 3.5.0 to 3.11.x
To: Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org
References: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
 <1524763162-4865-6-git-send-email-brad@nextdimension.cc>
From: "Jasmin J." <jasmin@anw.at>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4ae5be5c-167e-bf3b-4849-8958552f8d05@anw.at>
Date: Sat, 12 May 2018 21:42:56 +0200
MIME-Version: 1.0
In-Reply-To: <1524763162-4865-6-git-send-email-brad@nextdimension.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Brad!

This patch added the inclusion of "linux/of_i2c.h".
This gave the warnings in the last nightly build for Kernel
3.6 - 3.9.

I just pushed a fix for that, so we should have an OK build this
night.

BR,
   Jasmin
