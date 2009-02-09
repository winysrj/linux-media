Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.10]:56997 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528AbZBISJH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Feb 2009 13:09:07 -0500
Received: from localhost (smtp-filter.ukfsn.org [192.168.54.205])
	by mail.ukfsn.org (Postfix) with ESMTP id 6D5EFDEBD1
	for <linux-media@vger.kernel.org>; Mon,  9 Feb 2009 18:09:10 +0000 (GMT)
Received: from mail.ukfsn.org ([192.168.54.25])
	by localhost (smtp-filter.ukfsn.org [192.168.54.205]) (amavisd-new, port 10024)
	with ESMTP id Svx6Rav3h1JB for <linux-media@vger.kernel.org>;
	Mon,  9 Feb 2009 16:38:55 +0000 (GMT)
Received: from realh.co.uk (unknown [84.45.223.215])
	by mail.ukfsn.org (Postfix) with ESMTP id 10581DEBD0
	for <linux-media@vger.kernel.org>; Mon,  9 Feb 2009 18:09:09 +0000 (GMT)
Date: Mon, 9 Feb 2009 18:09:05 +0000
From: Tony Houghton <h@realh.co.uk>
To: linux-media@vger.kernel.org
Subject: Documentation for DVB application developers
Message-ID: <20090209180905.39b5f658@realh.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Is there any documentation available to supplement the Linux DVB API
reference? The reference itself seems rather out of date as it is,
especially for the demux device. There are lots of options for setting
demux filters with very little explanation, so it would be very useful
if there was some sort of tutorial or howto explaining how to use them.

If the only option is to check the source of other programs which ones
provide good, clear examples of how to perform common operations like
reading the SI and streaming/recording a programme? I thought dvbtune
might be a good place to start.

Also, is it possible to read the SI at the same time as a programme?

-- 
TH * http://www.realh.co.uk
