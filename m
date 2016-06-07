Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:48802 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161418AbcFGPVq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2016 11:21:46 -0400
Date: Tue, 7 Jun 2016 12:21:40 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Abylay Ospan <aospan@netup.ru>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL] NetUP Universal DVB (revision 1.4)
Message-ID: <20160607122140.25a5c1c0@recife.lan>
In-Reply-To: <CAK3bHNUPOORumndTHSQyLa0OAnE1Ob4SLR=CoLZMbi5C-P4e4w@mail.gmail.com>
References: <CAK3bHNUPOORumndTHSQyLa0OAnE1Ob4SLR=CoLZMbi5C-P4e4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 16 May 2016 11:58:15 -0400
Abylay Ospan <aospan@netup.ru> escreveu:

> Hi Mauro,
> 
> Please pull code from my repository (details below). Repository is
> based on linux-next. If it's better to send patch-by-patch basis
> please let me know - i will prepare emails.
> 
> This patches adding support for our NetUP Universal DVB card revision
> 1.4 (ISDB-T added to this revision). This achieved by using new Sony
> tuner HELENE (CXD2858ER) and new Sony demodulator ARTEMIS (CXD2854ER).
> And other fixes for our cards in this repository too.

Patches applied.

Please send a patch adding an entry for the new HELENE tuner driver at
MAINTAINERS.

Regards,
Mauro
