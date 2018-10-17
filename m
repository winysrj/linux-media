Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot1-f66.google.com ([209.85.210.66]:47037 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727047AbeJQW7A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 18:59:00 -0400
Date: Wed, 17 Oct 2018 10:02:52 -0500
From: Rob Herring <robh@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Vladimir Zapolskiy <vz@mleia.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mark Vasut <marek.vasut@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-media@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Subject: Re: [PATCH 3/7] dt-bindings: pinctrl: ds90ux9xx: add description of
 TI DS90Ux9xx pinmux
Message-ID: <20181017150252.GA11075@bogus>
References: <20181008211205.2900-1-vz@mleia.com>
 <20181008211205.2900-4-vz@mleia.com>
 <CACRpkdZJMPYWHBUXohjxo12XZpLdz7OzcWRBrrkcB8YLLd5StA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZJMPYWHBUXohjxo12XZpLdz7OzcWRBrrkcB8YLLd5StA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 10, 2018 at 10:45:43AM +0200, Linus Walleij wrote:
> Hi Vladimir,
> 
> thanks for your patch!
> 
> Can we change the subject to something like "add DT bindings" rather than
> "add description" as it is more specific and makes it easier for me as
> maintainer.

To add to the nitpicking, The subject already says DT and bindings, so 
no need to repeat it. I'd just drop "description of" if anything.

Rob
