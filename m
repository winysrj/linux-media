Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5R21P5f029709
	for <video4linux-list@redhat.com>; Thu, 26 Jun 2008 22:01:25 -0400
Received: from mail-in-09.arcor-online.net (mail-in-09.arcor-online.net
	[151.189.21.49])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5R20w8E009068
	for <video4linux-list@redhat.com>; Thu, 26 Jun 2008 22:00:59 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Ben Collins <ben.collins@canonical.com>
In-Reply-To: <1214528392.4480.40.camel@pc10.localdom.local>
References: <1214501094.7150.29.camel@cunning>
	<1214524580.4480.32.camel@pc10.localdom.local>
	<1214525206.7150.118.camel@cunning>
	<1214528392.4480.40.camel@pc10.localdom.local>
Content-Type: text/plain
Date: Fri, 27 Jun 2008 03:58:33 +0200
Message-Id: <1214531913.4480.53.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [v4l-dvb-maintainer] saa7134 duplicate device in module, but
	different device_data?
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


Am Freitag, den 27.06.2008, 02:59 +0200 schrieb hermann pitton:
> Am Donnerstag, den 26.06.2008, 20:06 -0400 schrieb Ben Collins:
> > On Fri, 2008-06-27 at 01:56 +0200, hermann pitton wrote:

[snip]
> I do agree and will be happy with any patch you provide to get it out of
> sight ;)
> 

Ben,

just move the duplicate stuff out of the auto detection until we have
something better and send that patch. 

Previous hopes, to be able to do something more, are for sure
disappointed now and no reason to wait any longer.

We rely on the eeprom gimmicks and they did use them mainly previously
to shot down each other as best they can ...

Cheers,
Hermannn




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
