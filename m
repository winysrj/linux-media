Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab1KTM5z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Nov 2011 07:57:55 -0500
Message-ID: <4EC8F94F.8090800@redhat.com>
Date: Sun, 20 Nov 2011 10:57:51 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Eddi De Pieri <eddi@depieri.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] initial support for HAUPPAUGE HVR-930C again...
References: <CAKdnbx5_qfotsKh0-s+DN7skx-J2=1HRw-qZOw=3mUHCQFHo2g@mail.gmail.com>
In-Reply-To: <CAKdnbx5_qfotsKh0-s+DN7skx-J2=1HRw-qZOw=3mUHCQFHo2g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 19-11-2011 13:37, Eddi De Pieri escreveu:
> With this patch I try again to add initial support for HVR930C.
> 
> Tested only DVB-T, since in Italy Analog service is stopped.
> 
> Actually "scan -a0 -f1", find only about 50 channel while 400 should
> be available.
> 
> Signed-off-by: Eddi De Pieri <eddi@depieri.net>

Tested here with DVB-C, using the Terratec firmware. It worked as expected:
213 channels scanned, tested a few non-encrypted ones, and it seems to be
working as expected.

It didn't work with the firmware used by ddbrigde driver (the one that get_dvb_firmware
script is capable of retrieving).

> 
> Regards
> 
> Eddi

