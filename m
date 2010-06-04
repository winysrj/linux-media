Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab0FDELs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jun 2010 00:11:48 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o544Bmbv028957
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 4 Jun 2010 00:11:48 -0400
Message-ID: <4C087D03.3090801@redhat.com>
Date: Fri, 04 Jun 2010 01:11:47 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] IR: add mceusb IR receiver driver
References: <20100601203208.GA28165@redhat.com> <4C0745DE.20306@redhat.com> <20100603221032.GD23375@redhat.com>
In-Reply-To: <20100603221032.GD23375@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-06-2010 19:10, Jarod Wilson escreveu:
> On Thu, Jun 03, 2010 at 03:04:14AM -0300, Mauro Carvalho Chehab wrote:
>> Em 01-06-2010 17:32, Jarod Wilson escreveu:
>>> This is a new driver for the Windows Media Center Edition/eHome
>>> Infrared Remote transceiver devices. Its a port of the current
>>> lirc_mceusb driver to ir-core, and currently lacks transmit support,
>>> but will grow it back soon enough... This driver also differs from
>>> lirc_mceusb in that it borrows heavily from a simplified IR buffer
>>> decode routine found in Jon Smirl's earlier ir-mceusb port.
>>>
>>> This driver has been tested on the original first-generation MCE IR
>>> device with the MS vendor ID, as well as a current-generation device
>>> with a Topseed vendor ID. Every receiver supported by lirc_mceusb
>>> should work equally well. Testing was done primarily with RC6 MCE
>>> remotes, but also briefly with a Hauppauge RC5 remote, and all works
>>> as expected.
>>>
>>> v2: fix call to ir_raw_event_handle so repeats work as they should.
>>
>> The driver seems ok, except for a few "magic" numbers.
>>
>> I'll apply at the tree, to allow more people to test. Please send me later
>> a patch fixing those small issues.
> 
> I'll get something in flight tonight or tomorrow. All those uglies are in
> the 1st-gen init code, which needs some further work anyway to kill off a
> warning about the driver mapping memory from stack. I've got a number of
> other 1st-gen tx and debug output fixes queued up as well.

Ok, great.

Cheers,
Mauro.

