Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38643 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab0G1XlE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 19:41:04 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: 
Date: Thu, 29 Jul 2010 02:40:43 +0300
Message-Id: <1280360452-8852-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Subject: [PATCH 0/9 v2] IR: few fixes, additions and ENE driver

Hi,
This is second version of the patchset.
Hopefully, I didn't forget to address all comments.

In addition to comments, I changed helper function that processes samples
so it sends last space as soon as timeout is reached.
This breaks somewhat lirc, because now it gets 2 spaces in row.
However, if it uses timeout reports (which are now fully supported)
it will get such report in middle.

Note that I send timeout report with zero value.
I don't think that this value is importaint.


