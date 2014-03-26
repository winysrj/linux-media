Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:37448 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbaCZNpA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Mar 2014 09:45:00 -0400
To: =?UTF-8?Q?Antti_Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: Re: [PATCH 1/5] rc-main: add generic scancode filtering
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Wed, 26 Mar 2014 14:44:59 +0100
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: James Hogan <james.hogan@imgtec.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
In-Reply-To: <CAKv9HNaRT4WdcDiuFODM7Jpg02phxRyEDDJ5CgbL0W3BjnYBGw@mail.gmail.com>
References: <1393629426-31341-1-git-send-email-james.hogan@imgtec.com>
 <1393629426-31341-2-git-send-email-james.hogan@imgtec.com>
 <20140324235146.GA25627@hardeman.nu> <10422443.FIKnYVGtAm@radagast>
 <20140325232130.GA2515@hardeman.nu>
 <CAKv9HNaRT4WdcDiuFODM7Jpg02phxRyEDDJ5CgbL0W3BjnYBGw@mail.gmail.com>
Message-ID: <e38b3c86fdbfa448549762a6a700c296@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014-03-26 08:08, Antti Seppälä wrote:
> On 26 March 2014 01:21, David Härdeman <david@hardeman.nu> wrote:
>> On Tue, Mar 25, 2014 at 09:12:11AM +0000, James Hogan wrote:
>>> On Tuesday 25 March 2014 00:51:46 David Härdeman wrote:
>>>> What's the purpose of providing the sw scancode filtering in the 
>>>> case where
>>>> there's no hardware filtering support at all?
>>> 
>>> Consistency is probably the main reason, but I'll admit it's not 
>>> perfectly
>>> consistent between generic/hardware filtering (mostly thanks to NEC 
>>> scancode
>>> complexities), and I have no particular objection to dropping it if 
>>> that isn't
>>> considered a good enough reason.
>> 
>> I'm kind of sceptical...and given how difficult it is to remove
>> functionality that is in a released kernel...I think that particular
>> part (i.e. the software filtering) should be removed until it has had
>> further discussion...
...
>> I don't understand. What's the purpose of a "software fallback" for
>> scancode filtering? Antti?
>> 
> 
> Well since the ImgTec patches will create a new sysfs interface for
> the HW scancode filtering I figured that it would be nice for it to
> also function on devices which lack the hardware filtering
> capabilities. Especially since it's only three lines of code. :)
> 
> Therefore I suggested the software fallback. At the time I had no clue
> that there might be added complexities with nec scancodes.

It's not only NEC scancodes, the sw scancode filter is state that is 
changeable from user-space and which will require reader/writer 
synchronization during the RX path (which is the "hottest" path in 
rc-core). I've posted patches before which make the RX path lockless, 
this change makes complicates such changes.

Additionally, the provision of the sw fallback means that userspace has 
no idea if there is an actual hardware filter present or not, meaning 
that a userspace program that is aware of the scancode filter will 
always enable it.

So, I still think the SW part should be reverted, at least for now (i.e. 
the sysfs file should only be present if there is hardware support).

Mauro?

//David

