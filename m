Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:46764 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976Ab0GEM3u (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Jul 2010 08:29:50 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1OVknv-0000Nz-UF
	for linux-media@vger.kernel.org; Mon, 05 Jul 2010 14:29:44 +0200
Received: from 193.160.199.2 ([193.160.199.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 05 Jul 2010 14:29:43 +0200
Received: from bjorn by 193.160.199.2 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 05 Jul 2010 14:29:43 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: V4L2 radio drivers for TI-WL7
Date: Mon, 05 Jul 2010 14:29:30 +0200
Message-ID: <87sk3yp0wl.fsf@nemi.mork.no>
References: <31718.25391.qm@web94912.mail.in2.yahoo.com>
	<201007050821.53313.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> On Friday 02 July 2010 09:01:34 Pavan Savoy wrote:
>> Hi,
>> 
>> We have/in process of developing a V4L2 driver for the FM Radio on the Texas Instruments WiLink 7 module.
>> 
>> For transport/communication with the chip, we intend to use the shared transport driver currently staged in mainline at drivers/staging/ti-st/.
>> 
>> To which tree should I generate patches against? is the tree
>> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
>> fine ? to be used with the v4l_for_2.6.35 branch ?
>
> You patch against git://git.linuxtv.org/v4l-dvb.git.

Could the MAINTAINERS entry be updated to refelct this?  It currently
has

MEDIA INPUT INFRASTRUCTURE (V4L/DVB)
M:      Mauro Carvalho Chehab <mchehab@infradead.org>
P:      LinuxTV.org Project
L:      linux-media@vger.kernel.org
W:      http://linuxtv.org
Q:      http://patchwork.kernel.org/project/linux-media/list/
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
S:      Maintained
F:      Documentation/dvb/
F:      Documentation/video4linux/
F:      drivers/media/
F:      include/media/
F:      include/linux/dvb/
F:      include/linux/videodev*.h



Misleading documentation is even worse than no documentation....




Bjørn

