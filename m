Return-path: <linux-media-owner@vger.kernel.org>
Received: from csmtp1.one.com ([195.47.247.21]:50304 "EHLO csmtp1.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750Ab0CIMBC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Mar 2010 07:01:02 -0500
Received: from [94.196.234.254] (94.196.234.254.threembb.co.uk [94.196.234.254])
	by csmtp1.one.com (Postfix) with ESMTP id 189FA1BC03B2C
	for <linux-media@vger.kernel.org>; Tue,  9 Mar 2010 12:01:00 +0000 (UTC)
Subject: Issue with dvbsnoop
From: Mike <mike@redtux.org.uk>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Mar 2010 12:08:41 +0000
Message-Id: <1268136521.1825.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I have been using dvbsnoop for quite a while to get an epg. However it
has jjust started hanging when I give a -n value of more than about 300

command
dvbsnoop -s sec -timeout 500-nph -n 1500 0x12

This gets run via a loop which tunes to each available frequency in turn
so I dont neccessarily care if each iteration completes as long as it
exits. 

Any way to stop the hang as I need to get more packets than 300 to get a
sensible epg

thanks


