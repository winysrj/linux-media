Return-path: <mchehab@gaivota>
Received: from smtp5-g21.free.fr ([212.27.42.5]:52186 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab1ABMA2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Jan 2011 07:00:28 -0500
Date: Sun, 2 Jan 2011 13:02:55 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: RFC: Move the deprecated et61x251 and sn9c102 to staging
Message-ID: <20110102130255.3ac018b0@tele>
In-Reply-To: <201101021225.22104.hverkuil@xs4all.nl>
References: <201101012053.00372.hverkuil@xs4all.nl>
	<4D20565B.9090307@redhat.com>
	<201101021225.22104.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sun, 2 Jan 2011 12:25:21 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> > It seems to me that et61x251 will also stay there for a long time,
> > as there are just two devices supported by gspca driver, while
> > et61x251 supports 25.
> > 
> > Btw, we currently have a conflict with this USB ID:
> > 	USB_DEVICE(0x102c, 0x6151),
> > 
> > Both etoms and et61x251 support it, and there's no #if to disable
> > it on one driver, if both drivers are compiled. We need to disable
> > it either at gspca_etoms or at et61x251, in order to avoid users of
> > having a random experience with this device.  
> 
> Surely such devices should be removed from et61x251 or sn9c102 as
> soon as they are added to gspca?

The et61x251 wants to manage all etoms webcams, but only the 102c:6251
is handled (sensor tas5130d1b - the 102c:6151 contains a pas106).
The other USB ID's should be removed from this driver.

About sn9c102, some people say that the sn9c102 is working better than
gspca. Also, both drivers et61x251 and sn9c102 support cropping while
gspca does not.

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
