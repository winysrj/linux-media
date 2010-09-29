Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:36335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab0I2P2Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Sep 2010 11:28:25 -0400
Message-ID: <4CA35B00.4000300@redhat.com>
Date: Wed, 29 Sep 2010 12:28:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: stable@kernel.org
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: V4L/DVB (13966): DVB-T regression fix for saa7134 cards
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Some users are reporting a regression on 2.6.31 and 2.6.32 that were fixed on 2.6.33,
related to DVB reception with saa7134.

Could you please cherry-pick this patch to 2.6.32 stable as well?
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.33.y.git;a=commit;h=08be64be3d1e5ecd72e7ba3147aea518e527f08e

Thanks,
Mauro.
