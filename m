Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0079.hostedemail.com ([216.40.44.79]:44701 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S965140AbeF0Nnw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 09:43:52 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave07.hostedemail.com (Postfix) with ESMTP id AF6A61804FAF3
        for <linux-media@vger.kernel.org>; Wed, 27 Jun 2018 13:37:03 +0000 (UTC)
Message-ID: <06bca9497a878d5f494fd97dbe2d8448caab9afd.camel@perches.com>
Subject: Re: [PATCH v2] staging: media: omap4iss: Added SPDX license
 identifiers
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Daniel Graefe <daniel.graefe@fau.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devel@driverdev.osuosl.org, linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Roman Sommer <roman.sommer@fau.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Date: Wed, 27 Jun 2018 06:36:58 -0700
In-Reply-To: <20180627084013.ybnbxbgha77cdujn@mwanda>
References: <1529932892-9036-1-git-send-email-daniel.graefe@fau.de>
         <1530048656-4074-1-git-send-email-daniel.graefe@fau.de>
         <20180627084013.ybnbxbgha77cdujn@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2018-06-27 at 11:40 +0300, Dan Carpenter wrote:
> On Tue, Jun 26, 2018 at 11:30:56PM +0200, Daniel Graefe wrote:
> > Changes in v2:
> > - replaced "GPL-2.0-or-later" with "GPL-2.0+"
> 
> We should make checkpatch.pl complain when people use wrong tags like
> GPL-2.0-or-later.

I'd rather we use the latest version of the spdx forms.
https://lkml.org/lkml/2018/2/2/883
I think it's better to modify checkpatch when the kernel
uses the latest forms.

There is a separate script that validates the spdx forms.
./scripts/spdxcheck.py

That script, which still needs the patch below, would work
with either style.

https://patchwork.kernel.org/patch/10448573/

$ python ./scripts/spdxcheck.py 
include/dt-bindings/reset/amlogic,meson-axg-reset.h: 9:41 Invalid License ID: BSD

or for more verbose output

$ python ./scripts/spdxcheck.py -v
include/dt-bindings/reset/amlogic,meson-axg-reset.h: 9:41 Invalid License ID: BSD

License files:               14
Exception files:              1
License IDs                  19
Exception IDs                 1

Files checked:            60967
Lines checked:           646729
Files with SPDX:          17393
Files with errors:            1
