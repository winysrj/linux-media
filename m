Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:23519 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbZDTIH1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 04:07:27 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1238522ywb.1
        for <linux-media@vger.kernel.org>; Mon, 20 Apr 2009 01:07:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0904200921090.4403@axis700.grange>
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
	 <aec7e5c30904170040p6ec1721aj6885ef16573cd484@mail.gmail.com>
	 <Pine.LNX.4.64.0904170950320.5119@axis700.grange>
	 <aec7e5c30904170331n6da85695gdd6da8d6a42eacf1@mail.gmail.com>
	 <Pine.LNX.4.64.0904171235010.5119@axis700.grange>
	 <aec7e5c30904200014n2d8cdcfeud23f2b6b221f9fad@mail.gmail.com>
	 <Pine.LNX.4.64.0904200921090.4403@axis700.grange>
Date: Mon, 20 Apr 2009 17:00:53 +0900
Message-ID: <aec7e5c30904200100wb117328sb97ea0262d163547@mail.gmail.com>
Subject: Re: [PATCH 0/5] soc-camera: convert to platform device
From: Magnus Damm <magnus.damm@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 20, 2009 at 4:22 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Mon, 20 Apr 2009, Magnus Damm wrote:
>> On Fri, Apr 17, 2009 at 7:43 PM, Guennadi Liakhovetski
>> <g.liakhovetski@gmx.de> wrote:
>> > On Fri, 17 Apr 2009, Magnus Damm wrote:
>> >> On Fri, Apr 17, 2009 at 4:51 PM, Guennadi Liakhovetski
>> >> <g.liakhovetski@gmx.de> wrote:
>> >> > On Fri, 17 Apr 2009, Magnus Damm wrote:
>> >> >> On Wed, Apr 15, 2009 at 9:17 PM, Guennadi Liakhovetski
>> >> >> <g.liakhovetski@gmx.de> wrote:
>> >> >> > This patch series is a preparation for the v4l2-subdev conversion. Please,
>> >> >> > review and test. My current patch-stack in the form of a
>> >> >> > (manually-created) quilt-series is at
>> >> >> > http://www.open-technology.de/download/20090415/ based on linux-next
>> >> >> > history branch, commit ID in 0000-base file. Don't be surprised, that
>> >> >> > patch-set also contains a few not directly related patches.

>> Today I've tested the following on top of linux-2.6 (stable 2.6.30-rc)
>> d91dfbb41bb2e9bdbfbd2cc7078ed7436eab027a
>>
>> 0033-soc-camera-host-driver-cleanup.patch
>> 0034-soc-camera-remove-an-extra-device-generation-from-s.patch
>> 0035-soc-camera-simplify-register-access-routines-in-mul.patch
>>
>> So far OK.
>> However, applying 0036- or v2 from the mailing list results in rejects
>> (probably because linux-next vs linux-2.6 differences) but the files
>> should not affect Migo-R.
>>
>> So with 0036 or v2 applied it builds ok for Migo-R, but I can't open
>> /dev/video0 for some reason. Reverting the patch and only using
>> 0033->0035 above results in ok /dev/video0 opening.
>
> Did you have video drivers build in or as modules? If modules - in which
> order did you load them? Unfortunately, at the moment it might be
> important:-( What's in dmesg after loading all drivers?

They are compiled-in. No modules.

>> What are your dependencies?
>>
>> I'll try out your 20090415/series on top of the matching linux-next for now.

So linux-next fa169db2b277ebafa466d625ed2d16b2d2a4bc82 with
20090415/series applies without any rejects and compiles just fine for
Migo-R. However, during runtime I experience the same problem as with
2.6.30-rc plus 0033->0035 + 0036 or v2:

/ # /mplayer -flip -vf mirror -quiet tv://
MPlayer dev-SVN-rUNKNOWN-4.2-SH4-LINUX_v0701 (C) 2000-2008 MPlayer Team

Playing tv://.
TV file format detected.
Selected driver: v4l2
 name: Video 4 Linux 2 input
 author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
 comment: first try, more to come ;-)
v4l2: unable to open '/dev/video0': No such device or address
v4l2: ioctl set mute failed: Bad file descriptor
v4l2: 0 frames successfully processed, 0 frames dropped.


Exiting... (End of file)
/ #

Removing 0036 unbreaks the code and mplayer/capture.c works as expected.

I also tried out v2 of your soc-camera-platform patch but it still
does not work.

Can you please test on your Migo-R board? I'd be happy to assist you
in setting up your environment.

/ magnus
