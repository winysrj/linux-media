Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.abisoft.spb.ru ([91.190.120.140]:54524 "EHLO
	mail.abisoft.spb.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab0DZI0I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 04:26:08 -0400
Received: from alexkol.abisoft.spb.ru (alexkol.abisoft.spb.ru [172.26.10.1])
	by mail.abisoft.spb.ru (Postfix) with ESMTP id F39583F6D1
	for <linux-media@vger.kernel.org>; Mon, 26 Apr 2010 12:26:03 +0400 (MSD)
Date: Mon, 26 Apr 2010 12:26:03 +0400
From: Alexander Kolesnik <linux-kernel@abisoft.biz>
Message-ID: <922113694.20100426122603@abisoft.biz>
To: linux-media@vger.kernel.org
Subject: Re: Re: Fw: PROBLEM: linux server halts while restarting VLC
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

> The issue happens if VLC process hasn't been unloaded before executing
> another  instance.  In  this  case  killall  command  did  not work as
> supposed.

This  appears  not  to be true. Today the server halted while starting
VLC first time. Will try to reload bttv modules before starting VLC.

--
Best regards,
Alexander

