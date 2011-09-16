Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:40476 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712Ab1IPGdF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Sep 2011 02:33:05 -0400
Date: Fri, 16 Sep 2011 08:33:02 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Subject: Re: Question about USB interface index restriction in gspca
Message-ID: <20110916083302.1deb338e@tele>
In-Reply-To: <4E727251.9030308@googlemail.com>
References: <4E6FAB94.2010007@googlemail.com>
	<20110914082513.574baac2@tele>
	<4E727251.9030308@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 15 Sep 2011 23:46:57 +0200
Frank Schäfer <fschaefer.oss@googlemail.com> wrote:

> > For webcam devices, the interface class is meaningful only when set to
> > USB_CLASS_VIDEO (UVC). Otherwise, I saw many different values.
> 
> Does that mean that there are devices out in the wild that report for 
> example USB_CLASS_WIRELESS_CONTROLLER for the video interface ???
> 
> > For video on a particular interface, the subdriver must call the
> > function gspca_dev_probe2() as this is done in spca1528 and xirlink_cit.
>
> Hmm, sure, that would work...
> But wouldn't it be better to improve the interface check and merge the 
> two probing functions ?
> The subdrivers can decide which interfaces are (not) probed and the 
> gspca core does plausability checks (e.g. bulk/isoc endpoint ? usb class ?).

Generally, the first interface is the video device, and the function
gspca_dev_probe() works well enough.

The function gspca_dev_probe2() is used by only 2 subdrivers and the
way to find the correct interface is not easy. For example, the webcam
047d:5003 (subdriver spca1528) has 3 interfaces (class vendor specific).
The 1st one has only one altsetting with only one interrupt endpoint,
the 2nd one has 8 altsettings, each with only one isochronous endpoint,
and the last one has one altsetting with 3 endpoints (bulk in, bulk out
and interrupt). At the first glance, it is easy to know the right
interface, but writing generic code to handle such webcams seems rather
complicated.

So, if your webcam is in the 99.99% which use the interface 0, use
gspca_dev_probe(), otherwise, YOU know the right interface, so, call
gspca_dev_probe2().

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
