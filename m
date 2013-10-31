Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:16726 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3JaLae (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Oct 2013 07:30:34 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MVJ00BSL6MUM520@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Oct 2013 07:30:33 -0400 (EDT)
Date: Thu, 31 Oct 2013 09:30:28 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: LMML <linux-media@vger.kernel.org>, media-workshop@linuxtv.org
Subject: Re: [ANNOUNCE] Notes on the Media summit 2013-10-23
Message-id: <20131031093028.64141431@samsung.com>
In-reply-to: <20131031092727.51f75527@samsung.com>
References: <20131031092727.51f75527@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 31 Oct 2013 09:27:27 -0200
Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:
 
> 1. Mauro Chehab: is the submaintainer arrangement working?
> 
> General consensus is that it is working.
> 
> Hans pointed that the commits ML is not working. Mauro will check what's
> happening at LinuxTV website after returning back.

Fixed. The issue was due to my email change. The mailbomb script has a logic
that checks if the patch committer is myself, in order to prevent mailbomb
when pulling back from Linus tree.

As I'm now using my email @samsung to commit patches, that logic was not
sending emails anymore to linuxtv-commits@linuxtv.org.

-- 

Cheers,
Mauro
