Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2A1A3Qt003415
	for <video4linux-list@redhat.com>; Sun, 9 Mar 2008 21:10:03 -0400
Received: from mail-in-13.arcor-online.net (mail-in-13.arcor-online.net
	[151.189.21.53])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2A19URw025664
	for <video4linux-list@redhat.com>; Sun, 9 Mar 2008 21:09:31 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Trent Piepho <xyzzy@speakeasy.org>
In-Reply-To: <Pine.LNX.4.58.0803091131430.6667@shell2.speakeasy.net>
References: <patchbomb.1204999521@liva.fdsoft.se>
	<Pine.LNX.4.58.0803091131430.6667@shell2.speakeasy.net>
Content-Type: text/plain
Date: Mon, 10 Mar 2008 02:01:29 +0100
Message-Id: <1205110889.3402.11.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Frej Drejhammar <frej.drejhammar@gmail.com>,
	Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: [PATCH 0 of 2] cx88: Enable additional cx2388x features
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

Am Sonntag, den 09.03.2008, 11:32 -0700 schrieb Trent Piepho:
> On Sat, 8 Mar 2008, Frej Drejhammar wrote:
> 
> > The cx2388x family of broadcast decoders all have features not enabled
> > by the standard cx88 driver. This patch series adds module parameters
> > allowing the chroma AGC and the color killer to be enabled. By default
> > both features are disabled as in previous versions of the driver.
> >
> > The Chroma AGC and the color killer is sometimes needed when using
> > signal sources of less than optimal quality.
> 
> This really should be done with controls, not more module parameters.
> 

This is a fully harmless example, still.

In general, we are flooded with patches currently, which seem to be
clever, but those people have not even any hardware to test them and are
easily happy to go over whole subsystems ...

I would like to see them piss in their own shoes in the first place and
not into ours.

Cheers,
Hermann







--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
