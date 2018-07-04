Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.anw.at ([195.234.102.72]:58321 "EHLO smtp.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752653AbeGDTzQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Jul 2018 15:55:16 -0400
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
From: "Jasmin J." <jasmin@anw.at>
Subject: Please update linux-media.tar.bz2
Message-ID: <b6cbff4b-0d63-a699-eb48-521cb2d6df43@anw.at>
Date: Wed, 4 Jul 2018 21:55:09 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro!

I got a request from a user, that media_build does not compile for older
Kernels. I checked that and found that the downloaded linux-media.tar.bz2 does
not contain "include/linux/overflow.h". Please can you add this file, because
media-build needs that file now.

BR,
   Jasmin
