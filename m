Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:43873 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932651Ab0FEJ07 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Jun 2010 05:26:59 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1OKpec-0004Dw-BK
	for linux-media@vger.kernel.org; Sat, 05 Jun 2010 11:26:58 +0200
Received: from ti521110a080-2322.bb.online.no ([85.167.97.22])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 05 Jun 2010 11:26:58 +0200
Received: from bjorn by ti521110a080-2322.bb.online.no with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 05 Jun 2010 11:26:58 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: Terratec Cinergy C DVB-C card problems
Date: Sat, 05 Jun 2010 11:26:48 +0200
Message-ID: <87631x25k7.fsf@nemi.mork.no>
References: <AANLkTinh0rXgar5Q0cDqLuBkXtK7b7JPUxyKZI_E9xe3@mail.gmail.com>
	<AANLkTil4vj-6yx4uywsCZi7vQxDs_0fc6PmlN_VKd1ly@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rune Evjen <rune.evjen@gmail.com> writes:

> For some reason this module is not automatically loaded during boot
> with ubuntu, but I added 'modprobe mantis' to /etc/rc.local so that it
> loads during bootup.

The mantis driver in linux 2.6.33-2.6.35-rc1 is still missing this patch:
http://jusst.de/hg/mantis-v4l-dvb/raw-rev/3731f71ed6bf

You can apply that on top of your Ubuntu 2.6.33 kernel if you want to
add auto loading.


Bjørn

