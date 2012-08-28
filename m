Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39304 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab2H1Qhx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Aug 2012 12:37:53 -0400
Received: by obbuo13 with SMTP id uo13so10870429obb.19
        for <linux-media@vger.kernel.org>; Tue, 28 Aug 2012 09:37:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAnFQG8xZ9b_tsd6XeHyO3AbbxDTfoQvNaDAX=hSHSwJsK_tGg@mail.gmail.com>
References: <CAAnFQG8xZ9b_tsd6XeHyO3AbbxDTfoQvNaDAX=hSHSwJsK_tGg@mail.gmail.com>
From: Javier Marcet <jmarcet@gmail.com>
Date: Tue, 28 Aug 2012 18:37:32 +0200
Message-ID: <CAAnFQG-2YKgsO6yH1F5EiSK+qCc1LkZNsPKPG1bd=kqWG-hJ+A@mail.gmail.com>
Subject: TerraTec Cinergy T PCIe Dual bug
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have recently bought a TerraTec Cinergy T PCIe Dual for an HTPC.

It didn't work at first, with kernel 3.4 which already supported it.

After checking everything I find out that I have to manually change
the frontend of the second tuner to DVB-T and also tune some channel
with tzap before being able to use vdr with it.

An ugly workaround, but still works.

On the other hand, after resuming from suspension, even removing and
loading all the dvb drivers, randomly I begin to see lots of:

cx23885_wakeup: 2 buffers handled (should be 1)

And of course the tuners don't work.

You can see the relevant logs at:
https://dl.dropbox.com/u/12579112/dmesg-debug.log
https://dl.dropbox.com/u/12579112/dmesg-debug1c.log
https://dl.dropbox.com/u/12579112/dmesg-suspend.log
https://dl.dropbox.com/u/12579112/lspci.log

The debug log is with the parameters:
options cx23885 i2c_debug=1 irq_debug=1

and the debug1c has debug=1.

I'd appreciate any help.


-- 
Javier Marcet <jmarcet@gmail.com>
