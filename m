Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:46668 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752310AbdLKTGp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 14:06:45 -0500
Received: by mail-wm0-f52.google.com with SMTP id r78so16520926wme.5
        for <linux-media@vger.kernel.org>; Mon, 11 Dec 2017 11:06:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5f9eedfd6f91ed73ef0bb6d3977588d01478909f.1513013948.git.joabreu@synopsys.com>
References: <cover.1513013948.git.joabreu@synopsys.com> <5f9eedfd6f91ed73ef0bb6d3977588d01478909f.1513013948.git.joabreu@synopsys.com>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Mon, 11 Dec 2017 20:06:04 +0100
Message-ID: <CAOFm3uG4SLGDsBNhcjQPTjUT4KPUxr8-=x9rZ7xmYCzhLwepJg@mail.gmail.com>
Subject: Re: [PATCH v10 4/4] [media] platform: Add Synopsys DesignWare HDMI RX
 Controller Driver
To: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 11, 2017 at 6:41 PM, Jose Abreu <Jose.Abreu@synopsys.com> wrote:
> This is an initial submission for the Synopsys DesignWare HDMI RX
> Controller Driver. This driver interacts with a phy driver so that
> a communication between them is created and a video pipeline is
> configured.
>
> The controller + phy pipeline can then be integrated into a fully
> featured system that can be able to receive video up to 4k@60Hz
> with deep color 48bit RGB, depending on the platform. Although,
> this initial version does not yet handle deep color modes.
>
> This driver was implemented as a standard V4L2 subdevice and its
> main features are:
>         - Internal state machine that reconfigures phy until the
>         video is not stable
>         - JTAG communication with phy
>         - Inter-module communication with phy driver
>         - Debug write/read ioctls
>
> Some notes:
>         - RX sense controller (cable connection/disconnection) must
>         be handled by the platform wrapper as this is not integrated
>         into the controller RTL
>         - The same goes for EDID ROM's
>         - ZCAL calibration is needed only in FPGA platforms, in ASIC
>         this is not needed
>         - The state machine is not an ideal solution as it creates a
>         kthread but it is needed because some sources might not be
>         very stable at sending the video (i.e. we must react
>         accordingly).
>
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
> Cc: Joao Pinto <jpinto@synopsys.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sylwester Nawrocki <snawrocki@kernel.org>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Philippe Ombredanne <pombredanne@nexb.com>
> ---
> Changes from v9:
>         - Use SPDX License ID (Philippe)

Acked-by: Philippe Ombredanne <pombredanne@nexb.com>
