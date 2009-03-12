Return-path: <linux-media-owner@vger.kernel.org>
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:38189 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754112AbZCLLEO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 07:04:14 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: null pointer access in error path of lgdt3305 driver
Date: Thu, 12 Mar 2009 12:04:10 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903121204.11647.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael!

Looking at your new lgdt3305 driver, I noticed that the error path of 
lgdt3305_attach, that is also jumped to kzalloc errors, sets  
state->frontend.demodulator_priv to NULL.

That will oops in case state is NULL. So you either need two goto labels for 
failures or just return in case kzalloc fails.

Regards
Matthias
