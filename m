Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:57041 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaCZHIu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Mar 2014 03:08:50 -0400
Received: by mail-qa0-f54.google.com with SMTP id w8so1769669qac.41
        for <linux-media@vger.kernel.org>; Wed, 26 Mar 2014 00:08:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140325232130.GA2515@hardeman.nu>
References: <1393629426-31341-1-git-send-email-james.hogan@imgtec.com>
	<1393629426-31341-2-git-send-email-james.hogan@imgtec.com>
	<20140324235146.GA25627@hardeman.nu>
	<10422443.FIKnYVGtAm@radagast>
	<20140325232130.GA2515@hardeman.nu>
Date: Wed, 26 Mar 2014 09:08:49 +0200
Message-ID: <CAKv9HNaRT4WdcDiuFODM7Jpg02phxRyEDDJ5CgbL0W3BjnYBGw@mail.gmail.com>
Subject: Re: [PATCH 1/5] rc-main: add generic scancode filtering
From: =?ISO-8859-1?Q?Antti_Sepp=E4l=E4?= <a.seppala@gmail.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: James Hogan <james.hogan@imgtec.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26 March 2014 01:21, David Härdeman <david@hardeman.nu> wrote:
> On Tue, Mar 25, 2014 at 09:12:11AM +0000, James Hogan wrote:
>>On Tuesday 25 March 2014 00:51:46 David Härdeman wrote:
>>> On Fri, Feb 28, 2014 at 11:17:02PM +0000, James Hogan wrote:
>>> >Add generic scancode filtering of RC input events, and fall back to
>>> >permitting any RC_FILTER_NORMAL scancode filter to be set if no s_filter
>>> >callback exists. This allows raw IR decoder events to be filtered, and
>>> >potentially allows hardware decoders to set looser filters and rely on
>>> >generic code to filter out the corner cases.
>>>
>>> Hi James,
>>>
>>> What's the purpose of providing the sw scancode filtering in the case where
>>> there's no hardware filtering support at all?
>>
>>Consistency is probably the main reason, but I'll admit it's not perfectly
>>consistent between generic/hardware filtering (mostly thanks to NEC scancode
>>complexities), and I have no particular objection to dropping it if that isn't
>>considered a good enough reason.
>
> I'm kind of sceptical...and given how difficult it is to remove
> functionality that is in a released kernel...I think that particular
> part (i.e. the software filtering) should be removed until it has had
> further discussion...
>
>>Here's the original discussion:
>>On Monday 10 February 2014 21:45:30 Antti Seppälä wrote:
>>> On 10 February 2014 11:58, James Hogan <james.hogan@imgtec.com> wrote:
>>> > On Saturday 08 February 2014 13:30:01 Antti Seppälä wrote:
>>> > > Also adding the scancode filter to it would
>>> > > demonstrate its usage.
>>> >
>>> > To actually add filtering support to loopback would require either:
>>> > * raw-decoder/rc-core level scancode filtering for raw ir drivers
>>> > * OR loopback driver to encode like nuvoton and fuzzy match the IR
>>> > signals.
>>>
>>> Rc-core level scancode filtering shouldn't be too hard to do right? If
>>> such would exist then it would provide a software fallback to other rc
>>> devices where hardware filtering isn't available. I'd love to see the
>>> sysfs filter and filter_mask files to have an effect on my nuvoton too
>
> I don't understand. What's the purpose of a "software fallback" for
> scancode filtering? Antti?
>

Well since the ImgTec patches will create a new sysfs interface for
the HW scancode filtering I figured that it would be nice for it to
also function on devices which lack the hardware filtering
capabilities. Especially since it's only three lines of code. :)

Therefore I suggested the software fallback. At the time I had no clue
that there might be added complexities with nec scancodes.

So like James said it exists mainly for api consistency reasons.

-Antti
