Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0126.b.hostedemail.com ([64.98.42.126]:40810 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750713AbaJGGxz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Oct 2014 02:53:55 -0400
Received: from smtprelay.b.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
	by smtpgrave06.b.hostedemail.com (Postfix) with ESMTP id 520D221182E
	for <linux-media@vger.kernel.org>; Tue,  7 Oct 2014 06:44:00 +0000 (UTC)
Received: from filter.hostedemail.com (b-bigip1 [10.5.19.254])
	by smtprelay03.b.hostedemail.com (Postfix) with ESMTP id 5D1311A73BA
	for <linux-media@vger.kernel.org>; Tue,  7 Oct 2014 06:43:58 +0000 (UTC)
Received: from webmail.lycos.com (imap-ext [64.98.36.5])
	(Authenticated sender: webmail@t.artem@lycos.com)
	by omf13.b.hostedemail.com (Postfix) with ESMTPA
	for <linux-media@vger.kernel.org>; Tue,  7 Oct 2014 06:43:57 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 07 Oct 2014 11:43:57 +0500
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: linux-media@vger.kernel.org
Subject: Intermittent Logitech C510 problems (with kernel OOPSes)
Message-ID: <bd5a2e628c6514bc84ea93a4bd08b0f2@lycos.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I posted a bug report almost a year ago and since it's got zero 
attention so far I'm writing to this mailing list.

My problem is that video capturing doesn't work on Logitech C510 webcam 
in some cases.

Mind that audio input always works.

Video capturing is guaranteed not to work after I reboot from Windows 7.

In rare cases it doesn't work when I cold boot straight into Linux.

When I try to capture - either there's no signal and capturing fails to 
initiate or I get a black screen (a LED on the webcam doesn't turn on in 
both cases).

If I rmmod ehci_hcd and then modprobe ehci_hcd and uvcvideo, then 
everything starts working again.

https://bugzilla.kernel.org/show_bug.cgi?id=67551


-- 
Best regards,

Artem

