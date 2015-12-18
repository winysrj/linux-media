Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59468 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbbLRWe6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 17:34:58 -0500
Subject: Re: Media Controller patches
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <20151210183411.3d15a819@recife.lan>
 <20151211190522.4e4d62a0@recife.lan> <20151213091250.00df9420@recife.lan>
 <20151216154337.58f37568@recife.lan> <56720C1A.70103@osg.samsung.com>
 <20151217001924.12c54a34@recife.lan> <20151217090606.6c241fa4@recife.lan>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Shuah Khan <shuah.kh@samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56748A04.1050800@osg.samsung.com>
Date: Fri, 18 Dec 2015 15:34:44 -0700
MIME-Version: 1.0
In-Reply-To: <20151217090606.6c241fa4@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/17/2015 04:06 AM, Mauro Carvalho Chehab wrote:
> Em Thu, 17 Dec 2015 00:19:24 -0200
> Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:
> 
>> Em Wed, 16 Dec 2015 18:12:58 -0700
>> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
>>
>>> On 12/16/2015 10:43 AM, Mauro Carvalho Chehab wrote:
>>>> Em Sun, 13 Dec 2015 09:12:50 -0200
>>>> Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:
>>>>
>>>
>>>>
>>>> As far as I know, all pending items for Kernel 4.5 merge are
>>>> complete. I should be moving the remaining patches from my
>>>> experimental tree:
>>>> 	git://linuxtv.org/mchehab/experimental.git media-controller-rc4
>>>>
>>>> to the media-controller topic branch by the end of this week, if
>>>> nothing pops up.
>>>
>>> Hi Mauro,
>>>
>>> I don't like the flat graph I am seeing on experimental rc4
>>> with all the pending patches for 4.5. I am attaching two
>>> media graphs generated on au0828 on rc3 and rc4. Something
>>> is off with rc4.  I used the latest mc_nextgen_test tool
>>> to generate the graphs.
>>
>> I guess this problem is due to the patch changed the object ID 
>> to use a single number range:
>> 	http://git.linuxtv.org/mchehab/experimental.git/commit/?h=media-controller-rc4&id=9c04bcb45824fd8e5231f6f26269b57830c1f34d
>>
>> We likely need to change the userspace tool due to that, but I'll
>> take a look on it tomorrow.
> 
> Yes, this was the culprit. I changed the ID to 64 bits, but this
> was actually a bad idea. This got fixed on this patch:
> 
> 	https://patchwork.linuxtv.org/patch/32348/
> 
> I replaced the old patch to the new one on my -rc4 branch:
> 
> 	git://linuxtv.org/mchehab/experimental.git media-controller-rc4
> 

Graph looks good. Update on ALSA work. I rebased on
media-controller rc3 and test the 24 patch series.
I was hoping to wrap up reabse on media-controller rc4
and send patches out today.

However, I ran into problems on on patch 18 switches
au0828 to using managed media controller media_device.
The change to split media device registration into
init and register phases is posing some problems with
my approach for coordinating media device init and register
by au0828 bridge driver and smd-usb-audio. It can be easily
solved, I do have to rethink the logic and re-do the code
in these two drivers.

I am going to take care of this little (cross my fingers)
before the end of the year and still hope to make 4.5 if
stars and media and alsa maintainers are aligned :)

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
