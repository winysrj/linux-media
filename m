Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:36151 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752497AbdICUbs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Sep 2017 16:31:48 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
From: =?UTF-8?Q?Honza_Petrou=C5=A1?= <jpetrous@gmail.com>
Date: Sun, 3 Sep 2017 22:31:46 +0200
Message-ID: <CAJbz7-2uDNfbYw4k5e-X7HB_gJTfah-u64kCYXZx_5apsE5KOw@mail.gmail.com>
Subject: Re: [PATCH v2 00/26] Improve DVB documentation and reduce its gap
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> There is still a gap at the CA API, as there are three ioctls that are used
> only by a few drivers and whose structs are not properly documented:
> CA_GET_MSG, CA_SEND_MSG and CA_SET_DESCR.
>
> The first two ones seem to be related to a way that a few drivers
> provide to send/receive messages. Yet, I was unable to get what
> "index" and "type" means on those ioctls. The CA_SET_DESCR is
> only supported by av7110 driver, and has an even weirder
> undocumented struct. I was unable to discover at the Kernel, VDR
> or Kaffeine how those structs are filled. I suspect that there's
> something wrong there, but I won't risk trying to fix without
> knowing more about them. So, let's just document that those
> are needing documentation :-)
>

BTW, I just remembered dvblast app, part of videolan.org:

http://www.videolan.org/projects/dvblast.html

which is using CA_GET_MSG/CA_SEND_MSG:

https://code.videolan.org/videolan/dvblast/blob/master/en50221.c

/Honza
