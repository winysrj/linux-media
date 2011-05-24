Return-path: <mchehab@pedra>
Received: from luna.schedom-europe.net ([193.109.184.86]:37479 "EHLO
	luna.schedom-europe.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab1EXQTj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 12:19:39 -0400
Date: Tue, 24 May 2011 18:18:17 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: <abraham.manu@gmail.com>
Cc: <linux-media@vger.kernel.org>
Subject: STV6110 FE_READ_STATUS implementation
Message-ID: <20110524181817.34097929@borg.bxl.tuxicoman.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hi Manu,

I'm currently writing an application that needs to know the detailed
frontend status when there is no lock.
As far as I can see from the sources, the code will only set the right
status when there is a lock in stv6110x_get_status().

Does the STV6110 supports reporting of signal, carrier, viterbi and
sync ?

I'd be happy to implement that if it does but I wasn't able to find the
datasheet. Do you have that available ?

Regards,
  Guy
