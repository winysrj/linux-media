Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:45485 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752587AbdLKTF7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 14:05:59 -0500
Received: by mail-wm0-f48.google.com with SMTP id 9so16446955wme.4
        for <linux-media@vger.kernel.org>; Mon, 11 Dec 2017 11:05:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <c80aee3d6556f9acad8ea39bbded8b73e73d5d17.1513013948.git.joabreu@synopsys.com>
References: <cover.1513013948.git.joabreu@synopsys.com> <c80aee3d6556f9acad8ea39bbded8b73e73d5d17.1513013948.git.joabreu@synopsys.com>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Mon, 11 Dec 2017 20:05:17 +0100
Message-ID: <CAOFm3uEv67Z4B4q8QSAD4t=QZaU08N3t9W8mgODL1-X=pMKN9Q@mail.gmail.com>
Subject: Re: [PATCH v10 3/4] [media] platform: Add Synopsys DesignWare HDMI RX
 PHY e405 Driver
To: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 11, 2017 at 6:41 PM, Jose Abreu <Jose.Abreu@synopsys.com> wrote:
> This adds support for the Synopsys DesignWare HDMI RX PHY e405. This
> phy receives and decodes HDMI video that is delivered to a controller.
>
> Main features included in this driver are:
>         - Equalizer algorithm that chooses the phy best settings
>         according to the detected HDMI cable characteristics.
>         - Support for scrambling
>         - Support for HDMI 2.0 modes up to 6G (HDMI 4k@60Hz).
>
> The driver was implemented as a standalone V4L2 subdevice and the
> phy interface with the controller was implemented using V4L2 ioctls. I
> do not know if this is the best option but it is not possible to use the
> existing API functions directly as we need specific functions that will
> be called by the controller at specific configuration stages.
>
> There is also a bidirectional communication between controller and phy:
> The phy must provide functions that the controller will call (i.e.
> configuration functions) and the controller must provide read/write
> callbacks, as well as other specific functions.
>
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
> Cc: Joao Pinto <jpinto@synopsys.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sylwester Nawrocki <snawrocki@kernel.org>
> Cc: Philippe Ombredanne <pombredanne@nexb.com>
> ---
> Changes from v9:
>         - Use SPDX License ID (Philippe)

Acked-by: Philippe Ombredanne <pombredanne@nexb.com>

Thanks!
-- 
Cordially
Philippe Ombredanne
