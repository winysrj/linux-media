Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35970 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750772AbdFBGhz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Jun 2017 02:37:55 -0400
Received: by mail-wm0-f43.google.com with SMTP id 7so13599956wmo.1
        for <linux-media@vger.kernel.org>; Thu, 01 Jun 2017 23:37:50 -0700 (PDT)
MIME-Version: 1.0
From: Tim Harvey <tharvey@gateworks.com>
Date: Thu, 1 Jun 2017 23:37:43 -0700
Message-ID: <CAJ+vNU1TOOSf-PoXw1oGTVhGNp2w=X2KAmpYtT8c32GRju2kEQ@mail.gmail.com>
Subject: regmap for i2c pages
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm working on a driver for an i2c based media controller device that
uses pages. By that I mean there are several pages of 8bit registers
and a page-select register that holds the current page. Multiple
accesses to the same page can occur without writing to this page
register but if you want to access another page you need to update it.

I believe this is a very common i2c register mechanism but I'm not
clear what the best way to use i2c regmap for this is. I'm reading
that regmap 'handles register pages' but I'm not clear if that's the
same thing I'm looking for. If so, are there any examples of this? I
see several i2c drivers that reference pages but it looks to me that
each page is a different i2c slave address which is something
different.

Regards,

Tim
