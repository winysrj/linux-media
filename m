Return-path: <mchehab@pedra>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58892 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab0IHHln (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 03:41:43 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 0/6] Large scancode handling
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	David Hardeman <david@hardeman.nu>,
	Jiri Kosina <jkosina@suse.cz>, Ville Syrjala <syrjala@sci.fi>
Date: Wed, 08 Sep 2010 00:41:38 -0700
Message-ID: <20100908073233.32365.74621.stgit@hammer.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Mauro,

I guess I better get off my behind and commit the changes to support large
scancodes, or they will not make to 2.6.37 either... There isn't much
changes, except I followed David's suggestion and changed boolean index
field into u8 flags field. Still, please glance it over once again and
shout if you see something you do not like.

Jiri, how do you want to handle the changes to HID? I could either push
them through my tree together with the first patch or you can push through
yours once the first change hits mainline.

Mauro, the same question goes for media/IR patch.

David, I suppose you still have the winbond remote so you could test
changes to winbond-cir driver.

Ville, do you still have the hardware to try our ati_remote2 changes?

Thanks!

-- 
Dmitry
