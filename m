Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4GIIbHQ001460
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 14:18:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4GIHsfQ025619
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 14:17:54 -0400
Date: Fri, 16 May 2008 15:17:18 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: dean <dean@sensoray.com>
Message-ID: <20080516151718.15de1b9b@gaivota>
In-Reply-To: <482DAEDB.70702@sensoray.com>
References: <20080514205927.GA13134@kroah.com>
	<20080515235102.756407d3@gaivota>
	<200805160828.13856.oliver@neukum.org>
	<482DAEDB.70702@sensoray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, linux-usb@vger.kernel.org,
	Greg KH <greg@kroah.com>, Oliver Neukum <oliver@neukum.org>,
	linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org
Subject: Re: [PATCH] USB: add Sensoray 2255 v4l driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Dean,

On Fri, 16 May 2008 08:57:15 -0700
dean <dean@sensoray.com> wrote:

> Hi Oliver,
> 
> Just to be clear.  You mean fixing the loading issues(ugly msleep, 
> etc...) that Mauro mentioned, not the YUV formats(which seem unrelated)? 
> 
> Would it be ok to have just 422P and greyscale in the driver for now if 
> we can't get a firmware update in a reasonable timeframe? It's certainly 
> not ideal, but we could direct our customers to the libraries, at least 
> until we get a proper HW fix.

Feature regression is something that shouldn't happen. If we add the driver
with a color conversion inside, we should somehow keep this feature available
on newer versions. That's said, I don't see any issue if the later versions do
this implementation inside hardware/firmware, since the end result is that the
driver will keep supporting those standards.

>From my side, I'm ok on having this color conversion for a short timeframe (one
or two kernel releases), if you are sure that those features will be present
on the next firmwares.

The better is to mark the driver as EXPERIMENTAL, at Kconfig.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
