Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:25680 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751429Ab1AEWo3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Jan 2011 17:44:29 -0500
Subject: Re: [PATCH 1/3] hdpvr: Add I2C and ir-kdb-i2c registration of the
 Zilog Z8 IR chip
From: Andy Walls <awalls@md.metrocast.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <20110105135036.73535ef9@endymion.delvare>
References: <1293587067.3098.10.camel@localhost>
	 <1293587173.3098.12.camel@localhost>
	 <20110105135036.73535ef9@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Jan 2011 17:44:57 -0500
Message-ID: <1294267497.9672.9.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Wed, 2011-01-05 at 13:50 +0100, Jean Delvare wrote:
> On Tue, 28 Dec 2010 20:46:13 -0500, Andy Walls wrote:
> > 
> > Add I2C registration of the Zilog Z8F0811 IR microcontroller for either
> > lirc_zilog or ir-kbd-i2c to use.  This is a required step in removing
> > lirc_zilog's use of the deprecated struct i2c_adapter.id field.
> > 
> > Signed-off-by: Andy Walls <awalls@md.metrocast.net>
> > ---
> >  drivers/media/video/hdpvr/hdpvr-core.c |    5 +++
> >  drivers/media/video/hdpvr/hdpvr-i2c.c  |   53 ++++++++++++++++++++++++++++++++
> >  drivers/media/video/hdpvr/hdpvr.h      |    6 +++
> >  3 files changed, 64 insertions(+), 0 deletions(-)
> 
> Looks good to me (even though it looks strange to update code which is
> apparently disabled for quite a while...)

Yes it is odd. My intent was ensure that after removal of adap->id, that
the hdpvr driver would, in the future, identify its device in a manner
lirc_zilog was expecting.

I don't have a HD PVR with which to test things myself.  So putting in
all the plumbing lowers the barrier for developers like Jarrod or Janne
to test lirc_zilog with an HD PVR when/if they re-enable I2C in hdpvr.

Regards,
Andy

> Acked-by: Jean Delvare <khali@linux-fr.org>



