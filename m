Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54142 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434Ab2JCVlS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2012 17:41:18 -0400
Date: Wed, 3 Oct 2012 22:45:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay@vrfy.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Ming Lei <ming.lei@canonical.com>,
	Lennart Poettering <lennart@poettering.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kay Sievers <kay@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Ivan Kalvachev <ikalvachev@gmail.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use
 request_firmware_nowait()
Message-ID: <20121003224554.23fca4af@pyramind.ukuu.org.uk>
In-Reply-To: <CAPXgP13h+7+WoZ2jVjroLWU495wDPwzbhefX8ziuQMznKBWyLQ@mail.gmail.com>
References: <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
	<20121002221239.GA30990@kroah.com>
	<20121002222333.GA32207@kroah.com>
	<CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
	<506C562E.5090909@redhat.com>
	<CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
	<20121003170907.GA23473@ZenIV.linux.org.uk>
	<CA+55aFw0pB99ztq5YUS56db-ijdxzevA=mvY3ce5O_yujVFOcA@mail.gmail.com>
	<20121003195059.GA13541@kroah.com>
	<CA+55aFwjyABgr-nmsDb-184nQF7KfA8+5kbuBNwyQBHs671qQg@mail.gmail.com>
	<20121003210532.GA10941@kroah.com>
	<CAPXgP13h+7+WoZ2jVjroLWU495wDPwzbhefX8ziuQMznKBWyLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 3 Oct 2012 23:18:06 +0200
Kay Sievers <kay@vrfy.org> wrote:

> On Wed, Oct 3, 2012 at 11:05 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > As for the firmware path, maybe we should
> > change that to be modified by userspace (much like /sbin/hotplug was) in
> > a proc file so that distros can override the location if they need to.
> 
> If that's needed, a CONFIG_FIRMWARE_PATH= with the array of locations
> would probably be sufficient.

The current system permits firmware to be served by a daemon, or even
assembled on the fly from parts. You break that for one.

Just fix udev, and if you can't fix it someone please just fork the last
working one.

Alan
