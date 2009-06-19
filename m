Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f212.google.com ([209.85.220.212]:45025 "EHLO
	mail-fx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbZFSQL3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 12:11:29 -0400
Message-ID: <4A3BB8B1.9030407@gmail.com>
Date: Fri, 19 Jun 2009 18:11:29 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: mchehab@infradead.org
CC: linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	ralph@convergence.de, marcus@convergence.de
Subject: sleep in atomic in dvb_dmx_swfilter_packet
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

we've found that there is a vmalloc call from atomic context:
dvb_dmx_swfilter_packets
 -> spin_lock()
 -> dvb_dmx_swfilter_packet
   -> vmalloc()
