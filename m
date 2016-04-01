Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:58629 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbcDAEAN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Apr 2016 00:00:13 -0400
Received: from django19.localnet ([94.216.225.229]) by mail.gmx.com (mrgmx102)
 with ESMTPSA (Nemesis) id 0MQu9K-1aIbKe2IsY-00UNhR for
 <linux-media@vger.kernel.org>; Fri, 01 Apr 2016 06:00:10 +0200
From: I don't like Spam <unknown@public-files.de>
To: linux-media@vger.kernel.org
Subject: conflict DD-cine C/T V7 with older dvb-cards
Date: Fri, 01 Apr 2016 06:00:09 +0200
Message-ID: <1740048.QukWnjDs6D@django19>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I recently bought a cine C/T V7 DVB-card from digital devices and I realized 
some strange behaviour.
The older dvb-cards are KNC or Mystique dvb-C cards that work fine for years.

When I compile the driver from digital devices, the cine C/T works fine, but 
the older cards stop with errors.

I did a quick search and diff and found out, that digital devices provides a 
dvb_core aparently incompatible with the dvb_core from kernel.
I don't have any idea of kernel or driver hacking. 
Is anybody out there, who can help with that drama?


best regards

Reinhard 

