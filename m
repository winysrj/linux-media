Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40746 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752507AbZEZMIn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 08:08:43 -0400
Date: Tue, 26 May 2009 14:08:53 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans de Goede <hdegoede@redhat.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	moinejf@free.fr
Subject: Re: gspca: Logitech QuickCam Messenger worked last with external
 gspcav1-20071224
In-Reply-To: <4A1BD76E.4020603@redhat.com>
Message-ID: <Pine.LNX.4.64.0905261404290.4810@axis700.grange>
References: <Pine.LNX.4.64.0905261335050.4810@axis700.grange>
 <4A1BD76E.4020603@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 26 May 2009, Hans de Goede wrote:

> First of all, which app are you using to test the cam ? And are you using that
> app in combination with libv4l ?

xawtv, no, it doesn't use libv4l, but it works with the old 
gspcav1-20071224. Ok, maybe it used a different v4l version, but I have 
v4l1_compat loaded.

> Also why do you say the original driver used to identify it as a tas5130cxx,
> the dmesg lines you pasted from gspcav1 also say it is a HV7131R

In the old sources you see

	switch (vendor) {
	...
	case 0x046d:		/* Logitech Labtec */
	...
		switch (product) {
		...
		case 0x08da:
			spca50x->desc = QCmessenger;
			spca50x->bridge = BRIDGE_ZC3XX;
			spca50x->sensor = SENSOR_TAS5130CXX;
			break;

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
