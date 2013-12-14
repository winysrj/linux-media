Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42828 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801Ab3LNQpX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Dec 2013 11:45:23 -0500
Message-ID: <52AC8B20.906@iki.fi>
Date: Sat, 14 Dec 2013 18:45:20 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH RFC v2 0/7] V4L2 SDR API
References: <1387037729-1977-1-git-send-email-crope@iki.fi>
In-Reply-To: <1387037729-1977-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
One possible problem I noticed is device node name.

Documentation/devices.txt

  65 block	SCSI disk devices (16-31)
		  0 = /dev/sdq		17th SCSI disk whole disk
		 16 = /dev/sdr		18th SCSI disk whole disk
		 32 = /dev/sds		19th SCSI disk whole disk
		    ...
		240 = /dev/sdaf		32nd SCSI disk whole disk

		Partitions are handled in the same way as for IDE
		disks (see major number 3) except that the limit on
		partitions is 15.


  81 char	video4linux
		  0 = /dev/video0	Video capture/overlay device
		    ...
		 63 = /dev/video63	Video capture/overlay device
		 64 = /dev/radio0	Radio device
		    ...
		127 = /dev/radio63	Radio device
		224 = /dev/vbi0		Vertical blank interrupt
		    ...
		255 = /dev/vbi31	Vertical blank interrupt


What I understand, /dev/sdr is not suitable node name as it conflicts 
with existing node name. Any ideas?

regards
Antti

-- 
http://palosaari.fi/
