Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:7024 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab0IJNTz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 09:19:55 -0400
Date: Fri, 10 Sep 2010 15:19:43 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Steven Toth <stoth@kernellabs.com>
Subject: [PATCH 0/5] Clean-ups to the cx22702 frontend driver
Message-ID: <20100910151943.103f7423@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi all, hi Steven,

I wrote these 5 patches cleaning up the cx22702 frontend driver a long
time ago, I've been using them for months, so it's probably about time
that I post them for review and, hopefully, upstream inclusion.

Note that I unfortunately do not have access to the CX22702 datasheet,
so my changes are based solely on analysis of the original code, and
testing with a real chip (on my WinFast DTV1000-T.)

[PATCH 1/5] cx22702: Clean up register access functions
[PATCH 2/5] cx22702: Drop useless initializations to 0
[PATCH 3/5] cx22702: Avoid duplicating code in branches
[PATCH 4/5] cx22702: Some things never change
[PATCH 5/5] cx22702: Simplify cx22702_set_tps()

Reviews/comments welcome, of course.

-- 
Jean Delvare
