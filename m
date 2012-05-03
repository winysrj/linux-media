Return-path: <linux-media-owner@vger.kernel.org>
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:49728 "EHLO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab2ECLCE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2012 07:02:04 -0400
Date: Thu, 3 May 2012 13:01:56 +0200
From: Karl Kiniger <karl.kiniger@med.ge.com>
To: Paulo Assis <pj.assis@gmail.com>
Cc: linux-media@vger.kernel.org, linux-uvc-devel@lists.sourceforge.net
Subject: Re: logitech quickcam 9000 uvcdynctrl broken since kernel 3.2 - PING
Message-ID: <20120503110156.GA11872@kipc2.localdomain>
References: <20120424122156.GA16769@kipc2.localdomain>
 <20120502084318.GA21181@kipc2.localdomain>
 <CAPueXH4-VSxHYjryO8kN5R-hG6seFrwCu3Kjrq4TXV=XFKLETg@mail.gmail.com>
 <20120502114430.GA4608@kipc2.localdomain>
 <CAPueXH7TjHo-Dx2wUCQEcDvn=5L_xobYVKrf+b6wnmLGwOSeRg@mail.gmail.com>
 <20120502133108.GA19522@kipc2.localdomain>
 <CAPueXH4nx=mtwF1WR+7NYG0Ze9Arne17j2Sfw439PrS9nPWFaQ@mail.gmail.com>
 <CAPueXH6Gw_YHEF47vCvkU9XJDt2BO2EjfStTBQEaswhm0RdZ-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPueXH6Gw_YHEF47vCvkU9XJDt2BO2EjfStTBQEaswhm0RdZ-Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Paulo,

On Wed 120502, Paulo Assis wrote:
> OK, so UVCIOC_CTRL_ADD is no longer available, now we have:
> 
> UVCIOC_CTRL_MAP and UVCIOC_CTRL_QUERY, so I guess some changes are
> needed, I'll try to fix this ASAP.

compiled libwebcam-0.2.1 from Ubuntu (had to fight against
CMake - I am almost CMake agnostic so far...) and I got the
manual focus control in guvcview so things are definitely
looking better now.

So far I have got a focus slider and a LED1 frequency slider,
but not a LED mode... forgot what exactly was available in
the past.

-------
LD_LIBRARY_PATH=/usr/local/lib /usr/local/bin/uvcdynctrl -i /usr/share/uvcdynctrl/data/046d/logitech.xml
[libwebcam] Unsupported V4L2_CID_EXPOSURE_AUTO control with a non-contiguous range of choice IDs found
[libwebcam] Invalid or unsupported V4L2 control encountered: ctrl_id = 0x009A0901, name = 'Exposure, Auto'
Importing dynamic controls from file
/usr/share/uvcdynctrl/data/046d/logitech.xml.  /usr/share/uvcdynctrl/data/046d/logitech.xml: error: video0: unable to
    map 'Pan (relative)' control. ioctl(UVCIOC_CTRL_MAP) failed with return value -1 (error 2: No such file or directory)
/usr/share/uvcdynctrl/data/046d/logitech.xml: error: video0: unable to map 'Tilt (relative)'
    control. ioctl(UVCIOC_CTRL_MAP) failed with return value -1 (error 2: No such file or directory)
/usr/share/uvcdynctrl/data/046d/logitech.xml:354: error: Invalid V4L2 control type specified: 'V4L2_CTRL_TYPE_BUTTON'
/usr/share/uvcdynctrl/data/046d/logitech.xml:368: error: Invalid V4L2 control type specified: 'V4L2_CTRL_TYPE_BUTTON'
/usr/share/uvcdynctrl/data/046d/logitech.xml:396: error: Invalid V4L2 control type specified: 'V4L2_CTRL_TYPE_MENU'

Thanks again,
Karl

> 
> Regards,
> Paulo

