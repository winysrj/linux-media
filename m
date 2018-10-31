Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52292 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbeKAEJY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Nov 2018 00:09:24 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20181031161300.vzk6nsyyyvjukqxz@gofer.mess.org>
References: <20181031161300.vzk6nsyyyvjukqxz@gofer.mess.org> <12108.1540984768@warthog.procyon.org.uk> <20181031104912.s3tqjl3u43ou3kwo@gofer.mess.org> <20181030223249.dhwhxdjipzmjxzsy@gofer.mess.org> <153778383104.14867.1567557014782141706.stgit@warthog.procyon.org.uk> <20181030110319.764f33f0@coco.lan> <8474.1540982182@warthog.procyon.org.uk> <13768.1541001100@warthog.procyon.org.uk>
To: Sean Young <sean@mess.org>
Cc: dhowells@redhat.com,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Brad Love <brad@nextdimension.cc>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dvb: Allow MAC addresses to be mapped to stable device names with udev
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9073.1541013000.1@warthog.procyon.org.uk>
Date: Wed, 31 Oct 2018 19:10:00 +0000
Message-ID: <9074.1541013000@warthog.procyon.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sean Young <sean@mess.org> wrote:

> device_create() will register the device in sysfs and send uevent. So, your
> original udev rule/code will not work, since it always would read
> a mac address of 0, as proposed_mac is not populated when the device is
> announced. That is, unless udev is scheduled after the mac is read.

I guess that must be what is happening as it does seem to work for me.

> I think the device_add/device_create() which triggers the uevent should be
> delayed until everything is available.

Is it possible to switch vb2_dvb_register_bus() and dvb_register_ci_mac() in
dvb_register() in cx23885-dvb.c - or does that prevent the firmware from
loading?

And I'm guessing this change would have to be applied to all drivers?

David
