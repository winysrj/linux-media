Return-path: <linux-media-owner@vger.kernel.org>
Received: from viefep19-int.chello.at ([62.179.121.39]:40290 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935331AbZLHAAR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Dec 2009 19:00:17 -0500
Message-ID: <4B1D9712.60807@waechter.wiz.at>
Date: Tue, 08 Dec 2009 01:00:18 +0100
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

Hi Manu,

Just to give you some feedback on the first issue as well:

Am 06.12.2009 13:52, schrieb Matthias Wächter:
> • Can’t lock to 19.2/11303h (looks like something new, related to the
> change of the transponder’s feed, but other cards – e.g. TBS 6920 and
> Tevii 470 – do sync without a problem). Looks like a frontend issue to
> me (STB0899/STB6100), as mantis and budget-ci cards are affected in the
> same way. This correlates with perfect and quick lock of 19.2/11362h
> which is about the same frequency and has the same DVB parameters
> (22000/hC23M5O35S1).

One guy on vdrportal.de tried his card under Windows, and he can there
lock to that transponder. He tells that locking took quite some time,
though, and it appears that transponder shows unexpected low signal
strength, but I would take that with a grain of salt as it might be
different frontend handling and value scaling.

– Matthias
