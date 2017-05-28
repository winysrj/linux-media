Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:35081 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750773AbdE1NGV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 09:06:21 -0400
Received: by mail-qt0-f171.google.com with SMTP id v27so35288356qtg.2
        for <linux-media@vger.kernel.org>; Sun, 28 May 2017 06:06:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170528123153.18613-2-hdegoede@redhat.com>
References: <20170528123153.18613-1-hdegoede@redhat.com> <20170528123153.18613-2-hdegoede@redhat.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sun, 28 May 2017 16:06:20 +0300
Message-ID: <CAHp75Vd=VzZbDxtN83gW6X-=Cwkc4V5GCN7wRLg3qMfFt1NRdQ@mail.gmail.com>
Subject: Re: [PATCH 2/7] staging: atomisp: Do not call dev_warn with a NULL device
To: Hans de Goede <hdegoede@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, May 28, 2017 at 3:31 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> Do not call dev_warn with a NULL device, this silence the following 2
> warnings:
>
> [   14.392194] (NULL device *): Failed to find gmin variable gmin_V2P8GPIO
> [   14.392257] (NULL device *): Failed to find gmin variable gmin_V1P8GPIO
>
> We could switch to using pr_warn for dev == NULL instead, but as comments
> in the source indicate, the check for these 2 special gmin variables with
> a NULL device is a workaround for 2 specific evaluation boards, so
> completely silencing the missing warning for these actually is a good
> thing.

Perhaps removing all code related explicitly to Gmin is a right thing to do.


-- 
With Best Regards,
Andy Shevchenko
