Return-path: <linux-media-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:49533 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab0CDStV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Mar 2010 13:49:21 -0500
Subject: dvb-fe-cx24116.fw firmware versions for Ubuntu releases
From: Chase Douglas <chase.douglas@ubuntu.com>
To: linux-media@vger.kernel.org
Cc: mythtv-list@dinkum.org.uk
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Mar 2010 13:49:15 -0500
Message-ID: <1267728555.6224.22.camel@cndougla-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

Ubuntu has shipped corrupted dvb-fe-cx24116.fw firmware for a few
releases now. I'm working on rectifying the situation. Working with
Andre Newman on the mythtv-users mailing list, we have found the
following firmware versions to work:

(Note: 1.23.86.1 wasn't tested in any release, it may or may not work)

Jaunty: up to 1.22.82
Karmic: up to 1.22.82
Lucid: up to 1.26.90

These are the firmware versions I am looking to package, but I only have
one user's anecdotal evidence to back them up. I am interested in any
feedback others may have in determining what versions of the firmware
should be shipped in each release.

Thanks,
Chase Douglas

