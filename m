Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:46439 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbeAPRKM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 12:10:12 -0500
MIME-Version: 1.0
In-Reply-To: <1517434.pRS3rpdWG0@avalon>
References: <20171127132027.1734806-1-arnd@arndb.de> <20171127132027.1734806-5-arnd@arndb.de>
 <1517434.pRS3rpdWG0@avalon>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 16 Jan 2018 18:10:10 +0100
Message-ID: <CAK8P3a0wscoLR7+VRQ9JC=5ffZWp_SLx=o-kdYvQK-S=6hM--A@mail.gmail.com>
Subject: Re: [PATCH 5/8] [media] omap3isp: support 64-bit version of omap3isp_stat_data
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        y2038 Mailman List <y2038@lists.linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 5, 2017 at 1:41 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Arnd,
>
> Thank you for the patch.
>
> I'll try to review this without too much delay. In the meantime, I'm CC'ing
> Sakari Ailus who might be faster than me :-)

Hi Laurent and Sakari,

I stumbled over this while cleaning out my backlog of patches. Any chance one
of you can have a look at this one? It's not needed for the 4.16 merge window,
but we do need it at some point and I would like to not see it again the next
time I clean out my old patches ;-)

      Arnd
