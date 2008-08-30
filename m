Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7UF35GX025248
	for <video4linux-list@redhat.com>; Sat, 30 Aug 2008 11:03:06 -0400
Received: from mta3.srv.hcvlny.cv.net (mta3.srv.hcvlny.cv.net [167.206.4.198])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7UF2aoZ020518
	for <video4linux-list@redhat.com>; Sat, 30 Aug 2008 11:02:36 -0400
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6F001RE5SB5YK0@mta3.srv.hcvlny.cv.net> for
	video4linux-list@redhat.com; Sat, 30 Aug 2008 11:02:36 -0400 (EDT)
Date: Sat, 30 Aug 2008 11:02:35 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48B95BB6.3070200@linuxtv.org>
To: Linux and Kernel Video <video4linux-list@redhat.com>,
	linux-dvb <linux-dvb@linuxtv.org>
Message-id: <48B9610B.3010806@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <48B95BB6.3070200@linuxtv.org>
Cc: 
Subject: Re: HVR2250 / HVR2200 / SAA7164 status
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

Steven Toth wrote:
> As you know, I'm writing a driver for the SAA7164 chipset, for the 
> HVR2200 DVB-T and HVR2250 ATSC/QAM products.
> 
> People have been asking for status, here's where I am.
> 
> Do I have anything to share with people yet? Not yet.
> 
> The basic driver framework is done. Firmware is loading, I can talking 
> to the silicon through the proprietary PCIe ring buffer interface. I2C 
> is working, eeprom and tuner/demod access is done.
> 
> The HVR2250 is responding to azap commands, the tuners and demods are 
> locking, snr looks pretty good... it's going to be a popular board for 
> people.
> 
> The HVR2200 (DVB-T Version) should also worked with tzap, it's untested 
> and I can't comment on SNR at this stage.
> 
> I need to add the DMA/buffering code, this is the missing pieces before 
> a first public release.
> 
> When I have anything to share I'll put up a tree and post a 'testers 
> required' message here.

Joe, my private reply to your email address bounced. This email was 
triggered by your status request.

... don't assume I'm ignoring you ;)

- Steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
