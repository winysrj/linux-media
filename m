Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0183.hostedemail.com ([216.40.44.183]:47369 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727838AbeINCDe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 22:03:34 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave02.hostedemail.com (Postfix) with ESMTP id E84AA18035714
        for <linux-media@vger.kernel.org>; Thu, 13 Sep 2018 20:45:54 +0000 (UTC)
Message-ID: <c7a3263ac94a6c31bd58c06683d55015be2e8be4.camel@perches.com>
Subject: Re: [PATCH v2] staging: Convert to using %pOFn instead of
 device_node.name
From: Joe Perches <joe@perches.com>
To: Rob Herring <robh@kernel.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Arkver <ian.arkver.dev@gmail.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org
In-Reply-To: <CAL_JsqK8B46x8bm_aYggJSPAWrMGZ1rZ58uWCmyiSqA2KZpiFg@mail.gmail.com>
References: <20180828154433.5693-1-robh@kernel.org>
         <20180828154433.5693-7-robh@kernel.org> <20180912121705.010a999d@coco.lan>
         <CAL_JsqK8B46x8bm_aYggJSPAWrMGZ1rZ58uWCmyiSqA2KZpiFg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 13 Sep 2018 04:50:23 -0700
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2018-09-12 at 15:26 -0500, Rob Herring wrote:
> A problem with MAINTAINERS is there is no way to tell who applies
> patches for a given path vs. anyone else listed.

try the --scm option
