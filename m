Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:52548 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752051AbdECJt2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 May 2017 05:49:28 -0400
Date: Wed, 3 May 2017 11:49:26 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH 2/6] rc-core: cleanup rc_register_device
Message-ID: <20170503094926.owrsztogjxcivmvj@hardeman.nu>
References: <149332488240.32431.6597996407440701793.stgit@zeus.hardeman.nu>
 <149332524306.32431.8964878481747905258.stgit@zeus.hardeman.nu>
 <20170501164953.GA14836@gofer.mess.org>
 <20170501174725.hkqw4tqbq5m4bthf@hardeman.nu>
 <20170502185302.pz2mgm4vvhtyxqig@hardeman.nu>
 <20170502204826.GA30402@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170502204826.GA30402@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 02, 2017 at 09:48:26PM +0100, Sean Young wrote:
>On Tue, May 02, 2017 at 08:53:02PM +0200, David Härdeman wrote:
>> On Mon, May 01, 2017 at 07:47:25PM +0200, David Härdeman wrote:
>> >On Mon, May 01, 2017 at 05:49:53PM +0100, Sean Young wrote:
>> >>On Thu, Apr 27, 2017 at 10:34:03PM +0200, David Härdeman wrote:
>> >>> The device core infrastructure is based on the presumption that
>> >>> once a driver calls device_add(), it must be ready to accept
>> >>> userspace interaction.
>> >>> 
>> >>> This requires splitting rc_setup_rx_device() into two functions
>> >>> and reorganizing rc_register_device() so that as much work
>> >>> as possible is performed before calling device_add().
>> >>> 
>> >>
>> >>With this patch applied, I'm no longer getting any scancodes from
>> >>my rc devices.
>> >>
>> >>David, please can you test your patches before submitting. I have to go
>> >>over them meticulously because I cannot assume you've tested them.
>> >
>> >I did test this patch and I just redid the tests, both with rc-loopback
>> >and with a mceusb receiver. I'm seeing scancodes on the input device as
>> >well as pulse-space readings on the lirc device in both tests.
>> >
>> >I did the tests with only this patch applied and the lirc-use-after-free
>> >(v3). What hardware did you test with?
>> >
>> >Meanwhile, I'll try rebasing my patches to the latest version of the
>> >media-master git tree and test again.
>> 
>> I rebased the patches onto media-master (commit
>> 3622d3e77ecef090b5111e3c5423313f11711dfa) and tested again. I still
>> can't reproduce the problems you're having :/
>
>The protocol is not set properly. In rc_prepare_rx_device(), 
>dev->change_protocol() is call if not null. At this point it still is
>null, since it will only be set up in ir_raw_event_prepare(), which
>is called afterwards.

Ah, good catch. Since ir_raw_event_prepare() only does a kmalloc() and
sets the change_protocol pointer it should be fine to call
ir_raw_event_prepare() before rc_prepare_rx_device(). I'll prepare a v2
of the patch.

>Presumably you have udev set up to execute ir-keytable, which sets the
>protocol up (again).

Well, kind of. In the automated testing I use rc-loopback which has the
"rc-empty" keytable so it doesn't set the protocols. In my manual
testing I used mceusb with a NEC remote so I anyway needed to set the
protocols manually and I missed the fact that "[rc-6]" was no longer set
in sysfs.

>There is another problem with your patches, you've introduced a race
>condition. When device_add() is called, the protocol is not set up yet.
>So anyone reading the protocols sysfs attribute early enough will get
>false information. Is it not possible to make sure that it is all setup
>correctly at the point of device_add()?

Isn't this the same problem? If dev->change_protocol() isn't NULL when
rc_prepare_rx_device() is called then the protocol will be set up (i.e.
dev->enabled_protcols will be set to the right value). Or did I
misunderstand you?

-- 
David Härdeman
