Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.10]:47511 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755735AbZC3W33 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 18:29:29 -0400
Received: from localhost (smtp-filter.ukfsn.org [192.168.54.205])
	by mail.ukfsn.org (Postfix) with ESMTP id 2CF9BDEB9B
	for <linux-media@vger.kernel.org>; Mon, 30 Mar 2009 23:29:32 +0100 (BST)
Received: from mail.ukfsn.org ([192.168.54.25])
	by localhost (smtp-filter.ukfsn.org [192.168.54.205]) (amavisd-new, port 10024)
	with ESMTP id CMRbuMhwKMtr for <linux-media@vger.kernel.org>;
	Mon, 30 Mar 2009 23:07:50 +0100 (BST)
Received: from realh.co.uk (unknown [84.45.223.215])
	by mail.ukfsn.org (Postfix) with ESMTP id DED14DEB91
	for <linux-media@vger.kernel.org>; Mon, 30 Mar 2009 23:29:31 +0100 (BST)
Date: Mon, 30 Mar 2009 23:29:25 +0100
From: Tony Houghton <h@realh.co.uk>
To: linux-media@vger.kernel.org
Subject: Reading a packet at a time
Message-ID: <20090330232925.28f6c5bb@realh.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DVB API guarantees that read() on a file descriptor on which
DMX_SET_FILTER has been called reads one whole section at a time
as long as the provided buffer is large enough. Is
there a corresponding guarantee for DMX_SET_PES_FILTER ie can I rely on
being able to read whole TS or PES packets from a dvr device?

-- 
TH * http://www.realh.co.uk
