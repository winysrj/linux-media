Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:63679 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab2HGSqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2012 14:46:30 -0400
Received: by qaas11 with SMTP id s11so45104qaa.19
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2012 11:46:30 -0700 (PDT)
MIME-Version: 1.0
From: Partha Guha Roy <partha.guha.roy@gmail.com>
Date: Wed, 8 Aug 2012 00:46:09 +0600
Message-ID: <CADTwmX_r8W=JOzZP9uUL1F8-HrsF-4vHsgFEd+73BkgGzH-oeQ@mail.gmail.com>
Subject: Philips saa7134 IR remote problem with linux kernel v2.6.35
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a saa7134 analog tv card (Avermedia PCI pure m135a) with an IR
remote. The IR remote is recognized by a standard keyboard and lirc
used to work fine with this. However, from kernel v2.6.35, the IR
remote does not work properly. The major problem is that every
keystroke is registered after the next keystroke. So, if I press the
sequence "123" on the remote, it actually comes up with only "12". If
I then if I wait for 5 seconds, the "3" gets lost.

Now I tried to bisect the kernel and it lead to the following commit:

commit e40b1127f994a427568319d1be9b9e5ab1f58dd1
Author: David Härdeman <david@hardeman.nu>
Date:   Thu Apr 15 18:46:00 2010 -0300

    V4L/DVB: ir-core: change duration to be coded as a u32 integer

    This patch implements the agreed upon 1:31 integer encoded pulse/duration
    struct for ir-core raw decoders. All decoders have been tested after the
    change. Comments are welcome.

    Signed-off-by: David Härdeman <david@hardeman.nu>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

I am willing to test patches if needed.

Thanks and regards.

/Partha Roy
