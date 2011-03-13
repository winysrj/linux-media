Return-path: <mchehab@pedra>
Received: from alia.ip-minds.de ([84.201.38.2]:54129 "EHLO alia.ip-minds.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab1CMLE3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Mar 2011 07:04:29 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by alia.ip-minds.de (Postfix) with ESMTP id AD14066AFB2
	for <linux-media@vger.kernel.org>; Sun, 13 Mar 2011 12:04:49 +0100 (CET)
Received: from alia.ip-minds.de ([127.0.0.1])
	by localhost (alia.ip-minds.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hxIkFukvyRv2 for <linux-media@vger.kernel.org>;
	Sun, 13 Mar 2011 12:04:49 +0100 (CET)
Received: from localhost (pD9E1A3D9.dip.t-dialin.net [217.225.163.217])
	by alia.ip-minds.de (Postfix) with ESMTPA id 5092766A08C
	for <linux-media@vger.kernel.org>; Sun, 13 Mar 2011 12:04:49 +0100 (CET)
Date: Sun, 13 Mar 2011 13:04:26 +0100
From: Jean-Michel Bruenn <jean.bruenn@ip-minds.de>
To: linux-media@vger.kernel.org
Subject: Re: WinTV 1400 broken with recent versions?
Message-Id: <20110313130426.c3c53baf.jean.bruenn@ip-minds.de>
In-Reply-To: <AANLkTikZ4KFSrzj6cJhbST9DWVcDqgQ6Y8R3we9614Bo@mail.gmail.com>
References: <20110309175231.16446e92.jean.bruenn@ip-minds.de>
	<76A39CFB-2838-4AD7-B353-49971F9F7DFF@wilsonet.com>
	<ba12e998349efa465be466a4d7f9d43f@localhost>
	<3AF3951C-11F6-48E4-A0EE-85179B013AFC@wilsonet.com>
	<81E0AF02-0837-4DF8-BFEA-94A654FFF471@wilsonet.com>
	<af7d57a1bb478c0edac4cd7afdfd6f41@localhost>
	<AANLkTimqGxS6OYNarqQwZNxFk+rccPn40UcK+6Oo72SC@mail.gmail.com>
	<3934d121118af31f8708589189a42b95@localhost>
	<AANLkTikYjaeXnhA3iP+kxjpA-NU4QQw-_YhRFf4U=30a@mail.gmail.com>
	<3DAC424F-1318-4E9D-B1E6-949ABE9E3CBB@wilsonet.com>
	<20110313032208.ab1b6488.jean.bruenn@ip-minds.de>
	<AANLkTikZ4KFSrzj6cJhbST9DWVcDqgQ6Y8R3we9614Bo@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> It means the i2c bus failed to get an ACK back when talking to the
> xc3028.  It could be a number of different things:
> 
> * broken cx23885 i2c master implementation
> * bug in the xc3028 driver
> * screwed up GPIOs causing the xc3028 to be held in reset
> * i2c bus wedged

Ah. Thanks. Now i know what to search for.

> > Also, nobody has any idea what i could try (except for what
> > i already did, including reverting patches and downgrading the kernel)?
> 
> If you're knowledgeable enough to downgrade the kernel, then your best
> bet is to learn how to use git bisect so you can identify exactly
> which patch introduced the regression.

Yup, started to try that yesterday, however, going back from today to
2008 will take some time. I'll let you know if i made any progress.

Thanks so far.
