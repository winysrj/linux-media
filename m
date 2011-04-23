Return-path: <mchehab@pedra>
Received: from cmsout01.mbox.net ([165.212.64.31]:35707 "EHLO
	cmsout01.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab1DWS5S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2011 14:57:18 -0400
Message-ID: <4DB320EF.3080301@usa.net>
Date: Sat, 23 Apr 2011 20:56:47 +0200
From: Issa Gorissen <flop.m@usa.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Oliver Endriss <o.endriss@gmx.de>
Subject: Re: ngene CI problems
References: <4D74E28A.6030302@gmail.com> <4DB1FE58.20006@usa.net> <201104231940.34575@orion.escape-edv.de>
In-Reply-To: <201104231940.34575@orion.escape-edv.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 23/04/11 19:40, Oliver Endriss wrote:
> On Saturday 23 April 2011 00:16:56 Issa Gorissen wrote:
>> Running a bunch of test with gnutv and a DuoFLEX S2.
>>
>> I saw the same problem concerning the decryption with a CAM.
>>
>> I'm running kern 2.6.39 rc 4 with the latest patches from Oliver. Also
>> applied the patch moving from SEC to CAIO.
> If you are running 2.6.39rc4, you must apply patch
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg29870.html
> Otherwise the data will be garbled.

Oliver, this patch was applied already. I'm hacking the ts_read/ts_write
method, but so far, haven't manage to get it work.
