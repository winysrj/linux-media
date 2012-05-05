Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755784Ab2EEPFc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 May 2012 11:05:32 -0400
Message-ID: <4FA541B8.4080507@redhat.com>
Date: Sat, 05 May 2012 17:05:28 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 1/7] gspca: allow subdrivers to use the control
 framework.
References: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl> <ea7e986dc0fa18da12c22048e9187e9933191d3d.1335625085.git.hans.verkuil@cisco.com> <4FA4DA05.5030001@redhat.com> <201205051114.31531.hverkuil@xs4all.nl> <4FA53CD2.1010706@redhat.com>
In-Reply-To: <4FA53CD2.1010706@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/05/2012 04:44 PM, Hans de Goede wrote:
> Hi,
>
> On 05/05/2012 11:14 AM, Hans Verkuil wrote:
>> So you get:
>>
>> vidioc_foo()
>> lock(mylock)
>> v4l2_ctrl_s_ctrl(ctrl, val)
>> s_ctrl(ctrl, val)
>> lock(mylock)
>
> Easy solution here, remove the first lock(mylock), since we are not using v4l2-dev's
> locking, we are the one doing the first lock, and if we are going to call v4l2_ctrl_s_ctrl
> we should simply not do that!
>
> Now I see that we are doing exactly that in for example vidioc_g_jpegcomp in gspca.c, so
> we should stop doing that. We can make vidioc_g/s_jpegcomp only do the usb locking if
> gspca_dev->vdev.ctrl_handler == NULL, and once all sub drivers are converted simply remove
> it. Actually I'm thinking about making the jpegqual control part of the gspca_dev struct
> itself and move all handling of vidioc_g/s_jpegcomp out of the sub drivers and into
> the core.

Here is an updated version of this patch implementing this approach for
vidioc_g/s_jpegcomp. We may need to do something similar in other places, although I cannot
think of any such places atm,

Regards,

Hans
