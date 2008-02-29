Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1TNq1Uq021258
	for <video4linux-list@redhat.com>; Fri, 29 Feb 2008 18:52:01 -0500
Received: from mail-in-14.arcor-online.net (mail-in-14.arcor-online.net
	[151.189.21.54])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1TNpQrI012274
	for <video4linux-list@redhat.com>; Fri, 29 Feb 2008 18:51:26 -0500
Received: from mail-in-12-z2.arcor-online.net (mail-in-12-z2.arcor-online.net
	[151.189.8.29])
	by mail-in-14.arcor-online.net (Postfix) with ESMTP id 60AF9187A1E
	for <video4linux-list@redhat.com>; Sat,  1 Mar 2008 00:51:26 +0100 (CET)
Received: from mail-in-14.arcor-online.net (mail-in-14.arcor-online.net
	[151.189.21.54])
	by mail-in-12-z2.arcor-online.net (Postfix) with ESMTP id 4F72427943C
	for <video4linux-list@redhat.com>; Sat,  1 Mar 2008 00:51:26 +0100 (CET)
Received: from [192.168.0.10] (181.126.46.212.adsl.ncore.de [212.46.126.181])
	(Authenticated sender: hermann-pitton@arcor.de)
	by mail-in-14.arcor-online.net (Postfix) with ESMTP id D2214187A1E
	for <video4linux-list@redhat.com>; Sat,  1 Mar 2008 00:51:25 +0100 (CET)
From: hermann pitton <hermann-pitton@arcor.de>
To: Linux and Kernel Video <video4linux-list@redhat.com>
In-Reply-To: <200701201749.02254.ulfbart@gmx.net>
References: <200606152230.04490.hverkuil@xs4all.nl>
	<200701201749.02254.ulfbart@gmx.net>
Content-Type: text/plain; charset=utf-8
Date: Sat, 01 Mar 2008 00:44:32 +0100
Message-Id: <1204328672.3190.9.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: Can anyone test the saa6752hs (saa7134-empress)?
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

Am Samstag, den 20.01.2007, 17:48 +0100 schrieb Ulf Bartholomäus:
> Hi Hans,
> 
> On Thursday 15 June 2006 22:30, Hans Verkuil wrote:
> > I'm currently working to switch cx88-blackbird and saa7134-empress over
> > to the new MPEG encoding API. So I need someone to test the changes to
> > the empress driver and saa6752hs module for me.
> On which place I found more information about this. What packages should be 
> installed?
> 
> > If you have a card with that hardware and are willing to test it (and
> > possibly even do some development to improve the current driver) then
> > please contact me. The changes I made to the cx88-blackbird work fine,
> > so I hope that the same is true for the saa6752hs changes but without
> > hardware I simply can't test it.
> Yes I have a KNC1 TV-Station DVR with this chipset.
> http://www.knc1.de/d/produkte/analog_dvr.htm
>  
> Is your offer sometimes available now (more than a half year ago)?
> 
> Ciao Ulf
> 

Hi,

have started to mess around with a not yet supported saa7134_empress
hybrid device.

I have anything going, except the mpeg encoder.

Last track of having it working seems 2.4.18, but I get even EIO stuff
on trying to read from the device there, but that might be device
specific. At least it has two gpio switchers not seen before, but the
whole stuff seems not to be that well documented ...

Current stuff is definitely broken,
any known last working status out there?

Cheers,
Hermann






--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
