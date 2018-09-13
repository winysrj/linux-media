Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727728AbeINCiV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 22:38:21 -0400
MIME-Version: 1.0
References: <20180828154433.5693-1-robh@kernel.org> <20180828154433.5693-7-robh@kernel.org>
 <20180912121705.010a999d@coco.lan> <CAL_JsqK8B46x8bm_aYggJSPAWrMGZ1rZ58uWCmyiSqA2KZpiFg@mail.gmail.com>
 <c7a3263ac94a6c31bd58c06683d55015be2e8be4.camel@perches.com>
In-Reply-To: <c7a3263ac94a6c31bd58c06683d55015be2e8be4.camel@perches.com>
From: Rob Herring <robh@kernel.org>
Date: Thu, 13 Sep 2018 16:26:53 -0500
Message-ID: <CAL_JsqL=+O=G-0uVdKGcq4T8pSzkdGV1sd_p682-6SFXuNt2mA@mail.gmail.com>
Subject: Re: [PATCH v2] staging: Convert to using %pOFn instead of device_node.name
To: Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Arkver <ian.arkver.dev@gmail.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 13, 2018 at 3:45 PM Joe Perches <joe@perches.com> wrote:
>
> On Wed, 2018-09-12 at 15:26 -0500, Rob Herring wrote:
> > A problem with MAINTAINERS is there is no way to tell who applies
> > patches for a given path vs. anyone else listed.
>
> try the --scm option

That kind of helps if the maintainer has listed a tree, but gives
wrong results if not. And you still have to figure out who owns which
tree. That's not hard, but it's not scriptable.

IMO, we should reserve 'M:' for maintainers with trees and use 'R:'
driver maintainers. That's redefining M as "maintainer" rather than
"mail patches to". You could still have both for a entry so you can
know who to go bug when your patch hasn't been applied.

Rob
