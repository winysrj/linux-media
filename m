Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8FFRI7c028589
	for <video4linux-list@redhat.com>; Mon, 15 Sep 2008 11:27:18 -0400
Received: from mgw-mx09.nokia.com (smtp.nokia.com [192.100.105.134])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8FFPkvm023570
	for <video4linux-list@redhat.com>; Mon, 15 Sep 2008 11:25:46 -0400
Message-ID: <48CE7E65.1000301@nokia.com>
Date: Mon, 15 Sep 2008 18:25:25 +0300
From: Sakari Ailus <sakari.ailus@nokia.com>
MIME-Version: 1.0
To: ext Hans Verkuil <hverkuil@xs4all.nl>
References: <48C55737.4080804@nokia.com>
	<200809082218.14332.hverkuil@xs4all.nl>
In-Reply-To: <200809082218.14332.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Zutshi Vimarsh \(Nokia-D-MSW/Helsinki\)" <vimarsh.zutshi@nokia.com>,
	Linux and Kernel Video <video4linux-list@redhat.com>,
	Toivonen Tuukka Olli Artturi <tuukka.o.toivonen@nokia.com>
Subject: Re: [PATCH 0/7] V4L changes for OMAP 3 camera
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

ext Hans Verkuil wrote:
> Hi Sakari,

Hello again, Hans!

(I'm removing Mohit since he's not involved with OMAP 3 camera driver 
anymore, as far as I understand.)

> Well, here they are:
> 
> Patch 1/7 seems to be missing in action. Can you post that one again?

Oops. I thought I posted this again but it hasn't appeared on the list.

I'll repost that soon.

> Patch 2/7: Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> Patch 3/7: Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> Patch 4/7: I'm having problems with this one. Shouldn't it be better to 
> make this a driver-private ioctl? And then that ioctl can actually 
> return a struct containing those settings, rather than a eeprom dump. 
> It is highly device specific, after all, so let the device extract and 
> return the useful information instead of requiring an application to do 
> that.

Laurent Pinchart suggested to make this available through sysfs. I guess 
this is what we'll do instead for now, at least, as I don't have enough 
information on different sensors and what they might have in their EEPROMs.

> Patch 5/7: Please add the explanation regarding possible transitions as 
> comments to the header. Also, why is the RESUME needed? You have three 
> states: off, standby, on. Resume is not a state, it is a state 
> transition. It seems out of place.

These are not actually states but commands. All except resume are also 
states. Maybe that's a bit confusing which is bad, I suppose. Anyway, 
this way the slave driver does not need to know its last power state as 
long as it supports these state transitions.

I'll add more documentation to v4l2-int-device.h.

> Patch 6/7: Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> Patch 7/7: Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

Great!

> Note: as I have stated in earlier posts, I'm not happy about having 
> multiple interfaces for sensors (soc-camera vs v4l2-int-device). 
> However, since there is no replacement available at the moment I'm not 
> going to hold back this effort.

Thanks.

(I'll try to pay more attention to v4l2_client and v4l-dvb-ng tree. :))

-- 
Sakari Ailus
sakari.ailus@nokia.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
