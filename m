Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:36589 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531Ab1JMSOm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Oct 2011 14:14:42 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-207.nexicom.net [216.168.118.207])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p9DIEeYu015430
	for <linux-media@vger.kernel.org>; Thu, 13 Oct 2011 14:14:41 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id CFCA11E056D
	for <linux-media@vger.kernel.org>; Thu, 13 Oct 2011 14:14:39 -0400 (EDT)
Message-ID: <4E972A8F.2020004@lockie.ca>
Date: Thu, 13 Oct 2011 14:14:39 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: help with azap
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

$ more channels.conf
CIII-HD:85000000:8VSB:49:52+53:1
OTTAWA CBOFT-DT:189000000:8VSB:49:53+52:3
CJOH:213000000:8VSB:49:51+52:1
TVO    :533000000:8VSB:49:52+53:1
OTTAWA  CBOT-DT:539000000:8VSB:49:52+53:3
Télé-Québec_HD:569000000:8VSB:49:52+53:3
CHOT:629000000:8VSB:49:52:3

$ azap -c channels.conf "CJOH"
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
ERROR: error while parsing Audio PID (not a number)

$ tzap -c channels.conf "CJOH"
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file 'channels.conf'
ERROR: error while parsing inversion (syntax error)

Why does tzap show what file it is reading the channel list from but 
azap doesn't?

What does "ERROR: error while parsing Audio PID (not a number)" mean?
