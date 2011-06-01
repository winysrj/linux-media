Return-path: <mchehab@pedra>
Received: from ns2011.yellis.net ([79.170.233.11]:34628 "EHLO
	vds2011.yellis.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758331Ab1FAPmy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2011 11:42:54 -0400
Received: from zimbra.anevia.com (unknown [92.103.88.90])
	by vds2011.yellis.net (Postfix) with ESMTP id 247322FA8A3
	for <linux-media@vger.kernel.org>; Wed,  1 Jun 2011 17:35:07 +0200 (CEST)
Received: from faudebert.lab1.anevia.com (faudebert.lab1.anevia.com [172.27.112.2])
	by zimbra.anevia.com (Postfix) with ESMTPSA id E394F3296671
	for <linux-media@vger.kernel.org>; Wed,  1 Jun 2011 17:35:13 +0200 (CEST)
Message-ID: <4DE65C6D.2060806@anevia.com>
Date: Wed, 01 Jun 2011 17:36:13 +0200
From: Florent Audebert <florent.audebert@anevia.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: HVR-1300 analog inputs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I'm experimenting around with an Hauppauge HVR-1300 (cx88_blackbird) 
analog inputs (PAL-I signal).

Using qv4l2 (trunk) and 2.6.36.4, I successfully get a clean image on 
both composite and s-video inputs with resolutions of 640x480 or less.

With any higher resolutions, I have thin horizontal lines at moving 
positions (seems to cycle)[1].

I've tried various settings using qv4l2 on /dev/video0 and /dev/video1 
with no success.

Is there a way to get higher encoding resolution from this board ?

Thanks for helping !


Regards,


[1] http://bit.ly/m3o9HT

-- 
Florent Audebert
