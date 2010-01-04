Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f197.google.com ([209.85.223.197]:60668 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab0ADLho (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jan 2010 06:37:44 -0500
Received: by iwn35 with SMTP id 35so10316921iwn.4
        for <linux-media@vger.kernel.org>; Mon, 04 Jan 2010 03:37:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1262390254.8927.15.camel@sirius>
References: <1262390254.8927.15.camel@sirius>
Date: Mon, 4 Jan 2010 19:37:38 +0800
Message-ID: <8cd7f1781001040337q71c3cafcl9a2a4c6e77502ce6@mail.gmail.com>
Subject: Re: DVBWorld DVB-S2 2005 PCI-Express Card
From: Leszek Koltunski <leszek@koltunski.pl>
To: =?UTF-8?B?SmFrdWIgTMOhem5pxI1rYQ==?= <jakub@jiznak.cz>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a very similar problem with DVBWorld 2006 DVB-S2 card.
The v4l-dvb ( freshly pulled ) compiles and loads, firmware is loaded,
but when I actually try to use it ( dvbstream commands ) the following
appears in /var/log/messages:

Jan  4 18:30:24 november kernel: i2c_sendbytes: i2c error NAK or timeout occur
Jan  4 18:30:24 november kernel: ds3000_readreg: reg=0xd1(error=-1)
Jan  4 18:30:25 november kernel: i2c_sendbytes: i2c error NAK or timeout occur
Jan  4 18:30:25 november kernel: ds3000_readreg: reg=0xd1(error=-1)
Jan  4 18:30:25 november kernel: i2c_sendbytes: i2c error NAK or timeout occur
Jan  4 18:30:25 november kernel: ds3000_writereg: writereg error(err
== -1, reg == 0xf9, value == 0x04)
Jan  4 18:30:25 november kernel: i2c_sendbytes: i2c error NAK or timeout occur
Jan  4 18:30:25 november kernel: ds3000_readreg: reg=0xf8(error=-1)
Jan  4 18:30:25 november kernel: i2c_sendbytes: i2c error NAK or timeout occur
Jan  4 18:30:25 november kernel: ds3000_writereg: writereg error(err
== -1, reg == 0x03, value == 0x12)
Jan  4 18:30:25 november kernel: i2c_sendbytes: i2c error NAK or timeout occur
Jan  4 18:30:25 november kernel: ds3000_tuner_readreg: reg=0x3d(error=-1)
Jan  4 18:30:25 november kernel: i2c_sendbytes: i2c error NAK or timeout occur
Jan  4 18:30:25 november kernel: ds3000_writereg: writereg error(err
== -1, reg == 0x03, value == 0x12)
Jan  4 18:30:25 november kernel: i2c_sendbytes: i2c error NAK or timeout occur
Jan  4 18:30:25 november kernel: ds3000_tuner_readreg: reg=0x21(error=-1)

... and many more of this.

Actually I have to say I already tried DVBWorld 2006, NetUP dual
DVB-S2 and TwinHan VP-1041 ( like the Technisat card ) but no success
at all. DVBWorld is giving me errors like above, NetUP's driver loads
but doesn't want to tune to anything, Twinhan can tune to one
transponder and scan the channels but for reasons far beyond me fails
to tune to anything else.

DVB-T ( Leadtek WinFast ) is working for me perfectly, but DVB-S is an
exercise in frustration...
