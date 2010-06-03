Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:45136 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932217Ab0FCQl0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Jun 2010 12:41:26 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1OKDTu-0006BF-E6
	for linux-media@vger.kernel.org; Thu, 03 Jun 2010 18:41:22 +0200
Received: from nemi.mork.no ([148.122.252.4])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 03 Jun 2010 18:41:22 +0200
Received: from bjorn by nemi.mork.no with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 03 Jun 2010 18:41:22 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: Terratec Cinergy C DVB-C card problems
Date: Thu, 03 Jun 2010 18:41:13 +0200
Message-ID: <874ohk83x2.fsf@nemi.mork.no>
References: <AANLkTin5aDjdLQ4W0FJc6Te9E_HOCV9dz8DnGdrA-Voq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Billy Brumley <bbrumley@gmail.com> writes:

> I've got a terratec cinergy c dvb-c card, fresh install of ubuntu
> 10.04 lucid i386. Card is here:
>
> http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_C_DVB-C

I don't know what's wrong with your installation, but you may want to
try installing the mantis driver without completely replacing the
dvb-core.

FYI, the mantis driver will be included in the next Debian 2.6.32 based
kernel release thanks to the excellent Debian kernel team:
http://bugs.debian.org/57724 . I guess that means that it will be
available in Unbuntu soon as well.

Anyway, the patch from that bug report should easily apply to any 2.6.32
kernel without having to mess with the whole DVB system.



Bjørn

