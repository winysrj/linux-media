Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.comexp.ru ([78.110.60.213]:32988 "EHLO mail.comexp.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbaCaMmg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 08:42:36 -0400
Message-ID: <1396268976.15702.8.camel@localhost.localdomain>
Subject: Re: [PATCH] saa7134: automatic norm detection
From: Mikhail Domrachev <mihail.domrychev@comexp.ru>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?koi8-r?Q?=E1=CC=C5=CB=D3=C5=CA_?=
	 =?koi8-r?Q?=E9=C7=CF=CE=C9=CE?= <aleksey.igonin@comexp.ru>
Date: Mon, 31 Mar 2014 16:29:36 +0400
In-Reply-To: <53395144.2050100@xs4all.nl>
References: <1395661349.2916.3.camel@localhost.localdomain>
		<533534D7.6010301@xs4all.nl>
		<1396000280.3518.24.camel@localhost.localdomain>
		<53354925.6070603@xs4all.nl>
	 <CAGoCfiwN6Z9Whof-ZfWPxPfu+HztHTQewkXLicJkT7si_Jg9uw@mail.gmail.com>
	 <53395144.2050100@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Hans,

> I agree with Devin here. None of the existing SDTV receivers do this, and
> nobody ever used interrupts to check for this. Such interrupts are rarely
> available, and if they exists they are never hooked up. This is quite
> different for HDTV receivers where such an event is pretty much required
> (even though it still isn't officially added to the kernel, but that's
> another story).
OK, I got it.

> Is there any reason why your application cannot periodically call QUERYSTD?
There's no reason, it can.

> I'll test your patch today or Friday.
OK. Thank you.

-- 
Regards,
Mikhail Domrachev
Comexp

