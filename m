Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxb.rambler.ru ([81.19.66.30]:56006 "EHLO mxb.rambler.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127AbZDKOZu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Apr 2009 10:25:50 -0400
Received: from maild.rambler.ru (maild.rambler.ru [81.19.66.33])
	by mxb.rambler.ru (Postfix) with ESMTP id 061DD1BF076
	for <linux-media@vger.kernel.org>; Sat, 11 Apr 2009 18:17:48 +0400 (MSD)
Received: from [192.168.1.2] (unknown [95.32.25.213])
	(Authenticated sender: erv2005@rambler.ru)
	by maild.rambler.ru (Postfix) with ESMTP id 583608446A
	for <linux-media@vger.kernel.org>; Sat, 11 Apr 2009 18:16:15 +0400 (MSD)
From: Victor <ErV2005@rambler.ru>
Reply-To: ErV2005@rambler.ru
To: linux-media@vger.kernel.org
Subject: Dark picture on Genius E-Messenger 112 webcam with yesterday's v4l-dvb code.
Date: Sat, 11 Apr 2009 18:16:14 +0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904111816.14704.ErV2005@rambler.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

I'm using Genius E-Messenger 112 webcam on Slackware 12.2 with 2.6.27.7 kernel 
(custom-built) and yesterday's v4l-dvb sources checked out via "mercurial" 
("hg log" returns "11445:dba0b6fae413" as latest commit). the camera uses 
gspca_main and gspca_pac207 kernel modules.`

Camera works (with LD_PRELOAD=v4l2convert.so) in mplayer (mplayer tv://) and 
skype, but picture is way too dark. It looks like "contrast" is permanently 
set at maximum, and doesn't change (although it looks like camera tries to 
adjust brightness automatically).

How can this be fixed?

Few articles in the web talk about "/sys/module/gspca/parameters/gamma", etc, 
but it looks like such advice is outdated. I assume this device is not 
completely supported (people on the web recommend to avoid using this camera 
on linux), so perhaps I could provide additional data to make it work in the 
future. Or, perhaps, someone could tell me where (in gspca source) I could 
start trying to fix that problem.

-- 
With best regards, Victor
