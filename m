Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:62152 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab0CQKos (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 06:44:48 -0400
Received: by fg-out-1718.google.com with SMTP id l26so2125638fgb.1
        for <linux-media@vger.kernel.org>; Wed, 17 Mar 2010 03:44:46 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 17 Mar 2010 11:44:46 +0100
Message-ID: <4adcd9b21003170344j63f8b845ja1033d7ce590f978@mail.gmail.com>
Subject: DMX Input selection
From: The Duke Forever <thedukevip@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I'm currently developing a DVB test application without real hardware,
instead, I'm using dvb_dummy_adapter (+dvb-core and dvb_dummy_fe)
Testing PES filtering is OK, since I have read/write operations on the
logical dvr device "/dev/dvb/adapter0/dvr0"
I have problems with section filtering, I can't find a way to read
data from a TS file.
Methods I've tried :
- Write data to DVR, set the demux to read data from DVR using ioctl
"DMX_SET_SOURCE" -> seems that this ioctl is not implemented
- As the section filter reads data from frontend, I've tried to write
data to "/dev/dvb/adapter0/frontend0" so they can be read by the
demux, but no luck, no writing operation available

Any suggestions please ?!
