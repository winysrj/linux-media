Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:34208 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbcAMPPh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2016 10:15:37 -0500
Received: from us02secmta2.synopsys.com (us02secmta2.synopsys.com [10.12.235.98])
	by smtprelay.synopsys.com (Postfix) with ESMTP id 5BC0524E0CE2
	for <linux-media@vger.kernel.org>; Wed, 13 Jan 2016 07:15:37 -0800 (PST)
Received: from us02secmta2.internal.synopsys.com (us02secmta2.internal.synopsys.com [127.0.0.1])
	by us02secmta2.internal.synopsys.com (Service) with ESMTP id 4747F55F13
	for <linux-media@vger.kernel.org>; Wed, 13 Jan 2016 07:15:37 -0800 (PST)
Received: from mailhost.synopsys.com (mailhost1.synopsys.com [10.12.238.239])
	by us02secmta2.internal.synopsys.com (Service) with ESMTP id 303A955F02
	for <linux-media@vger.kernel.org>; Wed, 13 Jan 2016 07:15:37 -0800 (PST)
Received: from mailhost.synopsys.com (localhost [127.0.0.1])
	by mailhost.synopsys.com (Postfix) with ESMTP id 1BE62539
	for <linux-media@vger.kernel.org>; Wed, 13 Jan 2016 07:15:37 -0800 (PST)
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2-vip.internal.synopsys.com [10.12.239.238])
	by mailhost.synopsys.com (Postfix) with ESMTP id 1086E537
	for <linux-media@vger.kernel.org>; Wed, 13 Jan 2016 07:15:36 -0800 (PST)
To: <linux-media@vger.kernel.org>
CC: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
	<Filipe.Goncalves@synopsys.com>
From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: PCI multimedia driver
Message-ID: <56966984.9030807@synopsys.com>
Date: Wed, 13 Jan 2016 15:13:08 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi guys,

We are developing a PCI endpoint with HDMI video out and sound out capabilities
and we will need to develop a linux driver to control it (host side). Could you
please point us some existing driver example?

Thanks,
-Joao
