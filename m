Return-path: <linux-media-owner@vger.kernel.org>
Received: from csmtp3.one.com ([91.198.169.23]:51002 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830Ab0BRRJa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2010 12:09:30 -0500
Received: from [94.196.5.234] (94.196.5.234.threembb.co.uk [94.196.5.234])
	by csmtp3.one.com (Postfix) with ESMTP id 4EA55240604F
	for <linux-media@vger.kernel.org>; Thu, 18 Feb 2010 17:00:04 +0000 (UTC)
Subject: gst-launch and locking of dvb adapter
From: Mike <mike@redtux.org.uk>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Feb 2010 17:00:18 +0000
Message-Id: <1266512418.1791.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

does anyone know if it is possible to use gst-launch to record two dvb
streams simultaneously with dvbsrc

I am trying a pipeline such as

gst-launch dvbsrc pids=6881:6882 ! filesink location=ds9a.ps

but I keep getting problems with freeing pipeline

I know dvbstreamer can do it so it should be possible somehow

any hints appreciated

