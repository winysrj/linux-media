Return-path: <mchehab@gaivota>
Received: from blu0-omc2-s24.blu0.hotmail.com ([65.55.111.99]:2007 "EHLO
	blu0-omc2-s24.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751479Ab1EMCF3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 22:05:29 -0400
Message-ID: <BLU157-w550E2F1986AB3A248199C0D8880@phx.gbl>
From: Manoel PN <pinusdtv@hotmail.com>
To: <linux-media@vger.kernel.org>,
	Mauro Chehab <mchehab@infradead.org>, <lgspn@hotmail.com>
Subject: [PATCH 2/4] Modifications to the driver mb86a20s
Date: Fri, 13 May 2011 05:05:28 +0300
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


This patch implements mb86a20s_read_snr and adds mb86a20s_read_ber and mb86a20s_read_ucblocks both without practical utility but that programs as dvbsnoop need.


Signed-off-by: Manoel Pinheiro <pinusdtv@hotmail.com>


 		 	   		  