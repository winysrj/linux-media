Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61849 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab1HYTEy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 15:04:54 -0400
Received: by wwf5 with SMTP id 5so2717361wwf.1
        for <linux-media@vger.kernel.org>; Thu, 25 Aug 2011 12:04:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMT6Pyc_1xTGOicq82SX5TxwGNshRGMEnHF0-rLqQhL9iUwtww@mail.gmail.com>
References: <CAMT6Pyc_1xTGOicq82SX5TxwGNshRGMEnHF0-rLqQhL9iUwtww@mail.gmail.com>
From: halli manjunatha <manjunatha_halli@ti.com>
Date: Thu, 25 Aug 2011 14:04:33 -0500
Message-ID: <CAMT6PydGspjy8hQrqnhXEhUymRFXe=iR5LueygnUk-OqAET_=A@mail.gmail.com>
Subject: Re: RDS Alternate Frequency support in V4L2 radio
To: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Cc: shahed@ti.com, manjunatha_halli@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Resending.... since first time mail-delivery failed to linux-media

 Hi Hans, Mauro & list,

 I wants to add FM Radio RDS Alternate Frequency support in V4L2 and
following is my proposal.

 What is Alternate Frequency?

 Alternative frequency (or AF) is an option that allows a receiver to
re-tune to a different frequency that provides the same station, when
the first signal becomes too weak (e.g. when moving out of range).
This is often used in car stereo systems, enabled by  Radio Data
System(RDS).

 My Proposal:

 FM Transmitter:

 Add an extra control ID (CID) V4L2_CID_RDS_TX_AF like CID's for
Radio_Text, PS_Name etc for Alternate Frequency set. With this CID
driver will set the AF and starts transmitting in both the
frequencies.

 FM Receiver:

 Solution 1: Add support for AF based Seek in ioctl
"vidioc_s_hw_freq_seek" by adding AF_SEEK option in "struct
v4l2_hw_freq_seek" so that whenever application receives signal
strength low or a particular channel it will call the ioctl
vidioc_s_hw_freq_seek with AF_SEEK option and driver will do AF seek
and returns the seeked new frequency back to app.

 Solution 2: Whenever application receives signal strength low for a
radio channel, it will call the ioctl  .vidioc_g_frequency where
driver will check the signal strength and if its low then do the AF
switch and return the new frequency back to application

 Solution3: Let Application handle the AF switching, means application
will get the available AF frequencies for a channel and whenever
application receives signal strength low for the channel it will check
the AF list and do the vidioc_s_frequency for each entries in list.
