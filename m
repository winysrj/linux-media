Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:43112 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759090Ab2FUJHP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 05:07:15 -0400
MIME-Version: 1.0
In-Reply-To: <CA+8MBb+Kk=G5GQbSdbjXqFmw+GCON6jLZABCAGuL+bNDC+dLgA@mail.gmail.com>
References: <1339203038-13069-1-git-send-email-akinobu.mita@gmail.com>
	<CA+8MBb+Kk=G5GQbSdbjXqFmw+GCON6jLZABCAGuL+bNDC+dLgA@mail.gmail.com>
Date: Thu, 21 Jun 2012 18:07:14 +0900
Message-ID: <CAC5umyj1RGHh_0miku_R+ZCtfTOBK6XeY62Aun2MifgFTn_MKg@mail.gmail.com>
Subject: Re: [PATCH v3 1/9] string: introduce memweight
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	Anders Larsen <al@alarsen.net>,
	Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>, Matthew Wilcox <matthew@wil.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/6/21 Tony Luck <tony.luck@gmail.com>:
> On Fri, Jun 8, 2012 at 5:50 PM, Akinobu Mita <akinobu.mita@gmail.com> wrote:
>> �lib/string.c � � � � � | � 36 ++++++++++++++++++++++++++++++++++++
>
> Is lib/string.c the right place for this? �I get a build error on the
> ia64 sim_defconfig:
>
> �LD � � �arch/ia64/hp/sim/boot/bootloader
>
> It fails because it pulls in lib/lib.a(string.o) to get some
> innocuous function like strcpy() ... but it also gets
> given memweight() which relies on __bitmap_weight()
> which it doesn't have, because it doesn't include lib/built-in.o
> (which is where bitmap.o, the definer of __bitmap_weight(), has
> been linked).
>
> Moving memweight() to lib/bitmap.c fixes the problem. But it
> isn't really clear that it belongs there either. �Perhaps it should
> be its own file lib/memweight.c that gets included in lib/lib.a?

I'll fix it by making lib/memweight.c as you suggested.
Thanks for your report and suggestion.
