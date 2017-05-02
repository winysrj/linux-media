Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:33861 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751074AbdEBUs2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 2 May 2017 16:48:28 -0400
Date: Tue, 2 May 2017 21:48:26 +0100
From: Sean Young <sean@mess.org>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH 2/6] rc-core: cleanup rc_register_device
Message-ID: <20170502204826.GA30402@gofer.mess.org>
References: <149332488240.32431.6597996407440701793.stgit@zeus.hardeman.nu>
 <149332524306.32431.8964878481747905258.stgit@zeus.hardeman.nu>
 <20170501164953.GA14836@gofer.mess.org>
 <20170501174725.hkqw4tqbq5m4bthf@hardeman.nu>
 <20170502185302.pz2mgm4vvhtyxqig@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170502185302.pz2mgm4vvhtyxqig@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 02, 2017 at 08:53:02PM +0200, David Härdeman wrote:
> On Mon, May 01, 2017 at 07:47:25PM +0200, David Härdeman wrote:
> >On Mon, May 01, 2017 at 05:49:53PM +0100, Sean Young wrote:
> >>On Thu, Apr 27, 2017 at 10:34:03PM +0200, David Härdeman wrote:
> >>> The device core infrastructure is based on the presumption that
> >>> once a driver calls device_add(), it must be ready to accept
> >>> userspace interaction.
> >>> 
> >>> This requires splitting rc_setup_rx_device() into two functions
> >>> and reorganizing rc_register_device() so that as much work
> >>> as possible is performed before calling device_add().
> >>> 
> >>
> >>With this patch applied, I'm no longer getting any scancodes from
> >>my rc devices.
> >>
> >>David, please can you test your patches before submitting. I have to go
> >>over them meticulously because I cannot assume you've tested them.
> >
> >I did test this patch and I just redid the tests, both with rc-loopback
> >and with a mceusb receiver. I'm seeing scancodes on the input device as
> >well as pulse-space readings on the lirc device in both tests.
> >
> >I did the tests with only this patch applied and the lirc-use-after-free
> >(v3). What hardware did you test with?
> >
> >Meanwhile, I'll try rebasing my patches to the latest version of the
> >media-master git tree and test again.
> 
> I rebased the patches onto media-master (commit
> 3622d3e77ecef090b5111e3c5423313f11711dfa) and tested again. I still
> can't reproduce the problems you're having :/

The protocol is not set properly. In rc_prepare_rx_device(), 
dev->change_protocol() is call if not null. At this point it still is
null, since it will only be set up in ir_raw_event_prepare(), which
is called afterwards.

Presumably you have udev set up to execute ir-keytable, which sets the
protocol up (again).

There is another problem with your patches, you've introduced a race
condition. When device_add() is called, the protocol is not set up yet.
So anyone reading the protocols sysfs attribute early enough will get
false information. Is it not possible to make sure that it is all setup
correctly at the point of device_add()?


Sean
