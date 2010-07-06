Return-path: <linux-media-owner@vger.kernel.org>
Received: from web94910.mail.in2.yahoo.com ([203.104.17.172]:46846 "HELO
	web94910.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751477Ab0GFFHR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Jul 2010 01:07:17 -0400
Message-ID: <594515.49257.qm@web94910.mail.in2.yahoo.com>
Date: Tue, 6 Jul 2010 10:37:12 +0530 (IST)
From: Pavan Savoy <pavan_savoy@ti.com>
Reply-To: pavan_savoy@ti.com
Subject: Re: V4L2 radio drivers for TI-WL7
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, matti.j.aaltonen@nokia.com,
	mchehab@infradead.org, eduardo.valentin@nokia.com
In-Reply-To: <201007050821.53313.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--- On Mon, 5/7/10, Hans Verkuil <hverkuil@xs4all.nl> wrote:

> From: Hans Verkuil <hverkuil@xs4all.nl>
> Subject: Re: V4L2 radio drivers for TI-WL7
> To: pavan_savoy@ti.com
> Cc: linux-media@vger.kernel.org, matti.j.aaltonen@nokia.com, mchehab@infradead.org, "pavan savoy" <pavan_savoy@yahoo.co.in>, eduardo.valentin@nokia.com
> Date: Monday, 5 July, 2010, 11:51 AM
> On Friday 02 July 2010 09:01:34 Pavan
> Savoy wrote:
> > Hi,
> > 
> > We have/in process of developing a V4L2 driver for the
> FM Radio on the Texas Instruments WiLink 7 module.
> > 
> > For transport/communication with the chip, we intend
> to use the shared transport driver currently staged in
> mainline at drivers/staging/ti-st/.
> > 
> > To which tree should I generate patches against? is
> the tree
> >
> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
> > fine ? to be used with the v4l_for_2.6.35 branch ?
> 
> You patch against git://git.linuxtv.org/v4l-dvb.git.
> 
> > 
> > Also, this is over the UART/TTY unlike the WL1273 i2c
> mfd driver...
> 
> Is the WiLink 7 a platform device (i.e. an integral part of
> the CPU) or a separate
> chip that can be used with any hardware?
> 
> Will the FM Radio always be controlled over a UART/TTY bus
> or is that specific
> to your development platform?

WiLink 7 would be a peripheral which has 1 interface with apps processor being UART, more details at,

http://www.google.co.in/url?sa=t&source=web&cd=3&ved=0CBQQFjAC&url=http%3A%2F%2Ffocus.ti.com%2Fgeneral%2Fdocs%2Fwtbu%2Fwtbuproductcontent.tsp%3FtemplateId%3D6123%26navigationId%3D12859%26contentId%3D67453%26DCMP%3Dwtbu_wilink7_2010%26HQS%3DOther%2BPR%2Bwilink7videos&ei=d7kyTKPXMoTGlQfJ-7W-Cw&usg=AFQjCNEjN2jc9TdSDWDRtWcmbZn6Szhbug&sig2=DN4gAQls9AdOeHQhlPlvjA

Since there exists only 1 interface for all BT/FM and GPS cores on chip, a shared transport driver has been developed and placed at drivers/staging/ti-st/

Would it be suitable if we place the V4L2 FM driver at drivers/staging/ti-st/ to ? Since we don't have the common interface headers such as st.h in include/linux..


> Regards,
> 
>     Hans
> 
> -- 
> Hans Verkuil - video4linux developer - sponsored by
> TANDBERG, part of Cisco
> 


