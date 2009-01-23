Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallbackmx06.syd.optusnet.com.au ([211.29.132.8]:52547 "EHLO
	fallbackmx06.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754990AbZAWAqY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2009 19:46:24 -0500
Received: from mail05.syd.optusnet.com.au (mail05.syd.optusnet.com.au [211.29.132.186])
	by fallbackmx06.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id n0N0kLMb008078
	for <linux-media@vger.kernel.org>; Fri, 23 Jan 2009 11:46:21 +1100
Received: from blackpaw.dyndns.org (c122-108-213-22.rochd4.qld.optusnet.com.au [122.108.213.22])
	(authenticated sender lindsay.mathieson)
	by mail05.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id n0N0iADF017447
	for <linux-media@vger.kernel.org>; Fri, 23 Jan 2009 11:44:13 +1100
Received: from blackpaw.dyndns.org (unverified [127.0.0.1])
	by blackpaw.dyndns.org (SurgeMail 4.0a) with ESMTP id 723-1769969
	for <linux-media@vger.kernel.org>; Fri, 23 Jan 2009 10:44:10 +1000
From: "Lindsay Mathieson" <lindsay.mathieson@gmail.com>
To: linux-media@vger.kernel.org
Subject: TinyTwin (af9015) Results and questions
Date: Fri, 23 Jan 2009 10:44:09 +1000
Message-id: <497912d9.3df.52be.1092695642@blackpaw.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've pulled the latest v4l-dvb trunk and installed it, can
confirm that both tuners of the DigitalNow TinyTwin work
beautifully. I do have a few questions though.

- I still have to specify:
  options dvb-usb-af9015 dual_mode=1

to enable the second tuner. I thought that would be on by
default now the 2nd tuner bugs have been worked out. 

- Is there a official place to download the firmware from?
Currently I'm getting it from:
 
http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/dvb-usb-af9015.fw

- Is it possible to estimate when this will make its way
into the linux kernel? How will I know?

I ask because I'd like to write up a howto for myth and/or
ubuntu users, and want to cover all bases.

Thanks - Lindsay

Lindsay Mathieson
http://members.optusnet.com.au/~blackpaw1/album

Lindsay Mathieson
http://members.optusnet.com.au/~blackpaw1/album
