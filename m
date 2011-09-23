Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40533 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab1IWUWt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 16:22:49 -0400
Received: by fxe4 with SMTP id 4so4168851fxe.19
        for <linux-media@vger.kernel.org>; Fri, 23 Sep 2011 13:22:48 -0700 (PDT)
Date: Fri, 23 Sep 2011 22:22:32 +0200
From: Steffen Barszus <steffenbpunkt@googlemail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Oliver Freyermuth <o.freyermuth@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Doychin Dokov <root@net1.cc>,
	"Igor M. Liplianin" <liplianin@me.by>,
	Dominik Kuhlen <dkuhlen@gmx.net>,
	Andre Weidemann <Andre.Weidemann@web.de>,
	"Michael H. Schimek" <mschimek@gmx.at>
Subject: Re: [PATCH] Add support for PCTV452E.
Message-ID: <20110923222232.75986e18@grobi>
In-Reply-To: <4E7CE5F8.1050900@redhat.com>
References: <201105242151.22826.hselasky@c2i.net>
	<20110723132437.7b8add2c@grobi>
	<j43erv$8ft$1@dough.gmane.org>
	<4E7CE5F8.1050900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 23 Sep 2011 17:03:04 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> Em 05-09-2011 18:27, Oliver Freyermuth escreveu:
> > Got it working with kernel 3.0!
> > 
> > For me, some more changes on the current patchset appeared to be
> > necessary. In short, I had to change all a->fe to a->fe[0] (because
> > of 3.0-kernel) and I had to add lnbp22 to Kconfig (it would
> > otherwise have been disabled and not been built, although other
> > modules depended on it...).
> > 
> > I also had to add the additional
> > "EXPORT_SYMBOL(ttpci_eeprom_decode_mac);" as mentioned by Doychin
> > Dokov.
> > 
> > Attached is the 'new' version of the patch with the mentioned
> > changes.
> 
> For it to be applied, we need the SOB's of the patch authors:
> 
> +MODULE_AUTHOR("Dominik Kuhlen <dkuhlen@gmx.net>");
> +MODULE_AUTHOR("Andre Weidemann <Andre.Weidemann@web.de>");
> +MODULE_AUTHOR("Michael H. Schimek <mschimek@gmx.at>");

I tried to ping Dominik Kuhlen at least a couple of times - without a
reply. Is this a must or nice to have ? Is there a workaround or is
this driver at dead end then ? I can only confirm that the driver is
working with the mentioned changes. 
