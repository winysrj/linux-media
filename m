Return-path: <mchehab@pedra>
Received: from ns2011.yellis.net ([79.170.233.11]:44569 "EHLO
	vds2011.yellis.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab1DFJPy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Apr 2011 05:15:54 -0400
Received: from zimbra.anevia.com (cac94-13-78-227-100-250.fbx.proxad.net [78.227.100.250])
	by vds2011.yellis.net (Postfix) with ESMTP id B8AB42FA8A9
	for <linux-media@vger.kernel.org>; Wed,  6 Apr 2011 11:07:59 +0200 (CEST)
Received: from [172.27.112.2] (faudebert.lab1.anevia.com [172.27.112.2])
	by zimbra.anevia.com (Postfix) with ESMTPSA id 584BC3296671
	for <linux-media@vger.kernel.org>; Wed,  6 Apr 2011 11:08:02 +0200 (CEST)
Message-ID: <4D9C2D71.7070403@anevia.com>
Date: Wed, 06 Apr 2011 11:08:01 +0200
From: Florent Audebert <florent.audebert@anevia.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: stb0899 signal strength value in dvb-s2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi everyone,

Using a KNC-1 DVB-S2 board I noticed stb0899_read_signal_strength() 
in stb0899_drv.c always return the same value (1450) in dvb-s2 whatever
the signal power is.

It seems STB0899_READ_S2REG(STB0899_DEMOD, IF_AGC_GAIN) macro always
returns zero.

Any idea of what is causing this ?


Regards,

-- 
Florent AUDEBERT
