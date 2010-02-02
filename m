Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:54840 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab0BBUky (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Feb 2010 15:40:54 -0500
Message-ID: <4B688DD0.20105@freemail.hu>
Date: Tue, 02 Feb 2010 21:40:48 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: ERRORS, 2.6.16-2.6.21:
 ERRORS
References: <201002021947.o12JlGvF076836@smtp-vbr5.xs4all.nl>
In-Reply-To: <201002021947.o12JlGvF076836@smtp-vbr5.xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Hans Verkuil wrote:
> This message is generated daily by a cron job that builds v4l-dvb for
> the kernels and architectures in the list below.
> 
> [snip]
> Detailed results are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Tuesday.log

> linux-2.6.16.62-i686: ERRORS
>
> /home/hans/work/build/v4l-dvb-master/v4l/gspca.c:48:29: error: linux/usb/input.h: No such file or directory
> /home/hans/work/build/v4l-dvb-master/v4l/gspca.c: In function 'gspca_input_connect':
> /home/hans/work/build/v4l-dvb-master/v4l/gspca.c:182: warning: implicit declaration of function 'usb_to_input_id'
> /home/hans/work/build/v4l-dvb-master/v4l/gspca.c:186: error: request for member 'parent' in something not a structure or union
> /home/hans/work/build/v4l-dvb-master/v4l/gspca.c:192: error: request for member 'parent' in something not a structure or union

> linux-2.6.17.14-i686: ERRORS
>
> /home/hans/work/build/v4l-dvb-master/v4l/gspca.c:48:29: error: linux/usb/input.h: No such file or directory
> /home/hans/work/build/v4l-dvb-master/v4l/gspca.c: In function 'gspca_input_connect':
> /home/hans/work/build/v4l-dvb-master/v4l/gspca.c:182: warning: implicit declaration of function 'usb_to_input_id'
> /home/hans/work/build/v4l-dvb-master/v4l/gspca.c:186: error: request for member 'parent' in something not a structure or union
> /home/hans/work/build/v4l-dvb-master/v4l/gspca.c:192: error: request for member 'parent' in something not a structure or union

> linux-2.6.18.8-i686: ERRORS
>
> /home/hans/work/build/v4l-dvb-master/v4l/gspca.c: In function 'gspca_input_connect':
> /home/hans/work/build/v4l-dvb-master/v4l/gspca.c:186: error: request for member 'parent' in something not a structure or union
> /home/hans/work/build/v4l-dvb-master/v4l/gspca.c:192: error: request for member 'parent' in something not a structure or union

> linux-2.6.19.7-i686: ERRORS
>
> /home/hans/work/build/v4l-dvb-master/v4l/gspca.c: In function 'gspca_input_connect':
> /home/hans/work/build/v4l-dvb-master/v4l/gspca.c:186: error: 'struct input_dev' has no member named 'dev'
> /home/hans/work/build/v4l-dvb-master/v4l/gspca.c:192: error: 'struct input_dev' has no member named 'dev'

> linux-2.6.20.21-i686: ERRORS
>
> /home/hans/work/build/v4l-dvb-master/v4l/gspca.c: In function 'gspca_input_connect':
> /home/hans/work/build/v4l-dvb-master/v4l/gspca.c:186: error: 'struct input_dev' has no member named 'dev'
> /home/hans/work/build/v4l-dvb-master/v4l/gspca.c:192: error: 'struct input_dev' has no member named 'dev'

> linux-2.6.21.7-i686: ERRORS
>
> /home/hans/work/build/v4l-dvb-master/v4l/gspca.c: In function 'gspca_input_connect':
> /home/hans/work/build/v4l-dvb-master/v4l/gspca.c:186: error: 'struct input_dev' has no member named 'dev'
> /home/hans/work/build/v4l-dvb-master/v4l/gspca.c:192: error: 'struct input_dev' has no member named 'dev'


It seems that the camera button input support is not compatible with kernel
version 2.6.21.7 and before because of different reasons.

1. Between 2.6.16.62 and 2.6.17.14: there is no linux/usb/input.h .
   The linux/usb/input.h was earlier linux/usb_input.h, see
   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=history;f=include/linux/usb/input.h;h=0e010b220e85b3f9ea861f2ab009809d17014910;hb=HEAD

2. Between 2.6.16.62 and 2.6.17.14: there is no 'usb_to_input_id'. This was
   introduced with the commit 16a334c0de5a94b1d10a1ac9a33f4dedac89a075, exactly
   in the same place: in linux/usb_input.h .
   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=16a334c0de5a94b1d10a1ac9a33f4dedac89a075

3. Between 2.6.16.62 and 2.6.18.8: there is no 'parent' field of struct device.
   The struct device is defined in linux/device.h . I couldn't find what exactly
   happened here, yet.
   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=history;f=include/linux/device.h;h=a62799f2ab0019863d30e4f55f7677c5bd97d124;hb=HEAD

4. Between linux-2.6.19.7 and 2.6.21.7: 'struct input_dev' has no member named 'dev'.
   The 'dev' member was introduced with commit 9657d75c5f0f7d0a9cb507521d3ad1436aea28c9
   when a convert was made from class devices to standard devices.
   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9657d75c5f0f7d0a9cb507521d3ad1436aea28c9

The main question is that does gspca need to support kernel version 2.6.21.7
and before? If yes, then should the input support disabled in 2.6.21.7 and before?

Regards,

	Márton Németh
