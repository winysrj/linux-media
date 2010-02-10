Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43487 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280Ab0BJTFT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 14:05:19 -0500
Received: by vws20 with SMTP id 20so108235vws.19
        for <linux-media@vger.kernel.org>; Wed, 10 Feb 2010 11:05:18 -0800 (PST)
Message-ID: <4B730364.8090406@gmail.com>
Date: Wed, 10 Feb 2010 17:05:08 -0200
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Franklin Meng <fmeng2002@yahoo.com>
CC: Douglas Schilling <dougsland@gmail.com>,
	maillist <linux-media@vger.kernel.org>
Subject: Re: [Patch] Kworld 315U remote support
References: <311770.77952.qm@web32701.mail.mud.yahoo.com>
In-Reply-To: <311770.77952.qm@web32701.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Franklin Meng wrote:
> Mauro, 
> 
> I tried out the ir_type change to the code and when I set it to IR_TYPE_NEC, I see messages in the log indicating that the key was not recognized.  Using IR_TYPE_OTHER seems to work ok.
> 
> My guess is that if I modify the keycodes IR_TYPE_NEC will work as well.

If it is displaying a log, it means that the protocol is NEC.
All you need is to add the 8 most significant bits to the table. In general,
this code is common to all keystrokes.

For example, this is the legacy keymap table for Hauppauge IR:

static struct ir_scancode ir_codes_hauppauge_new[] = {
        /* Keys 0 to 9 */
        { 0x00, KEY_0 },
        { 0x01, KEY_1 },
        { 0x02, KEY_2 },
        { 0x03, KEY_3 },
        { 0x04, KEY_4 },

The new table is:

static struct ir_scancode ir_codes_rc5_hauppauge_new[] = {
        /* Keys 0 to 9 */
        { 0x1e00, KEY_0 },
        { 0x1e01, KEY_1 },
        { 0x1e02, KEY_2 },
        { 0x1e03, KEY_3 },
        { 0x1e04, KEY_4 },

You'll notice that the only difference is that the code now has
"0x1e00" added to all keys, and that the new table has the
protocol properly indicated.

> Can I just use IR_TYPE_OTHER?  That seems like the most straight forward approach with the least amount of changes.  

The usage of IR_TYPE_OTHER disables some new API's that are shown
to userspace, that allows the replacement of the IR for a better one.

Due to that, the usage of IR_TYPE_OTHER is deprecated. 

We should really get rid of  all those legacy keymaps that don't 
inform the IR protocol, not allowing that the key sequences and protocols 
to  be properly seen on userspace and eventually replaced, if the user
wants to buy a powerful remote and associate other keys to his IR.

So, please don't use IR_TYPE_OTHER.

Cheers,
Mauro
