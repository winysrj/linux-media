Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:18230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287Ab1GBS3U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Jul 2011 14:29:20 -0400
Message-ID: <4E0F6372.8090701@redhat.com>
Date: Sat, 02 Jul 2011 15:29:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Subject: Re: [GIT PULL FOR 3.1] Bitmask controls, flash API and adp1653 driver
References: <20110610092703.GH7830@valkosipuli.localdomain> <4E0D226E.5010809@redhat.com> <201107010957.39930.hverkuil@xs4all.nl> <20110701111512.GN12671@valkosipuli.localdomain> <4E0DB2A8.10102@redhat.com> <4E0F5D79.4070308@iki.fi>
In-Reply-To: <4E0F5D79.4070308@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 02-07-2011 15:03, Sakari Ailus escreveu:
> Mauro Carvalho Chehab wrote:
>> Em 01-07-2011 08:15, Sakari Ailus escreveu:
>>> On Fri, Jul 01, 2011 at 09:57:39AM +0200, Hans Verkuil wrote:
>>>> On Friday, July 01, 2011 03:27:10 Mauro Carvalho Chehab wrote:
>>>>> Em 10-06-2011 06:27, Sakari Ailus escreveu:
>>>>>> Hi Mauro,
>>>>>>
>>>>>> This pull request adds the bitmask controls, flash API and the adp1653
>>>>>> driver. What has changed since the patches is:
>>>>>>
>>>>>> - Adp1653 flash faults control is volatile. Fix this.
>>>>>> - Flash interface marked as experimental.
>>>>>> - Moved the DocBook documentation to a new location.
>>>>>> - The target version is 3.1, not 2.6.41.
>>>>>>
>>>>>> The following changes since commit 75125b9d44456e0cf2d1fbb72ae33c13415299d1:
>>>>>>
>>>>>>   [media] DocBook: Don't be noisy at make cleanmediadocs (2011-06-09 16:40:58 -0300)
>>>>>>
>>>>>> are available in the git repository at:
>>>>>>   ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.1
>>>>>>
>>>>>> Hans Verkuil (3):
>>>>>>       v4l2-ctrls: add new bitmask control type.
>>>>>>       vivi: add bitmask test control.
>>>>>>       DocBook: document V4L2_CTRL_TYPE_BITMASK.
>>>>>
>>>>> I'm sure I've already mentioned, but I think it was at the Hans pull request:
>>>>> the specs don't mention what endiannes is needed for the bitmask controls: 
>>>>> machine endianess, little endian or big endian.  IMO, we should stick with either
>>>>> LE or BE.
>>>>
>>>> Sorry Sakari, I should have fixed that. But since the patch was going through
>>>> your repository I forgot about it. Anyway, it should be machine endianess. You
>>>> have to be able to do (value & bit_define). The bit_defines for each bitmask
>>>> control should be part of the control's definition in videodev2.h.
>>>>
>>>> It makes no sense to require LE or BE. We don't do that for other control types,
>>>> so why should bitmask be any different?
>>>>
>>>> Can you add this clarification to DocBook?
>>>
>>> Thinking about this some more, if we're to say something about the
>>> endianness we should specify it for all controls, not just bitmasks. I
>>> really wonder if need this at all: why would you think the endianness in a
>>> bitmask would be some other than machine endianness, be it a V4L2 control or
>>> a flags field in, say, struct v4l2_buffer? It would make sense to document
>>> it if it differs from the norm, so in my opinion such statement would be
>>> redundant.
>>
>> Because someone might have the "bright" idea of exposing a hardware register via
>> V4L2_CTRL_TYPE_BITMASK directly without reminding about the endiannes, and do the
>> wrong thing.
> 
> The same could be done to an integer control as well, the bitmask isn't
> special in that sense. Just my opinion.
> 
> The spec says "When for example a hardware register accepts values 0-511
> and the driver reports 0-65535, step should be 128." on step field in
> struct v4l2_queryctrl. This suggests that registers may be exposed to
> user space as integer controls.

Yes, in opposite to the V4L1 API, were drivers used to do some internal calculus,
in order to meet the API.
> 
> So endianness issues may exist on other types of controls as well if the
> programmer didn't remember that other endian than his existed.

Yes, that's true, although AFAIKT, this currently doesn't happen.

I agree that putting it in a way that it covers all controls are better.

>> There's not much problem on being redundant at the specs, but not specifying it
>> means that different implementations will still be valid.
>>
>> Btw, if you take a look at the descriptions for RGB format at the spec, you'll see
>> that endiannes problems already happened in the past: the specs had to explicitly
>> allow both endiannes for a few RGB formats due to that.
>>
>> I'm ok if we standardize that it should be the machine endiannes, but we should
>> be explicit on that.
> 
> I'll add a few words on this, but should it be added to bitmask controls
> documentation or controls in general?

Can be in general.

Thanks!
Mauro
