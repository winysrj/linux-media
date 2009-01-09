Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47648 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbZAILUp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Jan 2009 06:20:45 -0500
Date: Fri, 9 Jan 2009 09:20:18 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Jean Delvare <khali@linux-fr.org>,
	V4L and DVB maintainers <v4l-dvb-maintainer@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: zr36067 no longer loads automatically (regression)
Message-ID: <20090109092018.59a6d9eb@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.58.0901082156270.1626@shell2.speakeasy.net>
References: <20090108143315.2b564dfe@hyperion.delvare>
	<20090108175627.0ebd9f36@pedra.chehab.org>
	<Pine.LNX.4.58.0901081319340.1626@shell2.speakeasy.net>
	<20090108193923.580fcd5b@pedra.chehab.org>
	<Pine.LNX.4.58.0901082156270.1626@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Thu, 8 Jan 2009 22:01:08 -0800 (PST)
Trent Piepho <xyzzy@speakeasy.org> wrote:

> On Thu, 8 Jan 2009, Mauro Carvalho Chehab wrote:
> > On Thu, 8 Jan 2009 13:20:19 -0800 (PST)
> > Trent Piepho <xyzzy@speakeasy.org> wrote:
> > > On Thu, 8 Jan 2009, Mauro Carvalho Chehab wrote:
> > > It doesn't seem like any other driver needs to protect the module device
> > > table with an ifdef.
> >
> > However, Zoran driver doesn't rely on pci_register_driver(). Instead, it uses a
> > while() loop to probe for Zoran devices:
> >
> > static int __devinit
> > find_zr36057 (void)
> > {
> > 	...
> >
> >         zoran_num = 0;
> >         while (zoran_num < BUZ_MAX &&
> >                (dev = pci_get_device(PCI_VENDOR_ID_ZORAN, PCI_DEVICE_ID_ZORAN_36057, dev)) != NULL) {
> > 	...
> > }
> 
> Yuck, why don't we fix this instead?

This will be much better.

> Here's an initial test.  I haven't yet found my dc10+ to test it with.

Unfortunately, I don't have any Zoran card here to test.

Jean, it is up to you to test Trent's patch.

-- 

Cheers,
Mauro
