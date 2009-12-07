Return-path: <linux-media-owner@vger.kernel.org>
Received: from viefep11-int.chello.at ([62.179.121.31]:35460 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759082AbZLGI73 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Dec 2009 03:59:29 -0500
Message-ID: <4B1CC3EE.5010605@waechter.wiz.at>
Date: Mon, 07 Dec 2009 09:59:26 +0100
From: =?UTF-8?B?TWF0dGhpYXMgV8OkY2h0ZXI=?= <matthias@waechter.wiz.at>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Mantis =?UTF-8?B?4oCTIGFueW9uZT8=?=
References: <4B0E6CC0.9030207@waechter.wiz.at> <1a297b360912042154q619caa3dkf3818793f46c2c50@mail.gmail.com> <4B1BA901.3080703@waechter.wiz.at>
In-Reply-To: <4B1BA901.3080703@waechter.wiz.at>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu,

Am 06.12.2009 13:52, schrieb Matthias Wächter:
> • Sometimes very slow lock at transponder change, slow enough to trace
> it in femon. femon first shows high BER rates and the picture is blocky,
> reducing within 3 or 4 Seconds to BER=0 and perfect picture. I should be
> able to repeat that and give you some logs if you need it.
> 
> • Sometimes lock to a transponder only in certain order of previous
> transponder. Hard to formalize, though. Verbose module output shows 1 to
> 2 unsuccessful locking attempts per second by the driver.

> • Currently no lock on 19.2/12693h either, but this may be a signal
> quality issue on my side.

After playing some more, I think those are all related: Lock to a
transponder takes from <1 second to minutes, and sometimes I was not
patient enough to wait for the lock to finally happen.

The no-lock on 19.2°/11303h does not seem to be related to that.

– Matthias
