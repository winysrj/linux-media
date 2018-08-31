Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727069AbeHaWFP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 18:05:15 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
To: Eddie James <eajames@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
From: Stephen Boyd <sboyd@kernel.org>
In-Reply-To: <1535576973-8067-3-git-send-email-eajames@linux.vnet.ibm.com>
Cc: linux-media@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        openbmc@lists.ozlabs.org, andrew@aj.id.au, mchehab@kernel.org,
        joel@jms.id.au, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        mturquette@baylibre.com, linux-arm-kernel@lists.infradead.org,
        Eddie James <eajames@linux.vnet.ibm.com>
References: <1535576973-8067-1-git-send-email-eajames@linux.vnet.ibm.com>
 <1535576973-8067-3-git-send-email-eajames@linux.vnet.ibm.com>
Message-ID: <153573819934.93865.9948361566635476864@swboyd.mtv.corp.google.com>
Subject: Re: [PATCH 2/4] clock: aspeed: Setup video engine clocking
Date: Fri, 31 Aug 2018 10:56:39 -0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Eddie James (2018-08-29 14:09:31)
> Add the video engine reset bit. Add eclk mux and clock divider table.
> =

> Signed-off-by: Eddie James <eajames@linux.vnet.ibm.com>
> ---

Acked-by: Stephen Boyd <sboyd@kernel.org>
