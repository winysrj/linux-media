Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:38460 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753807Ab2ECOST convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 May 2012 10:18:19 -0400
Received: by ghrr11 with SMTP id r11so1785138ghr.19
        for <linux-media@vger.kernel.org>; Thu, 03 May 2012 07:18:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120503110156.GA11872@kipc2.localdomain>
References: <20120424122156.GA16769@kipc2.localdomain> <20120502084318.GA21181@kipc2.localdomain>
 <CAPueXH4-VSxHYjryO8kN5R-hG6seFrwCu3Kjrq4TXV=XFKLETg@mail.gmail.com>
 <20120502114430.GA4608@kipc2.localdomain> <CAPueXH7TjHo-Dx2wUCQEcDvn=5L_xobYVKrf+b6wnmLGwOSeRg@mail.gmail.com>
 <20120502133108.GA19522@kipc2.localdomain> <CAPueXH4nx=mtwF1WR+7NYG0Ze9Arne17j2Sfw439PrS9nPWFaQ@mail.gmail.com>
 <CAPueXH6Gw_YHEF47vCvkU9XJDt2BO2EjfStTBQEaswhm0RdZ-Q@mail.gmail.com> <20120503110156.GA11872@kipc2.localdomain>
From: Paulo Assis <pj.assis@gmail.com>
Date: Thu, 3 May 2012 15:17:58 +0100
Message-ID: <CAPueXH4vR0ocZwnAftS-wGemjJ45WGYOOd+bi2gOxweXwZ7G3Q@mail.gmail.com>
Subject: Re: logitech quickcam 9000 uvcdynctrl broken since kernel 3.2 - PING
To: Karl Kiniger <karl.kiniger@med.ge.com>
Cc: linux-media@vger.kernel.org, linux-uvc-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Karl Hi,
I'm setting up a libwebcam git repo in sourceforge, Martin Rubli from
logitech (the libwebcam developer), was kind enough to post me all
it's code and the old svn repo backup.
He had already done some fixes regarding the new ioctls for version
0.3, so I just need to go through that and add add them to 0.2.
I still need to check with him how he wants to handle the 0.3 version,
since it has a lot of new code ( and some extra apps ).

Regards,
Paulo

2012/5/3 Karl Kiniger <karl.kiniger@med.ge.com>:
> Hi Paulo,
>
> On Wed 120502, Paulo Assis wrote:
>> OK, so UVCIOC_CTRL_ADD is no longer available, now we have:
>>
>> UVCIOC_CTRL_MAP and UVCIOC_CTRL_QUERY, so I guess some changes are
>> needed, I'll try to fix this ASAP.
>
> compiled libwebcam-0.2.1 from Ubuntu (had to fight against
> CMake - I am almost CMake agnostic so far...) and I got the
> manual focus control in guvcview so things are definitely
> looking better now.
>
> So far I have got a focus slider and a LED1 frequency slider,
> but not a LED mode... forgot what exactly was available in
> the past.
>
> -------
> LD_LIBRARY_PATH=/usr/local/lib /usr/local/bin/uvcdynctrl -i /usr/share/uvcdynctrl/data/046d/logitech.xml
> [libwebcam] Unsupported V4L2_CID_EXPOSURE_AUTO control with a non-contiguous range of choice IDs found
> [libwebcam] Invalid or unsupported V4L2 control encountered: ctrl_id = 0x009A0901, name = 'Exposure, Auto'
> Importing dynamic controls from file
> /usr/share/uvcdynctrl/data/046d/logitech.xml.  /usr/share/uvcdynctrl/data/046d/logitech.xml: error: video0: unable to
>    map 'Pan (relative)' control. ioctl(UVCIOC_CTRL_MAP) failed with return value -1 (error 2: No such file or directory)
> /usr/share/uvcdynctrl/data/046d/logitech.xml: error: video0: unable to map 'Tilt (relative)'
>    control. ioctl(UVCIOC_CTRL_MAP) failed with return value -1 (error 2: No such file or directory)
> /usr/share/uvcdynctrl/data/046d/logitech.xml:354: error: Invalid V4L2 control type specified: 'V4L2_CTRL_TYPE_BUTTON'
> /usr/share/uvcdynctrl/data/046d/logitech.xml:368: error: Invalid V4L2 control type specified: 'V4L2_CTRL_TYPE_BUTTON'
> /usr/share/uvcdynctrl/data/046d/logitech.xml:396: error: Invalid V4L2 control type specified: 'V4L2_CTRL_TYPE_MENU'
>
> Thanks again,
> Karl
>
>>
>> Regards,
>> Paulo
>
