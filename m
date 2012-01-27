Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544Ab2A0OSL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 09:18:11 -0500
Message-ID: <4F22B1E8.7050303@redhat.com>
Date: Fri, 27 Jan 2012 12:17:12 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: RFC: removal of video/radio/vbi_nr module options?
References: <201201270821.49381.hverkuil@xs4all.nl> <CAGoCfiynca-oSRnunwsa_y9xamD3Bn6Xnr40LUsmVcbmo6jkhA@mail.gmail.com>
In-Reply-To: <CAGoCfiynca-oSRnunwsa_y9xamD3Bn6Xnr40LUsmVcbmo6jkhA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 27-01-2012 11:36, Devin Heitmueller escreveu:
> On Fri, Jan 27, 2012 at 2:21 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi all,
>>
>> I'm working on cleaning up some old radio drivers and while doing that I
>> started wondering about the usefulness of the radio_nr module option (and
>> the corresponding video_nr/vbi_nr module options for video devices).
>>
>> Is that really still needed? It originates from pre-udev times, but it seems
>> fairly useless to me these days.
> 
> I can tell you from lurking in the mythtv-users IRC channel, that
> there are still many, many users of video_nr.  Yes, they can in theory
> accomplish the same thing through udev, but they aren't today, and if
> you remove the functionality you'll have lots of users scambling to
> figure out why stuff that previously worked is now broken.  This tends
> to be more an issue with tuner cards than uvc devices, presumably
> because MythTV starts up unattended and you're more likely to have
> more than one capture device.

This were never needed by USB devices. In general, due to USB bandwidth
constraints, users can't plug more than one or a few devices on a USB bus.

MythTV is not the only usercase for it. Surveillance system can have
multiple devices in the same PCI card, and it is not uncommon to find
hardware with multiple PCI multi-input cards. Several of those boards
don't even have eeprom.

Regards,
Mauro

