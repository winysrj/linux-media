Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.220.in.ua ([89.184.67.205]:51626 "EHLO smtp.220.in.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbcF1UcJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 16:32:09 -0400
Received: from [192.168.202.100] (unknown [109.251.9.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.220.in.ua (Postfix) with ESMTPSA id BF0A11A2058A
	for <linux-media@vger.kernel.org>; Tue, 28 Jun 2016 23:21:59 +0300 (EEST)
To: linux-media@vger.kernel.org
From: Oleh Kravchenko <oleg@kaa.org.ua>
Subject: si2157 driver
Message-ID: <5772DC68.9050600@kaa.org.ua>
Date: Tue, 28 Jun 2016 23:22:00 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello linux media developers!

I try add support for usb hybrid tuner, it based on:
CX23102-112, Si2158, Si2168

I updated cx231xx-cards.c with valid ids, but I don't have idea how to
use Si2158.
It is not listed in tuner-types.c

Why si2157.c is absent in tuner-types.c?
Or at the current state si2157.c don't have analog support?
