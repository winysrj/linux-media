Return-path: <mchehab@pedra>
Received: from psmtp08.wxs.nl ([195.121.247.22]:60933 "EHLO psmtp08.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757571Ab0JEG2P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Oct 2010 02:28:15 -0400
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp08.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0L9T000PU0N14Q@psmtp08.wxs.nl> for linux-media@vger.kernel.org;
 Tue, 05 Oct 2010 08:28:14 +0200 (MEST)
Date: Tue, 05 Oct 2010 08:28:11 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Confusing dmx_pes_type_t in dmx.h
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Message-id: <4CAAC57B.4000604@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The file dmx.h declares dmx_pes_type_t which is ONLY used in this header 
file.
It is easy to make mistakes, as its member DMX_PES_OTHER resembles a 
similar symbol in demux.h from enum dmx_ts_pes:  DMX_TS_PES_OTHER

One problem was found because of Hans' compiler upgrade.

I think it would be safer (because it is easy to make mistakes) to 
remove  dmx_pes_type_t from dmx.h.

Who knows more on this driver ?

The found bug is fixed in the patch on:
http://linuxtv.org/hg/~jhoogenraad/ubuntu-firedtv/rev/44751f6fba2f

-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht

