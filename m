Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:58243 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731192AbeGZTzI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jul 2018 15:55:08 -0400
Date: Thu, 26 Jul 2018 20:37:02 +0200
From: Matthias Reichl <hias@horus.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: Logspam with "two consecutive events of type space" on
 gpio-ir-recv and meson-ir
Message-ID: <20180726183702.n263p7d5rstx52rj@lenny.lan>
References: <20180721190421.5m4jfgvknglv5ii4@camel2.lan>
 <20180725202100.vctkcuok7thxmmcq@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180725202100.vctkcuok7thxmmcq@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

On Wed, Jul 25, 2018 at 09:21:00PM +0100, Sean Young wrote:
> Hi Hias,
> 
> On Sat, Jul 21, 2018 at 09:04:21PM +0200, Matthias Reichl wrote:
> > Hi Sean,
> > 
> > I noticed that on 4.18-rc5 I get dmesg logspam with
> > "rc rc0: two consecutive events of type space" on gpio-ir-recv
> > and meson-ir - mceusb seems to be fine (haven't tested with
> > other IR receivers yet).
> 
> This does not have a proper fix yet, however we have a workaround
> here:
> 
> https://git.linuxtv.org/media_tree.git/commit/?h=fixes&id=0ca54b29054151b7a52cbb8904732280afe5a302

Ah, thanks a lot for the pointer, must have missed the discussion
and patch on the list.

The workaround looks fine to me and should be good enough for now.

so long,

Hias
