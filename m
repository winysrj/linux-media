Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727069AbeHaWFI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 18:05:08 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
To: Eddie James <eajames@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
From: Stephen Boyd <sboyd@kernel.org>
In-Reply-To: <1535576973-8067-1-git-send-email-eajames@linux.vnet.ibm.com>
Cc: linux-media@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        openbmc@lists.ozlabs.org, andrew@aj.id.au, mchehab@kernel.org,
        joel@jms.id.au, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        mturquette@baylibre.com, linux-arm-kernel@lists.infradead.org,
        Eddie James <eajames@linux.vnet.ibm.com>
References: <1535576973-8067-1-git-send-email-eajames@linux.vnet.ibm.com>
Message-ID: <153573819126.93865.1884182656081956202@swboyd.mtv.corp.google.com>
Subject: Re: [PATCH 0/4] media: platform: Add Aspeed Video Engine driver
Date: Fri, 31 Aug 2018 10:56:31 -0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Eddie James (2018-08-29 14:09:29)
> The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs
> can capture and compress video data from digital or analog sources. With
> the Aspeed chip acting as a service processor, the Video Engine can
> capture the host processor graphics output.
> =

> This series adds a V4L2 driver for the VE, providing a read() interface
> only. The driver triggers the hardware to capture the host graphics output
> and compress it to JPEG format.
> =

> Testing on an AST2500 determined that the videobuf/streaming/mmap interfa=
ce
> was significantly slower than the simple read() interface, so I have not
> included the streaming part.
> =

> It's also possible to use an automatic mode for the VE such that
> re-triggering the HW every frame isn't necessary. However this wasn't
> reliable on the AST2400, and probably used more CPU anyway due to excessi=
ve
> interrupts. It was approximately 15% faster.
> =

> The series also adds the necessary parent clock definitions to the Aspeed
> clock driver, with both a mux and clock divider.

Please let me know your merge strategy here. I can ack the clk patches
because they look fine from high-level clk driver perspective (maybe
Joel can take a closer look) or I can merge the patches into clk-next
and get them into next release while the video driver gets reviewed.
