Return-path: <linux-media-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.190]:11279 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813AbZCSOSu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 10:18:50 -0400
Received: by mu-out-0910.google.com with SMTP id g7so194556muf.1
        for <linux-media@vger.kernel.org>; Thu, 19 Mar 2009 07:18:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090319110303.7a53f9bb@pedra.chehab.org>
References: <1237467800.19717.37.camel@tux.localhost>
	 <20090319110303.7a53f9bb@pedra.chehab.org>
Date: Thu, 19 Mar 2009 17:18:47 +0300
Message-ID: <208cbae30903190718l10911cc1j2a6f4f21b7f2b107@mail.gmail.com>
Subject: Re: [patch review] radio/Kconfig: introduce 3 groups: isa, pci, and
	others drivers
From: Alexey Klimov <klimov.linux@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 19, 2009 at 5:03 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> On Thu, 19 Mar 2009 16:03:20 +0300
> Alexey Klimov <klimov.linux@gmail.com> wrote:
>
>> Hello, all
>> What do you think about such patch that makes selecting of radio drivers
>> in menuconfig more comfortable ?
>
> Frankly, I don't see any gain: If the user doesn't have ISA (or doesn't want to
> have), it should have already unselected the ISA sub-menu. The remaining PCI
> and USB drivers are few. So, creating menus for them seem overkill.
>
> We could eventually reorganize the item order, and adding a few comments to
> indicate the drivers that are ISA, PCI, PCIe and USB (something similar to what
> was done at DVB frontend part of the menu), but still, I can't see much value.

Okay, well, sorry for bothering.
Only one point here - if user want to unselect radio drivers in
menuconfig, for example - pci and isa in some bad config file he
should pick a lot of times, and with this patch only 2 times.
But, okay.

-- 
Best regards, Klimov Alexey
