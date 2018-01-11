Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:47061 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933167AbeAKWMz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Jan 2018 17:12:55 -0500
Received: by mail-oi0-f48.google.com with SMTP id d124so2692249oib.13
        for <linux-media@vger.kernel.org>; Thu, 11 Jan 2018 14:12:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180111101915.10985-1-sakari.ailus@linux.intel.com>
References: <20180111101915.10985-1-sakari.ailus@linux.intel.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 11 Jan 2018 23:12:53 +0100
Message-ID: <CAK8P3a0sPb4a6EN5DPNU7C4NFTnw4jW+EH_ofSOysdJ78+2C_Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] media: entity: Add a nop variant of media_entity_cleanup
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 11, 2018 at 11:19 AM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> Add nop variant of media_entity_cleanup. This allows calling
> media_entity_cleanup whether or not Media controller is enabled,
> simplifying driver code.
>
> Also drop #ifdefs on a few drivers around media_entity_cleanup().
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Thanks for addressing this,

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
