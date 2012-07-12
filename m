Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44163 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab2GLIII (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 04:08:08 -0400
Received: by eaak11 with SMTP id k11so634462eaa.19
        for <linux-media@vger.kernel.org>; Thu, 12 Jul 2012 01:08:06 -0700 (PDT)
Message-ID: <4FFE85E4.7030609@gmail.com>
Date: Thu, 12 Jul 2012 10:08:04 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: KS2012 <ksummit-2012-discuss@lists.linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Media system Summit
References: <1341994155.3522.16.camel@dabdike.int.hansenpartnership.com> <4FFE41F0.4010602@redhat.com>
In-Reply-To: <4FFE41F0.4010602@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 07/12/2012 05:18 AM, Mauro Carvalho Chehab wrote:
> Em 11-07-2012 05:09, James Bottomley escreveu:
>> Hi All,
>>
>> We have set aside the second day of the kernel summit (Tuesday 28
>> August) as mini-summit day.  So far we have only the PCI mini summit on
>> this day
> 
> Not sure what happened (or maybe my proposal were not clear enough), but
> I've submitted a proposal to have a media system summit on KS/2011.
> Last year was very productive for media developers, so we'd like to do
> it again ;)
> 
> 
> Message-ID:<4FEC74AB.6070501@redhat.com>
> Date: Thu, 28 Jun 2012 12:13:47 -0300
> From: Mauro Carvalho Chehab<mchehab@redhat.com>
> 
> [Ksummit-2012-discuss] [ATTEND] media subsystem
> 
> I'd like to have media subsystem discussions this year's at kernel summit.
> The media subsystem is one of the most active driver subsystem, and there are lots of
> things there that require face-to-face discussions, not only between subsystem developers,
> but also with other maintainers. In special, during KS/2011, it was identified the need
> of interacting with video and audio system people, in order to solve some common issues,
> like HDMI CEC and audio/video synchronization.
> 
> The increasing complexity of SoC designs used by media devices requires API
> extensions at the media APIs in order to proper expose and control all hardware
> functionality on a standard way. A new API to better allow negotiating userspace
> and Kernelspace capabilities seem to be required.
> 
> More discussions with regards to shared resources locking is needed, on devices that
> implement multiple API's, but not a the same time.
> 
> The incompatibility between udev-182 and the existing drivers will also require lots
> of discussions, as that affects 64 media drivers, and changing them to comply with
> the current requirement of using request_firmware_nowait() won't work on several
> drivers. So, a solution (or a set of solutions) needs to be found, in order to fix
> such incompatibility.

I'd like to add a "Common device tree bindings for media devices" topic to
the agenda for consideration.

There were some activities on creating device tree bindings for Samsung and
SH Mobile SoCs but this didn't really kick off yet and a face to face discussions
could help to bring device tree support in media subsystem to the level many
other subsystems already have.

--

Thanks,
Sylwester
