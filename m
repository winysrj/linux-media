Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40807 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758699Ab1CCVTn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2011 16:19:43 -0500
Received: by qyg14 with SMTP id 14so1430893qyg.19
        for <linux-media@vger.kernel.org>; Thu, 03 Mar 2011 13:19:43 -0800 (PST)
References: <20110302181404.6406a3d2@realh.co.uk> <3A464BCE-1E30-48D3-B275-99815E1A8983@wilsonet.com> <20110302204610.464785f5@toddler> <CC82695C-F23E-4569-AAF8-091372D2FFE9@wilsonet.com> <20110303174055.553a8791@realh.co.uk>
In-Reply-To: <20110303174055.553a8791@realh.co.uk>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <95E7EC17-4C7C-45E2-A37E-1A2FA0D0EFBC@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: <linux-media@vger.kernel.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: Hauppauge "grey" remote not working in recent kernels
Date: Thu, 3 Mar 2011 16:19:54 -0500
To: Tony Houghton <h@realh.co.uk>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mar 3, 2011, at 12:40 PM, Tony Houghton wrote:

> On Wed, 2 Mar 2011 17:30:29 -0500
> Jarod Wilson <jarod@wilsonet.com> wrote:
> 
>> On Mar 2, 2011, at 3:46 PM, Tony Houghton wrote:
>> 
>>> On Wed, 2 Mar 2011 13:39:32 -0500
>>> Jarod Wilson <jarod@wilsonet.com> wrote:
>>> 
>>>> There's a pending patchset for ir-kbd-i2c and the hauppauge key tables
>>>> that should get you back in working order.
>>> 
>>> OK, thanks. Is it possible to download the patch(es) and apply it to a
>>> current kernel or is that a bit complicated?
>> 
>> Not sure how doable it is, don't recall if they're dependent on other
>> changes going into 2.6.38 or not. The patches are still in the
>> linux-media patchwork db (I'm actually merging and testing them in my
>> own tree tonight or tomorrow).
>> 
>> https://patchwork.kernel.org/project/linux-media/list/
> 
> Thanks. I think I'll have to leave it to the experts. I tried applying
> all the patches from Mauro Carvalho Chehab's set of 13, using the guide
> at <http://wiki.debian.org/HowToRebuildAnOfficialDebianKernelPackage>
> but the guide is slightly out of date and I'm not sure if I even got the
> patches applied. If they did apply they din't work :-(.
> 
> On top of that the patches won't apply to 2.6.37 and there doesn't seem
> to be a way to build a linux-kbuild deb for pre-release kernels, so I
> can't easily build an nvidia module and nouveau fails to get the correct
> resolutions on the target system :-(.


Another option:

You could build just the latest v4l/dvb drivers with those patch added,
atop your running kernel, using the media_build system.

http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

Also, note that there's actually a patch 14 also (there are two patches
in patchwork with the same 13/13 title, but one is a follow-on 14th
patch that you'd also need).

-- 
Jarod Wilson
jarod@wilsonet.com



