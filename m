Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:48377 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078Ab1CVNHZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 09:07:25 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Q21Iy-0000qV-Ra
	for linux-media@vger.kernel.org; Tue, 22 Mar 2011 14:07:24 +0100
Received: from 193.160.199.2 ([193.160.199.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 22 Mar 2011 14:07:24 +0100
Received: from bjorn by 193.160.199.2 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 22 Mar 2011 14:07:24 +0100
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: S2-3200 switching-timeouts on 2.6.38
Date: Tue, 22 Mar 2011 14:07:13 +0100
Message-ID: <87tyevuwvy.fsf@nemi.mork.no>
References: <4D87AB0F.4040908@t-online.de>
	<20110321131602.36d146b1.rdunlap@xenotime.net>
	<AANLkTik22=YE-2W4AtO9w_kVm=oro_YM7hJ52Rj83Fmt@mail.gmail.com>
	<4D8888F7.6010903@t-online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Rico Tzschichholz <ricotz@t-online.de> writes:

>> Actually, quite a lot of effort was put in to get that part right. It
>> does the reverse thing that's to be done.
>> The revamped version is here [1] If the issue persists still, then it
>> needs to be investigated further.
>>
>> [1] http://www.mail-archive.com/linuxtv-commits@linuxtv.org/msg09214.html
>
> I am not sure how this is related to stb6100?
>
> Does that mean the current stb0899 patch [2] isnt ready to be proposed
> for 2.6.39 yet? Or does the stb6100 patch has a better design to solve
> this issue which should be adapted for stb0899 then?

I believe the point was that the real issue was a noise problem in the
stb6100 tuner driver, and that the stb0899 frontend patch just papered
over this.

> I was hoping to see it included before the merge window is closed again.
>
> [2] https://patchwork.kernel.org/patch/244201/

Please test the driver with the patch Manu refers to and report if there
still are issues.  The patch is now upstream in the 2.6.38 kernel, so
testing it should be fairly easy.  

Do you still have this issue with a plain 2.6.38 driver?


Bjørn

