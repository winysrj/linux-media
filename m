Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:37925 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752121AbaE1Byo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 May 2014 21:54:44 -0400
Received: from [192.168.10.3] (cpe-174-101-197-173.cinci.res.rr.com [174.101.197.173])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by conserv.silverdirk.com (Postfix) with ESMTPSA id 9A11F69E6
	for <linux-media@vger.kernel.org>; Tue, 27 May 2014 21:47:37 -0400 (EDT)
Message-ID: <53854038.1020305@nrdvana.net>
Date: Tue, 27 May 2014 21:47:36 -0400
From: Michael Conrad <mike@nrdvana.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Any USB chip that delivers 60fps?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, I'm looking for any USB-connected device that can give me 60fps from 
a NTSC signal.  I'm either looking for a chip+driver that support 
V4L2_FIELD_ALTERNATE (which I gather are rare) so that I can construct 
my own frames at 60Hz by blending each pair of neighboring fields, or 
ideally, to find hardware or driver that does a good job of it for me.

Why NTSC you ask? because I can find high quality cameras that work 
great in low-light scenarios, where most USB cameras fall flat.

And as a follow-up question, is it possible and how hard would it be to 
add V4L2_FIELD_ALTERNATE support to one of the EasyCap drivers? Does the 
hardware de-interlace the frames on its own or is that in software?

Thanks,
-Mike
