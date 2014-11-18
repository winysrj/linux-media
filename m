Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:52637 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753381AbaKRIkA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 03:40:00 -0500
Message-ID: <546B05B5.6010102@xs4all.nl>
Date: Tue, 18 Nov 2014 09:39:17 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Grazvydas Ignotas <notasas@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: =?UTF-8?B?UsOpbWkgRGVuaXMtQ291cm1vbnQ=?= <remi@remlab.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: (bisected) Logitech C920 (uvcvideo) stutters since 3.9
References: <CANOLnONA8jaVJNna36sNOeoKtU=+iBFEEnG2h1K+KGg5Y3q7dA@mail.gmail.com>	<fbcc6c6b4b3bb0d049a6d1871d8a79df@roundcube.remlab.net>	<36286542.DzZr56uF9K@basile.remlab.net>	<7185728.KDKlKP9htJ@avalon>	<CANOLnOMrdk9Gq+9Cv_e5cboXtbtxHoKVQdNgBvb_NcJfFT7bHQ@mail.gmail.com> <CANOLnONSBRNQORRhhSemS14rf19OHj6NOz_y__omA1gWEb-6qA@mail.gmail.com>
In-Reply-To: <CANOLnONSBRNQORRhhSemS14rf19OHj6NOz_y__omA1gWEb-6qA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/17/14 16:36, Grazvydas Ignotas wrote:
> On Thu, Nov 6, 2014 at 12:29 AM, Grazvydas Ignotas <notasas@gmail.com> wrote:
>> On Wed, Nov 5, 2014 at 4:05 PM, Laurent Pinchart
>> <laurent.pinchart@ideasonboard.com> wrote:
>>> Hi Rémi,
>>>
>>> On Tuesday 04 November 2014 22:41:44 Rémi Denis-Courmont wrote:
>>>> Le mardi 04 novembre 2014, 15:42:37 Rémi Denis-Courmont a écrit :
>>>>> Le 2014-11-04 14:58, Sakari Ailus a écrit :
>>>>>>>> Have you tried with a different application to see if the problem
>>>>>>>> persists?
>>>>>>>
>>>>>>> Tried mplayer and cheese now, and it seems they are not affected, so
>>>>>>> it's an issue with vlc. I wonder why it doesn't like newer flags..
>>>>>>>
>>>>>>> Ohwell, sorry for the noise.
>>>>>>
>>>>>> I guess the newer VLC could indeed pay attention to the monotonic
>>>>>> timestamp flag. Remi, any idea?
>>>>>
>>>>> VLC takes the kernel timestamp, if monotonic, since version 2.1.
>>>>> Otherwise, it generates its own inaccurate timestamp. So either that
>>>>> code is wrong, or the kernel timestamps are.
>>>>
>>>> From a quick check with C920, the timestamps from the kernel are quite
>>>> jittery, and but seem to follow a pattern. When requesting a 10 Hz frame
>>>> rate, I actually get a frame interval of about 8/9 (i.e. 89ms) jumping to
>>>> 1/3 every approximately 2 seconds.
>>>>
>>>> From my user-space point of view, this is a kernel issue. The problem
>>>> probably just manifests when both VLC and Linux versions support monotonic
>>>> timestamps.
>>>>
>>>> Whether the root cause is in the kernel, the device driver or the firmware,
>>>> I can´t say.
>>>
>>> Would you be able to capture images from the C920 using yavta, with the
>>> uvcvideo trace parameter set to 4096, and send me both the yavta log and the
>>> kernel log ? Let's start with a capture sequence of 50 to 100 images.
>>
>> I've done 2 captures, if that helps:
>> http://notaz.gp2x.de/tmp/c920_yavta/
>>
>> The second one was done using low exposure setting, which allows
>> camera to achieve higher frame rate.
> 
> So, has anyone had time to look at these?

Laurent is on vacation for one more week. So you'll have to wait until
he's back and has time to process his no doubt considerable pile of email.

If you haven't heard anything from him by the end of next week, then try
another ping just in case this got buried.

Regards,

	Hans
