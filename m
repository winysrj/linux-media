Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:39661 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753661AbdASRxN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jan 2017 12:53:13 -0500
Date: Thu, 19 Jan 2017 17:16:36 +0000
From: Sean Young <sean@mess.org>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: Time for a v4l-utils 1.12 release
Message-ID: <20170119171636.GA26157@gofer.mess.org>
References: <d7d9d081-5fb5-3d1c-0cbb-e69b0920fee0@googlemail.com>
 <20170116100656.GA23993@gofer.mess.org>
 <2e009306-bb2b-1c43-fa99-dc0974696e19@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e009306-bb2b-1c43-fa99-dc0974696e19@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gregor,

On Mon, Jan 16, 2017 at 09:00:40PM +0100, Gregor Jasny wrote:
> On 16/01/2017 11:06, Sean Young wrote:
> > On Mon, Jan 16, 2017 at 09:10:36AM +0100, Gregor Jasny wrote:
> >> Hello,
> >>
> >> I'd like to do a new v4l-utils release before the Debian freeze. Is master
> >> in a releasable state? Or should I wait for some more patches to land?
> > 
> > This pull request is still waiting to be merged.
> > 
> > https://patchwork.linuxtv.org/patch/38830/
> 
> As far as I can tell this looks good. Merged.

I've been testing the ir-ctl tool and there are two futher commits I'd like
to be merged before release. One is reading uninitialised memory and the
other make sure we set the right lirc mode, in case we add a lirc scancode
mode.

Many thanks,
Sean


The following changes since commit 42ac437b3493615d5571f5f76f73979145fef1b2:

  v4l2-ctl: add --stream-sleep option (2017-01-18 17:22:23 +0100)

are available in the git repository at:

  git://git.linuxtv.org/syoung/v4l-utils.git ir-fixes2

for you to fetch changes up to c6b8f8da12ee914def59ecc0de80f4755298d053:

  ir-ctl: ensure that device can record and that correct mode is set (2017-01-19 14:18:04 +0000)

----------------------------------------------------------------
Sean Young (2):
      ir-ctl: uninitialised memory used
      ir-ctl: ensure that device can record and that correct mode is set

 utils/ir-ctl/ir-ctl.c    | 21 ++++++++++++++++++++-
 utils/ir-ctl/ir-encode.c |  1 +
 2 files changed, 21 insertions(+), 1 deletion(-)
