Return-path: <mchehab@gaivota>
Received: from zone0.gcu-squad.org ([212.85.147.21]:29086 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab1AEMv1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Jan 2011 07:51:27 -0500
Date: Wed, 5 Jan 2011 13:50:36 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 1/3] hdpvr: Add I2C and ir-kdb-i2c registration of the
 Zilog Z8 IR chip
Message-ID: <20110105135036.73535ef9@endymion.delvare>
In-Reply-To: <1293587173.3098.12.camel@localhost>
References: <1293587067.3098.10.camel@localhost>
	<1293587173.3098.12.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Tue, 28 Dec 2010 20:46:13 -0500, Andy Walls wrote:
> 
> Add I2C registration of the Zilog Z8F0811 IR microcontroller for either
> lirc_zilog or ir-kbd-i2c to use.  This is a required step in removing
> lirc_zilog's use of the deprecated struct i2c_adapter.id field.
> 
> Signed-off-by: Andy Walls <awalls@md.metrocast.net>
> ---
>  drivers/media/video/hdpvr/hdpvr-core.c |    5 +++
>  drivers/media/video/hdpvr/hdpvr-i2c.c  |   53 ++++++++++++++++++++++++++++++++
>  drivers/media/video/hdpvr/hdpvr.h      |    6 +++
>  3 files changed, 64 insertions(+), 0 deletions(-)

Looks good to me (even though it looks strange to update code which is
apparently disabled for quite a while...)

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
