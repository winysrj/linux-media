Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54424 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105Ab3CSIiT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 04:38:19 -0400
Date: Tue, 19 Mar 2013 09:38:15 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"Dirk E. Wagner" <linux@wagner-budenheim.de>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: Fw: [patch 02/03 v2] usb hid quirks for Masterkit MA901 usb
 radio
In-Reply-To: <CALW4P+L1QKe=1wNkr90LsZY89OFnGBKB2N6yVeDhnyab_rSsnA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1303190937420.9529@pobox.suse.cz>
References: <20121228102928.4103390e@redhat.com> <CALW4P+KzhmzAeQUQDRxEyfiHNSkCeua81p=xzukp0k3tF7JEEg@mail.gmail.com> <63b74db2773903666ea02810e1e6c047@mail.mx6-sysproserver.de> <CALW4P+LtcO_=c9a30xgFvQ+61r8=BxNifsn6x_8bbtceNkJ-jA@mail.gmail.com>
 <alpine.LNX.2.00.1303181449140.9529@pobox.suse.cz> <CALW4P+L1QKe=1wNkr90LsZY89OFnGBKB2N6yVeDhnyab_rSsnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 19 Mar 2013, Alexey Klimov wrote:

> > Or Mauro, as the original patch went in through your tree, are you
> > handling that?
> 
> I think we really need to revert it before final release. It's already -rc3.

If Mauro is currently too busy to handle this, I will take it. Please send 
it to me together with the appropriate hid_ignore() patch.

Thanks,

-- 
Jiri Kosina
SUSE Labs
