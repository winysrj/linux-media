Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:37262 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbaCYXVd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 19:21:33 -0400
Date: Wed, 26 Mar 2014 00:21:30 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Antti =?iso-8859-1?Q?Sepp=E4l=E4?= <a.seppala@gmail.com>
Subject: Re: [PATCH 1/5] rc-main: add generic scancode filtering
Message-ID: <20140325232130.GA2515@hardeman.nu>
References: <1393629426-31341-1-git-send-email-james.hogan@imgtec.com>
 <1393629426-31341-2-git-send-email-james.hogan@imgtec.com>
 <20140324235146.GA25627@hardeman.nu>
 <10422443.FIKnYVGtAm@radagast>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <10422443.FIKnYVGtAm@radagast>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 25, 2014 at 09:12:11AM +0000, James Hogan wrote:
>On Tuesday 25 March 2014 00:51:46 David Härdeman wrote:
>> On Fri, Feb 28, 2014 at 11:17:02PM +0000, James Hogan wrote:
>> >Add generic scancode filtering of RC input events, and fall back to
>> >permitting any RC_FILTER_NORMAL scancode filter to be set if no s_filter
>> >callback exists. This allows raw IR decoder events to be filtered, and
>> >potentially allows hardware decoders to set looser filters and rely on
>> >generic code to filter out the corner cases.
>> 
>> Hi James,
>> 
>> What's the purpose of providing the sw scancode filtering in the case where
>> there's no hardware filtering support at all?
>
>Consistency is probably the main reason, but I'll admit it's not perfectly 
>consistent between generic/hardware filtering (mostly thanks to NEC scancode 
>complexities), and I have no particular objection to dropping it if that isn't 
>considered a good enough reason.

I'm kind of sceptical...and given how difficult it is to remove
functionality that is in a released kernel...I think that particular
part (i.e. the software filtering) should be removed until it has had
further discussion...

>Here's the original discussion:
>On Monday 10 February 2014 21:45:30 Antti Seppälä wrote:
>> On 10 February 2014 11:58, James Hogan <james.hogan@imgtec.com> wrote:
>> > On Saturday 08 February 2014 13:30:01 Antti Seppälä wrote:
>> > > Also adding the scancode filter to it would
>> > > demonstrate its usage.
>> > 
>> > To actually add filtering support to loopback would require either:
>> > * raw-decoder/rc-core level scancode filtering for raw ir drivers
>> > * OR loopback driver to encode like nuvoton and fuzzy match the IR
>> > signals.
>> 
>> Rc-core level scancode filtering shouldn't be too hard to do right? If
>> such would exist then it would provide a software fallback to other rc
>> devices where hardware filtering isn't available. I'd love to see the
>> sysfs filter and filter_mask files to have an effect on my nuvoton too

I don't understand. What's the purpose of a "software fallback" for
scancode filtering? Antti?

-- 
David Härdeman
