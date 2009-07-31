Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:38291 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZGaTrQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2009 15:47:16 -0400
Received: from smtp07.web.de (fmsmtp07.dlan.cinetic.de [172.20.5.215])
	by fmmailgate01.web.de (Postfix) with ESMTP id 9E99010F26E66
	for <linux-media@vger.kernel.org>; Fri, 31 Jul 2009 21:47:16 +0200 (CEST)
Received: from [217.228.167.87] (helo=[172.16.99.2])
	by smtp07.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #277)
	id 1MWy4S-0004rO-00
	for linux-media@vger.kernel.org; Fri, 31 Jul 2009 21:47:16 +0200
Message-ID: <4A734A40.7040306@magic.ms>
Date: Fri, 31 Jul 2009 21:47:12 +0200
From: emagick@magic.ms
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Cinergy T2 stopped working with kernel 2.6.30
References: <4A61FD76.8010409@magic.ms> <4A733BAB.6080305@magic.ms>
In-Reply-To: <4A733BAB.6080305@magic.ms>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Apparently, usb_bulk_msg() cannot be used with data on the stack:

http://www.linuxtv.org/pipermail/linux-dvb/2008-August/028150.html
http://www.mail-archive.com/linux-usb-devel@lists.sourceforge.net/msg19158.html
