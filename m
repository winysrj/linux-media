Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.abisoft.spb.ru ([91.190.120.140]:59025 "EHLO
	mail.abisoft.spb.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589Ab0DWIKq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Apr 2010 04:10:46 -0400
Received: from alexkol.abisoft.spb.ru (alexkol.abisoft.spb.ru [172.26.10.1])
	by mail.abisoft.spb.ru (Postfix) with ESMTP id 226563F6D1
	for <linux-media@vger.kernel.org>; Fri, 23 Apr 2010 11:47:50 +0400 (MSD)
Date: Fri, 23 Apr 2010 11:47:50 +0400
From: Alexander Kolesnik <linux-kernel@abisoft.biz>
Message-ID: <1363287547.20100423114750@abisoft.biz>
To: linux-media@vger.kernel.org
Subject: Re: Fw: PROBLEM: linux server halts while restarting VLC
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

The issue happens if VLC process hasn't been unloaded before executing
another  instance.  In  this  case  killall  command  did  not work as
supposed.
Hope this helps.

> We have a video camera which is connected to a capture card in a linux
> server  (CentOS  5.4).  VLC  takes  video  data from the capture card,
> streams  it  and writes to a file. A cron job checking the file's size
> and  rotates  it  when  it comes to a configured limit. After file was
> rotated, VLC process is restarted.
[...]

--
Best regards,
Alexander


