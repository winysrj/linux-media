Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:53588 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123Ab2HPNVY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 09:21:24 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [media] mantis: merge both vp2033 and vp2040 drivers
References: <1344279745-13024-1-git-send-email-mchehab@redhat.com>
	<CAHFNz9Jz5x8i7-ip9BOdwC06tYR1SETctvvTpA4V=mbezhRoAw@mail.gmail.com>
	<5020271B.1020702@redhat.com>
	<CAHFNz9+mcnq5oWJLieN6P9e_gfS5BJZTVZDTGwhZR-dCtVJgcg@mail.gmail.com>
Date: Thu, 16 Aug 2012 15:21:00 +0200
In-Reply-To: <CAHFNz9+mcnq5oWJLieN6P9e_gfS5BJZTVZDTGwhZR-dCtVJgcg@mail.gmail.com>
	(Manu Abraham's message of "Tue, 7 Aug 2012 01:57:20 +0530")
Message-ID: <87a9xvotvn.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu Abraham <abraham.manu@gmail.com> writes:

> That's just peanuts you are talking about. The memory usage appears only
> if you are using the module. 200 lines of .text is nothing.

OK.  Deleting 200 completely useless lines of code is nothing?  I don't
think we live in the same world.

> That exists to
> differentiate between the 2 devices, not to make both hardware look the same.

Right.  And every single USB hard drive out there should have it's own
duplicated usb-storage driver?  I don't think so...

I am sure you are right that the cards are different.  It just doesn't
matter as long as the drivers are identical.

Thank you Mauro for doing this long awaited cleanup.  Getting rid of all
the duplicated and unused code in this driver will make it easier for
others to get involved in fixing the real bugs.


Bjørn
