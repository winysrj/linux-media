Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:51305 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453AbbETJGH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 05:06:07 -0400
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [RFC PATCH 4/6] [media] rc: lirc is not a protocol or a keymap
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Wed, 20 May 2015 11:06:06 +0200
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org
In-Reply-To: <20150520060133.5b2846ae@recife.lan>
References: <cover.1426801061.git.sean@mess.org>
 <2a2f4281ba60988242c11bdf2fda3243e2dc4467.1426801061.git.sean@mess.org>
 <20150514135123.4ba85dc7@recife.lan> <20150519203442.GB18036@hardeman.nu>
 <20150520051923.7cefe112@recife.lan>
 <5b14c3fee1ee0a553db5dac7b01fbf0a@hardeman.nu>
 <20150520060133.5b2846ae@recife.lan>
Message-ID: <f7f9baed90d28f68a4284da0f9b127ad@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2015-05-20 11:01, Mauro Carvalho Chehab wrote:
> Em Wed, 20 May 2015 10:49:34 +0200
> David Härdeman <david@hardeman.nu> escreveu:
> 
>> On 2015-05-20 10:19, Mauro Carvalho Chehab wrote:
>> > Em Tue, 19 May 2015 22:34:42 +0200
>> > David Härdeman <david@hardeman.nu> escreveu:
>> >> I think we should be able to at least not break userspace by still
>> >> accepting (and ignoring) commands to enable/disable lirc.
>> >
>> > Well, ignoring is not a good idea, as it still breaks userspace, but
>> > on a more evil way. If one is using this feature, we'll be receiving
>> > bug reports and fixes for it.
>> 
>> I disagree it's more "evil" (or at least I fail to see how it would 
>> be).
> 
> Because the Kernel would be lying to userspace. If one tells the Kernel 
> to
> disable something, it should do it, or otherwise return an error 
> explaining
> why disabling was not possible.

Would really you be happier with a patch so that writing "-lirc" to the 
sysfs file returns an error?


