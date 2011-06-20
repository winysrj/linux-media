Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43545 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab1FTWgJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 18:36:09 -0400
Received: by ewy4 with SMTP id 4so1389723ewy.19
        for <linux-media@vger.kernel.org>; Mon, 20 Jun 2011 15:36:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87wrggb1bg.fsf@nemi.mork.no>
References: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com>
	<201106202037.19535.remi@remlab.net>
	<BANLkTinn0uN3VwGfqCbYbxFoVf6aNo1VSA@mail.gmail.com>
	<BANLkTin14LnwP+_K1m-RsEXza4M4CjqnEw@mail.gmail.com>
	<BANLkTimR-zWnnLBcD2w8d8NpeFJi=eT9nQ@mail.gmail.com>
	<005a01cc2f7d$a799be30$f6cd3a90$@coexsi.fr>
	<BANLkTinbQ8oBJt7fScuT5vHGFktbaQNY5A@mail.gmail.com>
	<87wrggb1bg.fsf@nemi.mork.no>
Date: Tue, 21 Jun 2011 00:36:07 +0200
Message-ID: <BANLkTi=P9OV5J0Dz=_uyiKqR-NrvBvAs5g@mail.gmail.com>
Subject: Re: [RFC] vtunerc - virtual DVB device driver
From: HoP <jpetrous@gmail.com>
To: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bjørn.

2011/6/21 Bjørn Mork <bjorn@mork.no>:
> Devin Heitmueller <dheitmueller@kernellabs.com> writes:
>
>> Nothing prevents a third-party from writing closed source drivers.
>> What we do *not* think is fair though is that those third parties
>> should be able to take advantage of all the GPL code that makes up the
>> DVB core, and the man-years spent developing that code.
>
> You could use the same argument against adding a loadable module
> interface to the Linux kernel (and I'm pretty sure it was used).
> Thankfully, usability won back then.  Or we most likely wouldn't have
> had a single Linux DVB driver.  Or Linux at all, except as a historical
> footnote.
>
> Honza posted a GPL licensed driver and gave a pretty good usage
> scenario.  Please don't reject it based on fear of abuse.  If you think
> about it, almost any usability improvement will also make abuse easier.
> And if you reject all of them based on such fear, then your system will
> die.

Thank you for you support. Until now I thought that my non-understanding
of that "abuse-fearing-rule" was only my own brain defect :-)

So, linux-media guys, don't worry. Because vtunerc is my very first kernel
code I can assure you that you find most likely some design defects
or something like that what prevent of code upstreaming. It can take loooong
time until the code will grow up for upstreaming :-)

/Honza

PS: The driver is in use for more then 6 months with VDR.
