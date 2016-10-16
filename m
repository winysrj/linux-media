Return-path: <linux-media-owner@vger.kernel.org>
Received: from parrot.pmhahn.de ([88.198.50.102]:57385 "EHLO parrot.pmhahn.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753943AbcJPVw0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Oct 2016 17:52:26 -0400
Date: Sun, 16 Oct 2016 23:52:19 +0200
From: Philipp Matthias Hahn <pmhahn+video@pmhahn.de>
To: Andrey Utkin <andrey_utkin@fastmail.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH] Potential fix for "[BUG] process stuck when closing
 saa7146 [dvb_ttpci]"
Message-ID: <20161016215219.4xob7nrbmrr7uxlj@pmhahn.de>
References: <20160911133317.whw3j2pok4sktkeo@pmhahn.de>
 <20160916100028.8856-1-andrey_utkin@fastmail.com>
 <41790808-9100-2999-3d92-921d2076be3e@pmhahn.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41790808-9100-2999-3d92-921d2076be3e@pmhahn.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Andrey,

On Mon, Sep 19, 2016 at 07:08:52AM +0200, Philipp Hahn wrote:
> Am 16.09.2016 um 12:00 schrieb Andrey Utkin:
> > Please try this patch. It is purely speculative as I don't have the hardware,
> > but I hope my approach is right.
> 
> Thanks you for the patch; I've built a new kernel but didn't have the
> time to test it yet; I'll mail you again as soon as I have tested it.

I tested your patch and during my limites testing I wan't able to
reproduce the previous problem. Seems you fixed it.

Tested-by: Philipp Matthias Hahn <pmhahn@pmhahn.de>

Thanks you again for looking into that issues.

Philipp
-- 
  / /  (_)__  __ ____  __ Philipp Hahn
 / /__/ / _ \/ // /\ \/ /
/____/_/_//_/\_,_/ /_/\_\ pmhahn@pmhahn.de
