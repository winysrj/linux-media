Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gn.apc.org ([217.72.179.5]:41663 "EHLO mail.gn.apc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab0G1NHR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 09:07:17 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.gn.apc.org (Postfix) with ESMTP id 5E9497F119B
	for <linux-media@vger.kernel.org>; Wed, 28 Jul 2010 13:57:21 +0100 (BST)
Received: from mail.gn.apc.org ([127.0.0.1])
	by localhost (mail.gn.apc.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SLbm+8EWAc+2 for <linux-media@vger.kernel.org>;
	Wed, 28 Jul 2010 13:57:20 +0100 (BST)
Received: from mimo-desktop.localnet (static-195-248-116-49.adsl.hotchilli.net [195.248.116.49])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.gn.apc.org (Postfix) with ESMTPS id 118D67F0D56
	for <linux-media@vger.kernel.org>; Wed, 28 Jul 2010 13:57:19 +0100 (BST)
From: Michael Moritz <mimo@gn.apc.org>
To: linux-media@vger.kernel.org
Subject: AverMedia Volar Black HD (A850) - crashes in mythtv, does not find HD
Date: Wed, 28 Jul 2010 13:57:39 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007281357.40321.mimo@gn.apc.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi I've read through the earlier thread about the driver for this here: http://www.mail-archive.com/linux-media@vger.kernel.org/msg03661.html

First I've used the default Ubuntu Lucid kernel driver (2.6.32) - kaffeine, scan etc work, mythtv scanning finds channels, times out, and channels get added as not visible. LiveTV crashes mythtv - see my report here: http://mythtv.org/pipermail/mythtv-users/2010-July/293751.html

I also used hg clone to check out the current v4l tree (on Saturday 24/07/2010) - same

Then I tried the latest version I could find http://linuxtv.org/hg/~anttip (last change 5 weeks ago) but still no joy (exactly the same problems).

Another issue - as far as I understood the earlier discussion - Antti mentioned that the card reports two tuners. I've noticed that I can not tune any HD channels (though I think I should be in reach). Maybe the second tuner is the HDTV tuner?

Any help appreciated. Mythtv recording is working fine btw once I manually manipulate the channels table. It seems like mythtv after the scan tries to tune to each channel in turn and get some info from it and that's what times out at that stage. The crash  that happens with LiveTV is documented on the mythtv-users list (see above) - I also posted it to mythtv-devel but strangely they didn't want it 

Thanks for writing the driver in the first place! 


mimo
