Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:51165 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbbETItg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 04:49:36 -0400
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [RFC PATCH 4/6] [media] rc: lirc is not a protocol or a keymap
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Wed, 20 May 2015 10:49:34 +0200
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org
In-Reply-To: <20150520051923.7cefe112@recife.lan>
References: <cover.1426801061.git.sean@mess.org>
 <2a2f4281ba60988242c11bdf2fda3243e2dc4467.1426801061.git.sean@mess.org>
 <20150514135123.4ba85dc7@recife.lan> <20150519203442.GB18036@hardeman.nu>
 <20150520051923.7cefe112@recife.lan>
Message-ID: <5b14c3fee1ee0a553db5dac7b01fbf0a@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2015-05-20 10:19, Mauro Carvalho Chehab wrote:
> Em Tue, 19 May 2015 22:34:42 +0200
> David Härdeman <david@hardeman.nu> escreveu:
> 
>> On Thu, May 14, 2015 at 01:51:23PM -0300, Mauro Carvalho Chehab wrote:
>> >Em Thu, 19 Mar 2015 21:50:15 +0000
>> >Sean Young <sean@mess.org> escreveu:
>> >
>> >> Since the lirc bridge is not a decoder we can remove its protocol. The
>> >> keymap existed only to select the protocol.
>> >
>> >This changes the userspace interface, as now it is possible to enable/disable
>> >LIRC handling from a given IR via /proc interface.
> 
> I guess I meant to say: "as now it is not possible"
> 
>> I still like the general idea though.
> 
> Yeah, LIRC is not actually a decoder, so it makes sense to have it
> handled differently.
> 
>> If we expose the protocol in the
>> set/get keymap ioctls, then we need to expose the protocol enum to
>> userspace (in which point it will be set in stone)...removing lirc 
>> from
>> that list before we do that is a worthwhile cleanup IMHO (I have a
>> similar patch in my queue).
>> 
>> I think we should be able to at least not break userspace by still
>> accepting (and ignoring) commands to enable/disable lirc.
> 
> Well, ignoring is not a good idea, as it still breaks userspace, but
> on a more evil way. If one is using this feature, we'll be receiving
> bug reports and fixes for it.

I disagree it's more "evil" (or at least I fail to see how it would be). 
Accepting but ignoring "lirc" means that the same commands as before 
will still be accepted (so pre-existing userspace scripts won't have to 
change which they would if we made "lirc" an invalid protocol to echo to 
the sysfs file).

And saying that the change will "break" userspace is still something of 
a misnomer. You'd basically expect userspace to open /sys/blabla, write 
"-lirc" (which would disable the lirc output but the device node is 
still in /dev), then later open /dev/lircX and be surprised that it's 
still receiving lirc events on the lirc device it just opened? I think 
that's a rather artificial scenario...

>> That lirc won't actually be disabled/enabled is (imho) a lesser
>> problem...is there any genuine use case for disabling lirc on a
>> per-device basis?
> 
> People do weird things sometimes. I won't doubt that someone would
> be doing that.
> 
> In any case, keep supporting disabling LIRC is likely
> simple, even if we don't map it internally as a protocol anymore.

I could write a different patch that removes the protocol enum but still 
allows lirc to be disabled/enabled. I doubt it'll be that simple though 
(ugly hack rather), and I still don't see the benefits of doing so (or 
downsides or "breakage" of not doing it).

Another option would be to commit the change a see if anyone screams (I 
very much doubt it).


