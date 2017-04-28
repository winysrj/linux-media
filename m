Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:60341 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755291AbdD1L6d (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 07:58:33 -0400
Date: Fri, 28 Apr 2017 12:58:32 +0100
From: Sean Young <sean@mess.org>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH 5/6] rc-core: use the full 32 bits for NEC scancodes
Message-ID: <20170428115832.GB21792@gofer.mess.org>
References: <149332488240.32431.6597996407440701793.stgit@zeus.hardeman.nu>
 <149332525833.32431.1765495360604915898.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <149332525833.32431.1765495360604915898.stgit@zeus.hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 27, 2017 at 10:34:18PM +0200, David Härdeman wrote:
> Using the full 32 bits for all kinds of NEC scancodes simplifies rc-core
> and the nec decoder without any loss of functionality. At the same time
> it ensures that scancodes for NEC16/NEC24/NEC32 do not overlap and
> removes lots of duplication (as you can see from the patch, the same NEC
> disambiguation logic is contained in several different drivers).
> 
> Using NEC32 also removes ambiguity. For example, consider these two NEC
> messages:
> NEC16 message to address 0x05, command 0x03
> NEC24 message to address 0x0005, command 0x03
> 
> They'll both have scancode 0x00000503, and there's no way to tell which
> message was received.

It's not ambiguous, the protocol is different (RC_TYPE_NEC vs RC_TYPE_NECX).

> In order to maintain backwards compatibility, some heuristics are added
> in rc-main.c to convert scancodes to NEC32 as necessary when userspace
> adds entries to the keytable using the regular input ioctls. These
> heuristics are essentially the same as the ones that are currently in
> drivers/media/rc/img-ir/img-ir-nec.c (which are rendered unecessary
> with this patch).

There are issues with the patch which breaks userspace, as discussed
in the previous patch. None of those issues have been addressed.

In addition, I've read https://david.hardeman.nu/rccore/#problems-nec
There is nothing there what you have not stated before about nec being
"ambiguous", even though the protocol variant is different.


Sean
