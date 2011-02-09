Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51270 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1BITBX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Feb 2011 14:01:23 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTimeYp=aJi40jH2Nwu25C_e1dJYxLXXXu-7zwZEp@mail.gmail.com>
References: <1297157427-14560-1-git-send-email-t.stanislaws@samsung.com>
 <201102081047.17840.hansverk@cisco.com> <AANLkTi=A=HiAvHojWP8HcFXpjXbZpq6UdHjOnWq-8jww@mail.gmail.com>
 <1297205267.2423.24.camel@localhost> <AANLkTimeYp=aJi40jH2Nwu25C_e1dJYxLXXXu-7zwZEp@mail.gmail.com>
From: Matt Turner <mattst88@gmail.com>
Date: Wed, 9 Feb 2011 19:00:38 +0000
Message-ID: <AANLkTim1_ba1gj25fGYua=mrya5q0twYO29enEhWxsod@mail.gmail.com>
Subject: Re: [PATCH/RFC 0/5] HDMI driver for Samsung S5PV310 platform
To: Hans Verkuil <hansverk@cisco.com>
Cc: Andy Walls <awalls@md.metrocast.net>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	Maling list - DRI developers
	<dri-devel@lists.freedesktop.org>,
	Alex Deucher <alexdeucher@gmail.com>,
	kyungmin.park@samsung.com, linux-media@vger.kernel.org,
	m.szyprowski@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Feb 9, 2011 at 7:12 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
> On Tue, Feb 8, 2011 at 5:47 PM, Andy Walls <awalls@md.metrocast.net> wrote:
>> On Tue, 2011-02-08 at 10:28 -0500, Alex Deucher wrote:
>>> On Tue, Feb 8, 2011 at 4:47 AM, Hans Verkuil <hansverk@cisco.com> wrote:
>>> > Just two quick notes. I'll try to do a full review this weekend.
>>> >
>>> > On Tuesday, February 08, 2011 10:30:22 Tomasz Stanislawski wrote:
>>> >> ==============
>>> >>  Introduction
>>> >> ==============
>>> >>
>>> >> The purpose of this RFC is to discuss the driver for a TV output interface
>>> >> available in upcoming Samsung SoC. The HW is able to generate digital and
>>> >> analog signals. Current version of the driver supports only digital output.
>>> >>
>>> >> Internally the driver uses videobuf2 framework, and CMA memory allocator.
>>> > Not
>>> >> all of them are merged by now, but I decided to post the sources to start
>>> >> discussion driver's design.
>>
>>> >
>>> > Cisco (i.e. a few colleagues and myself) are working on this. We hope to post
>>> > an RFC by the end of this month. We also have a proposal for CEC support in
>>> > the pipeline.
>>>
>>> Any reason to not use the drm kms APIs for modesetting, display
>>> configuration, and hotplug support?  We already have the
>>> infrastructure in place for complex display configurations and
>>> generating events for hotplug interrupts.  It would seem to make more
>>> sense to me to fix any deficiencies in the KMS APIs than to spin a new
>>> API.  Things like CEC would be a natural fit since a lot of desktop
>>> GPUs support hdmi audio/3d/etc. and are already using kms.
>>>
>>> Alex
>>
>> I'll toss one out: lack of API documentation for driver or application
>> developers to use.
>>
>>
>> When I last looked at converting ivtvfb to use DRM, KMS, TTM, etc. (to
>> possibly get rid of reliance on the ivtv X video driver
>> http://dl.ivtvdriver.org/xf86-video-ivtv/ ), I found the documentation
>> was really sparse.
>>
>> DRM had the most documentation under Documentation/DocBook/drm.tmpl, but
>> the userland API wasn't fleshed out.  GEM was talked about a bit in
>> there as well, IIRC.
>>
>> TTM documentation was essentially non-existant.
>>
>> I can't find any KMS documentation either.
>>
>> I recall having to read much of the drm code, and having to look at the
>> radeon driver, just to tease out what the DRM ioctls needed to do.
>>
>> Am I missing a Documentation source for the APIs?

Yes,

My summer of code project's purpose was to create something of a
tutorial for writing a KMS driver. The code, split out into something
like 15 step-by-step patches, and accompanying documentation are
available from Google's website.

http://code.google.com/p/google-summer-of-code-2010-xorg/downloads/detail?name=Matt_Turner.tar.gz

My repository (doesn't include the documentation) is available here:
http://git.kernel.org/?p=linux/kernel/git/mattst88/glint.git;a=summary

There's a 'rebased' branch that contains API changes required for the
code to work with 2.6.37~.

I hope it's useful to you.

I can't image how the lack of documentation of an used and tested API
could be a serious reason to write you own. That makes absolutely no
sense to me, so I hope you'll decide to use KMS.

Matt
