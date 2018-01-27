Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:60623 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752336AbeA0PVQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 27 Jan 2018 10:21:16 -0500
Subject: Re: [PATCH] media: uvcvideo: Fixed ktime_t to ns conversion
From: "Jasmin J." <jasmin@anw.at>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1515925303-5160-1-git-send-email-jasmin@anw.at>
 <CAK8P3a3hY23dH8hS2+UjjeR03M1dP-tQOyXHANiCOHh6WJn9oA@mail.gmail.com>
 <ee44b1e7-eb64-dfec-a9bf-19e455c9f9eb@anw.at>
Message-ID: <63d975f4-8950-211b-632c-225936567621@anw.at>
Date: Sat, 27 Jan 2018 16:21:08 +0000
MIME-Version: 1.0
In-Reply-To: <ee44b1e7-eb64-dfec-a9bf-19e455c9f9eb@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro!

> Ping!
> It is required to compile for Kernels older 4.10.

It would be nice to get this merged, so that we can see if older Kernels
will compile again.

BR,
   Jasmin
