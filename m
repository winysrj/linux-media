Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753714Ab2ERMax (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 08:30:53 -0400
Message-ID: <4FB640F9.9030703@redhat.com>
Date: Fri, 18 May 2012 14:30:49 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [PATCH 0/3] gspca: kinect cleanup, ov534 port to control framework
References: <1337204566-2212-1-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1337204566-2212-1-git-send-email-ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the patches. I've added them all to my tree, so
they will be included in my next pull-req. In the mean time
you can find them (unmodified) here:

http://git.linuxtv.org/hgoede/gspca.git/shortlog/refs/heads/media-for_v3.5-wip



On 05/16/2012 11:42 PM, Antonio Ospite wrote:
> Hi,
>
> the first patch just removes traces of the gspca control handling
> mechanism from the kinect driver; this driver does not have any
> controls. The change is trivial and can be applied right away, or
> postponed to when the gspca_main code is removed, you decide.
>
> The second patch removes the dependency between auto gain and auto white
> balance, I'd like to hear Jean-Francois on this, the webcam (the ov772x
> sensor) is able to set the two parameters independently and the user can
> see the difference of either, is there a reason why we were preventing
> the user from doing so before?
>
> The third patch is the conversion of the ov534 subdriver to the v4l2
> control framework, I tested the code with a PS3 Eye (ov772x sensor) and
> it works fine (now disabling automatic exposure works too, yay), maybe
> someone else can give it a run on a webcam with OV767x.
>
> NOTE: in patch 3, in sd_init_controls(), I left multiple checks
>
> 	if (sd->sensor == SENSOR_OV772x)
>
> just to preserve the order the controls were declared in "struct sd", if
> you feel the order is not that important I can aggregate the checks,
> just let me know, it just looked neater to me this way.
>
>
>  From a purely aesthetic point of view maybe the gspca mechanism of
> defining controls was prettier, more declarative, but the control
> framework really looks "more correct" even from userspace, qv4l2 can now
> display labels of control classes in tabs automatically while before we
> had empty labels, disabled controls in clusters work beautifully, and
> disabled controls with associated automatic settings can show the value
> calculated by the hardware on every update, very instructive if not
> super-useful.

I'm glad to hear you like the control framework.

Regards,

Hans


>
> Thanks,
>     Antonio
>
> Antonio Ospite (3):
>    gspca - kinect: remove traces of gspca control handling
>    gspca - ov534: make AGC and AWB controls independent
>    gspca - ov534: convert to v4l2 control framework
>
>   drivers/media/video/gspca/kinect.c |    9 -
>   drivers/media/video/gspca/ov534.c  |  590 ++++++++++++++++--------------------
>   2 files changed, 261 insertions(+), 338 deletions(-)
>
