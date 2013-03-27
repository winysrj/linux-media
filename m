Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f174.google.com ([209.85.128.174]:56257 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab3C0Uda (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Mar 2013 16:33:30 -0400
Received: by mail-ve0-f174.google.com with SMTP id jz10so4532964veb.5
        for <linux-media@vger.kernel.org>; Wed, 27 Mar 2013 13:33:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1303271117570.23442@pobox.suse.cz>
References: <20121228102928.4103390e@redhat.com>
	<CALW4P+KzhmzAeQUQDRxEyfiHNSkCeua81p=xzukp0k3tF7JEEg@mail.gmail.com>
	<63b74db2773903666ea02810e1e6c047@mail.mx6-sysproserver.de>
	<CALW4P+LtcO_=c9a30xgFvQ+61r8=BxNifsn6x_8bbtceNkJ-jA@mail.gmail.com>
	<alpine.LNX.2.00.1303181449140.9529@pobox.suse.cz>
	<CALW4P+L1QKe=1wNkr90LsZY89OFnGBKB2N6yVeDhnyab_rSsnA@mail.gmail.com>
	<alpine.LNX.2.00.1303271117570.23442@pobox.suse.cz>
Date: Thu, 28 Mar 2013 00:33:29 +0400
Message-ID: <CALW4P+L53ea5eqktdOkNms3ZmBzmg9dX3NJJEx89Yog_4UqLMg@mail.gmail.com>
Subject: Re: Fw: [patch 02/03 v2] usb hid quirks for Masterkit MA901 usb radio
From: Alexey Klimov <klimov.linux@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"Dirk E. Wagner" <linux@wagner-budenheim.de>,
	Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 27, 2013 at 2:18 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Tue, 19 Mar 2013, Alexey Klimov wrote:
>
>> Yes, i just checked how hid_ignore() works and prepared dirty fix to
>> test in almost the same way like it's done for Keene usb driver. I
>> will send correct fix in next few days.
>
> Any news on this, please?

Hi Jiri,

I'm very very sorry (was busy because of life). I just sent two
patches to you, Mauro and two mail lists:
[patch 1/2] hid: fix Masterkit MA901 hid quirks
[patch 2/2] media: radio-ma901: return ENODEV in probe if usb_device
doesn't match

Please check. First one for hid layer, so maybe you can take it
directly through your tree. I hope it's not too late.
I think Mauro will take second patch.

I spend some time testing them trying to figure out right scenarios
and i hope i did correct checks.
It will be nice if someone can test patches because i don't have any
devices with same USB IDs as radio-ma901.

Thanks and best regards,
Alexey.
