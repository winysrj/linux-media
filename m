Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727069AbeHaWFM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 18:05:12 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
To: Eddie James <eajames@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
From: Stephen Boyd <sboyd@kernel.org>
In-Reply-To: <1535576973-8067-2-git-send-email-eajames@linux.vnet.ibm.com>
Cc: linux-media@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        openbmc@lists.ozlabs.org, andrew@aj.id.au, mchehab@kernel.org,
        joel@jms.id.au, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        mturquette@baylibre.com, linux-arm-kernel@lists.infradead.org,
        Eddie James <eajames@linux.vnet.ibm.com>
References: <1535576973-8067-1-git-send-email-eajames@linux.vnet.ibm.com>
 <1535576973-8067-2-git-send-email-eajames@linux.vnet.ibm.com>
Message-ID: <153573819579.93865.16877422358186375613@swboyd.mtv.corp.google.com>
Subject: Re: [PATCH 1/4] clock: aspeed: Add VIDEO reset index definition
Date: Fri, 31 Aug 2018 10:56:35 -0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Eddie James (2018-08-29 14:09:30)
> Add an index into the array of resets kept in the Aspeed clock driver.
> This isn't a HW bit definition.
> =

> Signed-off-by: Eddie James <eajames@linux.vnet.ibm.com>
> ---

Acked-by: Stephen Boyd <sboyd@kernel.org>
