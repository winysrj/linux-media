Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:36895 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751404AbdILPav (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 11:30:51 -0400
Date: Tue, 12 Sep 2017 16:30:49 +0100
From: Sean Young <sean@mess.org>
To: Mason <slash.tmp@free.fr>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: Duplicated debug message in drivers/media/rc/rc-main.c
Message-ID: <20170912153049.gistk5gyrzbnygzz@gofer.mess.org>
References: <d03f24dd-2e71-5f72-0c71-54ddc468f00a@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d03f24dd-2e71-5f72-0c71-54ddc468f00a@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mason,

On Tue, Sep 12, 2017 at 02:39:14PM +0200, Mason wrote:
> Hello,
> 
> I enabled all debug messages, and I see:
> 
> [    1.931214] Allocated space for 1 keycode entries (8 bytes)
> [    1.936822] Allocated space for 1 keycode entries (8 bytes)
> 
> One comes from ir_create_table()
> The other from ir_setkeytable()
> 
> ir_setkeytable() calls ir_create_table()
> 
> It looks like one of the two debug messages should be deleted?

Yes, you're right. Patches are welcome :)

Thanks

Sean
