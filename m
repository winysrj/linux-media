Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.ippbx.ru ([213.247.143.109]:64062 "EHLO mail.pbx-ng.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754497Ab0APRjT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 12:39:19 -0500
Received: from [127.0.0.1] ([79.97.33.196])
	(authenticated bits=0)
	by mail.pbx-ng.ru (8.13.6-V/8.13.1-V) with ESMTP id o0GHTX62092764
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 16 Jan 2010 20:29:41 +0300 (MSK)
	(envelope-from dil@cea.ru)
Message-ID: <4B51F77C.2080906@cea.ru>
Date: Sat, 16 Jan 2010 17:29:32 +0000
From: Alexander Dilevskiy <dil@cea.ru>
MIME-Version: 1.0
To: V4L Mailing List <linux-media@vger.kernel.org>
Subject: TT S2-3200 Infrared 
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi guys!

I was playing with my Technotrend S2-3200 card (bidget-ci driver) and 
found the driver selected a wrong IR remote keymap 
(ir_codes_budget_ci_old instead of ir_codes_tt_1500) because my 
subsystem_device ID 0x1019 was not present in the corresponding
switch (budget_ci->budget.dev->pci->subsystem_device).

Adding "case 0x1019:" fixed the issue.

Shall I just post the patch to this maillist or send it to the budget-ci 
driver maintainer (who's that guy?) ?


Regards,
Alex
