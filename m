Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0009.hostedemail.com ([216.40.44.9]:49139 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753742AbdLNSyn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 13:54:43 -0500
Message-ID: <1513277679.27409.83.camel@perches.com>
Subject: Re: [PATCH] media: v4l: xilinx: Use SPDX-License-Identifier
From: Joe Perches <joe@perches.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dhaval Shah <dhaval23031987@gmail.com>, hyun.kwon@xilinx.com,
        michal.simek@xilinx.com, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 14 Dec 2017 10:54:39 -0800
In-Reply-To: <16301043.Lbu0ahMgBI@avalon>
References: <20171208123537.18718-1-dhaval23031987@gmail.com>
         <7339763.I7jApfYMM6@avalon> <1513276340.27409.77.camel@perches.com>
         <16301043.Lbu0ahMgBI@avalon>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-12-14 at 20:37 +0200, Laurent Pinchart wrote:
> Hi Joe,

Hi Laurent.

> On Thursday, 14 December 2017 20:32:20 EET Joe Perches wrote:
> > Adding a comment line that describes an implicit or
> > explicit license is different than removing the license
> > text itself.
> 
> The SPDX license header is meant to be equivalent to the license text.

I understand that.
At a minimum, removing BSD license text is undesirable
as that license states:

 *    * Redistributions of source code must retain the above copyright
 *      notice, this list of conditions and the following disclaimer.
etc...

> The only reason why the large SPDX patch didn't touch the whole kernel in one go 
> was that it was easier to split in in multiple chunks.

Not really, it was scripted.

> This is no different 
> than not including the full GPL license in every header file but only pointing 
> to it through its name and reference, as every kernel source file does.

Not every kernel source file had a license text
or a reference to another license file.
