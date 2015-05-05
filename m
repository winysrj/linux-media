Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vn0-f45.google.com ([209.85.216.45]:38304 "EHLO
	mail-vn0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993293AbbEEPD1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 May 2015 11:03:27 -0400
MIME-Version: 1.0
In-Reply-To: <0af301d0832f$f0ffec70$d2ffc550$@debski@samsung.com>
References: <1430301765-22202-1-git-send-email-k.debski@samsung.com>
	<1430301765-22202-13-git-send-email-k.debski@samsung.com>
	<CACvgo52hDYpgv2FY8X-O7SC=+2YMn7osHt_V=NJxP+4REaw1=Q@mail.gmail.com>
	<0af301d0832f$f0ffec70$d2ffc550$@debski@samsung.com>
Date: Tue, 5 May 2015 16:03:26 +0100
Message-ID: <CACvgo50jMOCG5K1iM=SFE2CFYR6JMN3LBPmNtKO__Tra3KkCRQ@mail.gmail.com>
Subject: Re: [PATCH] libgencec: Add userspace library for the generic CEC
 kernel interface
From: Emil Velikov <emil.l.velikov@gmail.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: ML dri-devel <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org,
	"moderated list:ARM/S5P EXYNOS AR..."
	<linux-samsung-soc@vger.kernel.org>, sean@mess.org,
	mchehab@osg.samsung.com,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>, lars@opdenkamp.eu,
	Kyungmin Park <kyungmin.park@samsung.com>,
	thomas@tommie-lie.de, linux-input@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

It seems that you've only incorporated the libgencec.pc suggestion.
Did you change your mind about the others, found out something funny
with them (if so can you let me know what) or simply forgot about them
?

On 30 April 2015 at 11:25, Kamil Debski <k.debski@samsung.com> wrote:
> Hi Emil,
>
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Emil Velikov
> Sent: Wednesday, April 29, 2015 5:00 PM
>>
>> Hi Kamil,
>>
>> Allow me to put a few suggestions:
>>
>> On 29 April 2015 at 11:02, Kamil Debski <k.debski@samsung.com> wrote:

>> > diff --git a/m4/.gitkeep b/m4/.gitkeep new file mode 100644 index
>> > 0000000..e69de29
>> Haven't seen any projects doing this. Curious what the benefits of
>> keeping and empty folder might be ?
>
> When I run autoreconf -i it complained about missing m4 folder, hence I added
> this filler file such that the folder is created. Any suggestion on how to do
> this better?
>
Ahh yes - that lovely message. It turns out that older versions of
automake will even error out [1], rather than just printing out a
warning. A handy workaround would be to add a .gitignore (and a second
one in the top folder) list. Plus it will slim down the untracked
files list and let you clearly see when git add was missed :-)

Cheers
Emil

[1] https://bugzilla.redhat.com/show_bug.cgi?id=901333
