Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fireflyinternet.com ([109.228.58.192]:62901 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752444AbeFEXvW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2018 19:51:22 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Daniel Rosenberg <drosen@google.com>,
        "Sumit Semwal" <sumit.semwal@linaro.org>,
        linux-kernel@vger.kernel.org
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20180605234041.246060-1-drosen@google.com>
Cc: "Daniel Rosenberg" <drosen@google.com>,
        "Divya Ponnusamy" <pdivya@codeaurora.org>,
        "Gustavo Padovan" <gustavo@padovan.org>,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        "stable" <stable@vger.kernel.org>, kernel-team@android.com,
        linux-media@vger.kernel.org
References: <20180605234041.246060-1-drosen@google.com>
Message-ID: <152824267238.9058.16502636333550686918@mail.alporthouse.com>
Subject: Re: [Linaro-mm-sig] [PATCH resend] drivers: dma-buf: Change %p to %pK in
 debug messages
Date: Wed, 06 Jun 2018 00:51:12 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Daniel Rosenberg (2018-06-06 00:40:41)
> The format specifier %p can leak kernel addresses
> while not valuing the kptr_restrict system settings.
> Use %pK instead of %p, which also evaluates whether
> kptr_restrict is set.

This is backwards though. You never care about the actual value here and
the hashed pointer (%p) is always enough to provide an identifying token.
-Chris
