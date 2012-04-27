Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab2D0LP1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 07:15:27 -0400
Message-ID: <4F9A7A31.4050303@redhat.com>
Date: Fri, 27 Apr 2012 12:51:29 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Antonio Ospite <ospite@studenti.unina.it>,
	linux-media@vger.kernel.org,
	=?UTF-8?B?RXJpayBBbmRyw6lu?= <erik.andren@gmail.com>
Subject: Re: [RFC PATCH 3/3] [media] gspca - main: implement vidioc_g_ext_ctrls
 and vidioc_s_ext_ctrls
References: <20120418153720.1359c7d2f2a3efc2c7c17b88@studenti.unina.it> <1334935152-16165-1-git-send-email-ospite@studenti.unina.it> <1334935152-16165-4-git-send-email-ospite@studenti.unina.it> <201204271020.23880.hverkuil@xs4all.nl> <20120427112443.7edd32f3@tele>
In-Reply-To: <20120427112443.7edd32f3@tele>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04/27/2012 11:24 AM, Jean-Francois Moine wrote:
> On Fri, 27 Apr 2012 10:20:23 +0200
> Hans Verkuil<hverkuil@xs4all.nl>  wrote:
>
>> I might have some time (no guarantees yet) to help with this. It would
>> certainly be interesting to add support for the control framework in the
>> gspca core. Hmm, perhaps that's a job for the weekend...
>
> Hi Hans,
>
> I hope you will not do it! The way gspca treats the controls is static,
> quick and very small. The controls in the subdrivers ask only for the
> declaration of the controls and functions to send the values to the
> webcams. Actually, not all subdrivers have been converted to the new
> gspca control handling, but, when done, it will save more memory.

Actually I've moving gspca over to the control framework on my to-do
list. This will allows us to remove hacks like we have in sonixb.c for
coarse exposure / fine exposure controls. More in general it will allow
(in an easy way) to have per sensor control min/max/step values.

But the most important reason for me to want to use the control framework
in gspca is to get support for control events. Which allow a control-panel
app to dynamically update its display when settings are changed to some
other way (ie another control app, or software autogain).

I do plan to do this in way so that we can do this one subdriver at a
time. I've no idea when I'll get around to doing the first driver
though :)

Regards,

Hans
