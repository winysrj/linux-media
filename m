Return-path: <linux-media-owner@vger.kernel.org>
Received: from 8.mo3.mail-out.ovh.net ([87.98.172.249]:44942 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757757Ab2JQUQl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 16:16:41 -0400
Received: from mail191.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo3.mail-out.ovh.net (Postfix) with SMTP id 0C542FF8F48
	for <linux-media@vger.kernel.org>; Wed, 17 Oct 2012 19:22:05 +0200 (CEST)
Received: from [192.168.10.23] (asterisk.ventoso.local [192.168.10.23])
	by ventoso.org (Postfix) with ESMTP id 1C99EC26C5E
	for <linux-media@vger.kernel.org>; Wed, 17 Oct 2012 19:12:14 +0200 (CEST)
Message-ID: <507EE702.2010103@ventoso.org>
Date: Wed, 17 Oct 2012 19:12:34 +0200
From: Luca Olivetti <luca@ventoso.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Diversity support?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

if I look at the vl4-dvb wiki, it says that diversity isn't currently supported

http://www.linuxtv.org/wiki/index.php?title=Special%3ASearch&search=diversity&go=Go

however grepping the git tree there are various mentions of diversity at least for some dibcom based devices:

http://git.linuxtv.org/linux-2.6.git?a=search&h=HEAD&st=grep&s=diversity

So, what's the real status of diversity support?

TIA
-- 
Luca Olivetti
