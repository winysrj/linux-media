Return-path: <linux-media-owner@vger.kernel.org>
Received: from ozgw.promptu.com ([203.144.27.9]:1332 "EHLO
	surfers.oz.promptu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751173AbZHSHCj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 03:02:39 -0400
Date: Wed, 19 Aug 2009 17:02:31 +1000
From: Bob Hepple <bhepple@promptu.com>
To: treblid <treblid@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: help: Can't get DViCO FusionHDTV DVB-T Dual Digital 4 to work
 with  new kernels
Message-Id: <20090819170231.a411e47a.bhepple@promptu.com>
In-Reply-To: <941593fd0908182109p22e5e5f0i6959369c9ac7c12f@mail.gmail.com>
References: <941593fd0908182109p22e5e5f0i6959369c9ac7c12f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2.6.27 worked for me - exact same board (ignoring revisions - mine is
an older board, rev.1, I think) 

2.6.28 and up failed for me in exactly this manner. Same with a
head-of-tree v4l-dvb 'hg clone'

AFAICT it's a v4l-dvb driver problem - at least no-one here refutes it
since I reported it here on 20090615.

Cheers


Bob





On Wed, 19 Aug 2009 12:09:24 +0800
treblid <treblid@gmail.com> wrote:

> Been grappling with this problem for a while now..
> I am using stock linux kernel 2.6.28.9 together with Mythtv (SVN trunk)
> 
> For some reason I cannot use 2.6.29.x or 2.6.30.x (latest version I
> tried is 2.6.30.5).
> 
> Everytime i start mythbackend, the console is littered with the
> following messages, and the keyboard input freezes sporadically.
> the messages as below:
> 
> dvb-usb: recv bulk message failed: -110
> cxusb: i2c read failed
> 
> i googled for a solution and it seems some got around this by inserted
> the IR receiver, I tried but it still doesn't work.
> 
> is this a mythtv problem or cxusb issue?
> 
> Please help, any pointers appreciated.
> 
> regards,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Bob Hepple <bhepple@promptu.com>
ph: 07-5584-5908 Fx: 07-5575-9550
