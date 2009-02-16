Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4267 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbZBPWun (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 17:50:43 -0500
Received: from tschai.lan (cm-84.208.85.194.getinternet.no [84.208.85.194])
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id n1GMoeCT074476
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 16 Feb 2009 23:50:41 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: DVB v3 API question
Date: Mon, 16 Feb 2009 23:50:50 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902162350.50319.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've made a v4l-dvb tree containing the old DVB API sources as found here: 
http://www.linuxtv.org/cgi-bin/viewcvs.cgi/DVB/doc/dvbapi/.

This tree is here: http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-api

Run 'make spec' to build both the v4l2-spec and the dvb-spec, or 
run 'make -C dvb-spec' to build only the latter. You'll need the transfig 
package to get the dvb-spec to compile.

My question is if this is indeed the most recent version that we have? There 
is a dvb-api-v4 pdf document, but it is my understanding that v4 was 
actually never implemented and never got beyond the proposal stage. Is that 
correct? Or are there bits and pieces that were actually used?

The original documentation for v4 is here: 
http://www.linuxtv.org/cgi-bin/viewcvs.cgi/dvb-kernel-v4/linux/Documentation/dvb/

If someone can tell me the best version to use, then I'll merge it in 
v4l-dvb and people can start to update this document. I can actually do the 
updates for the audio.tex and video.tex part myself.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
