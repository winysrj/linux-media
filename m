Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:56007 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935513Ab3DIS6y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Apr 2013 14:58:54 -0400
Received: from mailout-eu.gmx.com ([10.1.101.214]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MBpxx-1UGWw042wp-00Ar0x for
 <linux-media@vger.kernel.org>; Tue, 09 Apr 2013 20:58:52 +0200
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Antti Palosaari" <crope@iki.fi>
Subject: Re: AverTV_A918R (af9035-af9033-tda18218) / patch proposal
References: <op.wp845xcf4bfdfw@quantal> <50E36298.3040009@iki.fi>
 <op.wu93cgqr4bfdfw@wheezy> <51645F09.9040901@iki.fi>
Date: Tue, 09 Apr 2013 20:58:48 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: Diorser <diorser@gmx.fr>
Message-ID: <op.wvae0aka4bfdfw@wheezy>
In-Reply-To: <51645F09.9040901@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With RF signal input now clearly reported at 0000, antenna switch problem  
is a good assumption.
However, I don't have the right skills to "sniff" and imagine which file  
should be modified and how.
All I can do is recompiling git files and test.
If a list a "GPIO" values was available somewhere, and if I know where to  
modify the files, and with some luck, a miracle could may be happen.
However, I fully understand that an express card is too specific to create  
some interest.
Don't worry about this.
I just wanted to give some update on investigations done 3 months ago  
(quite some time spent on it....).
Thanks.
Rgds.

>
> Patch, which adds USB ID, is not acceptable unless device is know to be  
> working. It currently works only partially by loading correct modules  
> but tuning does not work. Surely, it is not very many lines code to fix  
> it - most likely just some GPIO setting (antenna switch?).
>
> regards
> Antti
