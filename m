Return-path: <mchehab@pedra>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:49220 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab0HLKp4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Aug 2010 06:45:56 -0400
Subject: Re: [PATCH v7 4/5] V4L2: WL1273 FM Radio: Controls for the FM
 radio.
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Alexey Klimov <klimov.linux@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"Valentin Eduardo (Nokia-MS/Helsinki)" <eduardo.valentin@nokia.com>,
	"mchehab@redhat.com" <mchehab@redhat.com>
In-Reply-To: <AANLkTin_55zYQoJ3zzMtiJtSS7bnPv4CB6hjggeez23a@mail.gmail.com>
References: <1280758003-16118-1-git-send-email-matti.j.aaltonen@nokia.com>
	 <1280758003-16118-2-git-send-email-matti.j.aaltonen@nokia.com>
	 <1280758003-16118-3-git-send-email-matti.j.aaltonen@nokia.com>
	 <1280758003-16118-4-git-send-email-matti.j.aaltonen@nokia.com>
	 <1280758003-16118-5-git-send-email-matti.j.aaltonen@nokia.com>
	 <AANLkTin_55zYQoJ3zzMtiJtSS7bnPv4CB6hjggeez23a@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Aug 2010 13:45:17 +0300
Message-ID: <1281609917.14489.73.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hello Alexey

On Wed, 2010-08-11 at 10:06 +0200, ext Alexey Klimov wrote: 
> > +
> > +       radio = kzalloc(sizeof(*radio), GFP_KERNEL);
> > +       if (!radio)
> > +               return -ENOMEM;
> > +
> > +       radio->write_buf = kmalloc(256, GFP_KERNEL);
> > +       if (!radio->write_buf)
> > +               return -ENOMEM;
> 
> I'm not sure but it looks like possible memory leak. Shouldn't you
> call to kfree(radio) before returning ENOMEM?

Yes you're right...

> et_drvdata(&radio->videodev, radio);
> > +       platform_set_drvdata(pdev, radio);
> > +
> > +       return 0;
> > +
> > +err_video_register:
> > +       v4l2_device_unregister(&radio->v4l2dev);
> > +err_device_alloc:
> > +       kfree(radio);
> 
> And i'm not sure about this error path.. Before kfree(radio) it's
> needed to call kfree(radio->write_buf), rigth?
> Looks like all erorr paths in this probe function have to be checked.

Yes, I'll the the error handling here...

Thanks,
Matti 
> --
> Best regards, Klimov 



