Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55010 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab0GaO7f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 10:59:35 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: [PATCH 0/9 v4] IR: few fixes, additions and ENE driver
Date: Sat, 31 Jul 2010 17:59:13 +0300
Message-Id: <1280588366-26101-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,

4th revision of my patches below:

Changes:

* more carefull repeat support in NECX protocol
* added documentation for wide band mode ioctl
* fix for 64 bit divide
* updated summary of patches, and preserved few
* Acked/Reviewed by tags you gave me.

Best regards,
	Maxim Levitsky

