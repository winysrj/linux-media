Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot1-f46.google.com ([209.85.210.46]:42961 "EHLO
        mail-ot1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbeJ2WiU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Oct 2018 18:38:20 -0400
MIME-Version: 1.0
References: <20181022113306.GB2867@w540> <CAHCN7xJkc5RW73C0zruWBgyF7G0J3C5tLE=ZdfxTKbrUqs=-PQ@mail.gmail.com>
 <CAOMZO5ATm4BRzPEQOU+ZD6bHCP2Aqjp4raRYhuc+wNe0t4+C=w@mail.gmail.com>
 <CAHCN7x+csKEk25CF=teUv+F5_GoTe6_3Yqb5PODLn+AmCCm88w@mail.gmail.com>
 <d78877f8-2c23-2bf0-0a9c-cd98b855e95e@mentor.com> <CAHCN7xKhGAXs0jGv96CfOfLQfVubxzsdE9UjpDu+4NM6oLDGWw@mail.gmail.com>
 <bc034299-4a32-f248-d09a-0d1b5872a506@mentor.com> <CAHCN7xKVUgpyCb5k7s0PNXW-efySSwP25ZGMLdbFnohATPwKhg@mail.gmail.com>
 <20181023230259.GA3766@w540> <CAHCN7xJaY_916OLHvaN_q1FwM2vqH5UXzVxLAS4DuEV0icPUXg@mail.gmail.com>
 <20181024140820.GB3766@w540> <CAHCN7xKbAuTmic+L-a2o1NreSCmYBKzzvmHuUTGZtVHELFoirg@mail.gmail.com>
 <CAHCN7xLP13PDT_VhV_iQzRB+VS7N4AxY+BObtLpz4bJ6RfxfWg@mail.gmail.com>
In-Reply-To: <CAHCN7xLP13PDT_VhV_iQzRB+VS7N4AxY+BObtLpz4bJ6RfxfWg@mail.gmail.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Mon, 29 Oct 2018 10:49:41 -0300
Message-ID: <CAOMZO5Dkwrv4k=KGit+4wFFSr=ec94OpjUW56_D_aamjNPQH6g@mail.gmail.com>
Subject: Re: i.MX6 MIPI-CSI2 OV5640 Camera testing on Mainline Linux
To: Adam Ford <aford173@gmail.com>
Cc: jacopo mondi <jacopo@jmondi.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Jagan Teki <jagan@amarulasolutions.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Discussion of the development of and with GStreamer
        <gstreamer-devel@lists.freedesktop.org>,
        linux-media <linux-media@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Adam,

On Sun, Oct 28, 2018 at 3:58 PM Adam Ford <aford173@gmail.com> wrote:

> Does anyone know when the media branch get's merged into the mainline
> kernel?  I assume we're in the merge window with 4.19 just having been
> released.  Once these have been merged into the mainline, I'll go
> through and start requesting they get pulled into 4.19 and/or 4.14
> if/when appropriate.

This should happen in 4.20-rc1, which will probably be out next  Sunday.
