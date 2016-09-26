Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33803 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966666AbcIZRlo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Sep 2016 13:41:44 -0400
Received: by mail-lf0-f67.google.com with SMTP id b71so9198856lfg.1
        for <linux-media@vger.kernel.org>; Mon, 26 Sep 2016 10:41:44 -0700 (PDT)
Subject: Re: [v4l-utils PATCH 2/2] Add --with-static-binaries option to link
 binaries statically
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <1474282225-31559-1-git-send-email-sakari.ailus@linux.intel.com>
 <1474291350-15655-1-git-send-email-sakari.ailus@linux.intel.com>
 <20160919112150.4c3eef98@vento.lan>
Cc: linux-media@vger.kernel.org
From: Gregor Jasny <gjasny@googlemail.com>
Message-ID: <efd3b769-3079-c164-e948-d9ce8b1d6e10@googlemail.com>
Date: Mon, 26 Sep 2016 19:41:39 +0200
MIME-Version: 1.0
In-Reply-To: <20160919112150.4c3eef98@vento.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19/09/2016 16:21, Mauro Carvalho Chehab wrote:
> Em Mon, 19 Sep 2016 16:22:30 +0300
> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> 
>> Add a new variable STATIC_LDFLAGS to add the linker flags required for
>> static linking for each binary built.
>>
>> Static and dynamic libraries are built by default but the binaries are
>> otherwise linked dynamically. --with-static-binaries requires that static
>> libraries are built.
>>
> Instead of adding STATIC_LDFLAGS to all LDFLAGS, wouldn't be better to
> add the flags to LDFLAGS on configure.ac?

I don't really like adding all those build variants into the configure
script itself. It is already way too complex and adding another
dimension does not make it better.

Why is passing --disable-shared --enable-static LDLAGS="--static
-static" to configure not sufficient?

Thanks,
Gregor

