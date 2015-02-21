Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpq1.tb.mail.iss.as9143.net ([212.54.42.164]:35126 "EHLO
	smtpq1.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751288AbbBUWQx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2015 17:16:53 -0500
Received: from [212.54.42.134] (helo=smtp3.tb.mail.iss.as9143.net)
	by smtpq1.tb.mail.iss.as9143.net with esmtp (Exim 4.82)
	(envelope-from <rudy@grumpydevil.homelinux.org>)
	id 1YPHdC-0005MX-6p
	for linux-media@vger.kernel.org; Sat, 21 Feb 2015 22:30:34 +0100
Received: from 5ed66c68.cm-7-7b.dynamic.ziggo.nl ([94.214.108.104] helo=imail.office.romunt.nl)
	by smtp3.tb.mail.iss.as9143.net with esmtp (Exim 4.82)
	(envelope-from <rudy@grumpydevil.homelinux.org>)
	id 1YPHdC-0006Hk-40
	for linux-media@vger.kernel.org; Sat, 21 Feb 2015 22:30:34 +0100
Received: from [192.168.1.15] (cenedra.office.romunt.nl [192.168.1.15])
	by imail.office.romunt.nl (8.14.4/8.14.4/Debian-4) with ESMTP id t1LLUXLO012677
	for <linux-media@vger.kernel.org>; Sat, 21 Feb 2015 22:30:33 +0100
Message-ID: <54E8F8F4.1010601@grumpydevil.homelinux.org>
Date: Sat, 21 Feb 2015 22:30:28 +0100
From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: DVB Simulcrypt
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dears (Hans?)

My setup, where the cable operator was using only irdeto, was working 
good. Then the cable operator merged with another, and now the networks 
are being merged. As a result, the encryption has moved from irdeto only 
to simulcyrpt with Irdeto and Nagra.

Current status:
- when i put the CA card in a STB, it works
- when trying to record an encrypted channel from PC, it no longer works.

I suspect the problem is that the wrong keys are used: Nagra keys in 
stead of Irdeto keys.

I do not know whether:
- kernel issue (is simulcrypt supported?)
- API issue (is all support in place to select the right key stream?)
- application issue (does the application allow to set the right CA?)

If this is an application issue, could it be solved by setting the API 
outside the application, to direct it to the right (Irdeto in my case) 
encryption?

The application i am using is MythTV.


Cheers


Rudy
