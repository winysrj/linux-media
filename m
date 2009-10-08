Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48724 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755435AbZJHIuw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Oct 2009 04:50:52 -0400
From: "Jan-Simon =?iso-8859-1?q?M=F6ller?=" <dl9pf@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: TM6010 driver and firmware
Date: Thu, 8 Oct 2009 10:50:02 +0200
Cc: =?iso-8859-1?q?D=EAnis_Goes?= <denishark@gmail.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <f326ee1a0910030539pd5e00e2xb9f6de9975b64b9b@mail.gmail.com> <f326ee1a0910030602w2518f66q2d6e185c473d5ad@mail.gmail.com> <20091005095343.6b9afa65@pedra.chehab.org>
In-Reply-To: <20091005095343.6b9afa65@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910081050.02215.dl9pf@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi !

Using the 3.7 firmware on HVR900H, I get up to this point:

http://pastebin.ca/1603643

[...]
Error during zl10353_attach!
tm6000: couldn't attach the frontend!
xc2028 4-0061: destroying instance
tm6000: Error -1 while registering
tm6000: probe of 1-5.1:1.0 failed with error -1
usbcore: registered new interface driver tm6000
Original value=255


Best,
Jan-Simon
