Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777Ab3C2NGZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Mar 2013 09:06:25 -0400
Date: Fri, 29 Mar 2013 10:05:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
	"Dirk E. Wagner" <linux@wagner-budenheim.de>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [patch 02/03 v2] usb hid quirks for Masterkit MA901 usb radio
Message-ID: <20130329100534.75f72b2b@redhat.com>
In-Reply-To: <CALW4P+L53ea5eqktdOkNms3ZmBzmg9dX3NJJEx89Yog_4UqLMg@mail.gmail.com>
References: <20121228102928.4103390e@redhat.com>
	<CALW4P+KzhmzAeQUQDRxEyfiHNSkCeua81p=xzukp0k3tF7JEEg@mail.gmail.com>
	<63b74db2773903666ea02810e1e6c047@mail.mx6-sysproserver.de>
	<CALW4P+LtcO_=c9a30xgFvQ+61r8=BxNifsn6x_8bbtceNkJ-jA@mail.gmail.com>
	<alpine.LNX.2.00.1303181449140.9529@pobox.suse.cz>
	<CALW4P+L1QKe=1wNkr90LsZY89OFnGBKB2N6yVeDhnyab_rSsnA@mail.gmail.com>
	<alpine.LNX.2.00.1303271117570.23442@pobox.suse.cz>
	<CALW4P+L53ea5eqktdOkNms3ZmBzmg9dX3NJJEx89Yog_4UqLMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 28 Mar 2013 00:33:29 +0400
Alexey Klimov <klimov.linux@gmail.com> escreveu:

> On Wed, Mar 27, 2013 at 2:18 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> > On Tue, 19 Mar 2013, Alexey Klimov wrote:
> >
> >> Yes, i just checked how hid_ignore() works and prepared dirty fix to
> >> test in almost the same way like it's done for Keene usb driver. I
> >> will send correct fix in next few days.
> >
> > Any news on this, please?
> 
> Hi Jiri,
> 
> I'm very very sorry (was busy because of life). I just sent two
> patches to you, Mauro and two mail lists:
> [patch 1/2] hid: fix Masterkit MA901 hid quirks
> [patch 2/2] media: radio-ma901: return ENODEV in probe if usb_device
> doesn't match
> 
> Please check. First one for hid layer, so maybe you can take it
> directly through your tree. I hope it's not too late.
> I think Mauro will take second patch.

It is better to add both patches via the same tree. As it is badly 
affecting HID, it seems better if Jiri can apply both patches. 

Also, there's no other patch for radio-ma901 on my tree. So, 
I don't expect any conflicts if those patches got merged via hid tree.

Jiri, could you please apply both patches on your tree?

For both:
> [patch 1/2] hid: fix Masterkit MA901 hid quirks
> [patch 2/2] media: radio-ma901: return ENODEV in probe if usb_device

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Regards,
Mauro
