Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:43542 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbcF1MAj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 08:00:39 -0400
Received: from dc8secmta2.synopsys.com (dc8secmta2.synopsys.com [10.13.218.202])
	by smtprelay.synopsys.com (Postfix) with ESMTP id 0A8DB24E08F6
	for <linux-media@vger.kernel.org>; Tue, 28 Jun 2016 05:00:39 -0700 (PDT)
Received: from dc8secmta2.internal.synopsys.com (dc8secmta2.internal.synopsys.com [127.0.0.1])
	by dc8secmta2.internal.synopsys.com (Service) with ESMTP id F0BC6A4112
	for <linux-media@vger.kernel.org>; Tue, 28 Jun 2016 05:00:38 -0700 (PDT)
Received: from mailhost.synopsys.com (mailhost1.synopsys.com [10.12.238.239])
	by dc8secmta2.internal.synopsys.com (Service) with ESMTP id D659BA4102
	for <linux-media@vger.kernel.org>; Tue, 28 Jun 2016 05:00:38 -0700 (PDT)
Received: from mailhost.synopsys.com (localhost [127.0.0.1])
	by mailhost.synopsys.com (Postfix) with ESMTP id C3E38B9F
	for <linux-media@vger.kernel.org>; Tue, 28 Jun 2016 05:00:38 -0700 (PDT)
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2-vip.internal.synopsys.com [10.12.239.238])
	by mailhost.synopsys.com (Postfix) with ESMTP id BECD5B9E
	for <linux-media@vger.kernel.org>; Tue, 28 Jun 2016 05:00:38 -0700 (PDT)
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
To: <linux-media@vger.kernel.org>
Subject: Submit media entity without media device
Message-ID: <0b6c1a36-8770-b9f0-4d31-6b2aa31bed5c@synopsys.com>
Date: Tue, 28 Jun 2016 13:00:31 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

We at Synopsys have a media device driver and in that media device we have a
media entity for our CSI-2 Host.

At the moment we aren't ready to submit the entire media device, so I was
wondering if it was possible to submit a media entity driver separately, without
the rest of the architecture, and if so where should we place it.

Best Regards,

Ramiro Oliveira


