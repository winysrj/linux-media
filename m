Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46536 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab2EXLyR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 May 2012 07:54:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120523131559.GA7064@parisc-linux.org>
References: <1337520203-29147-1-git-send-email-akinobu.mita@gmail.com>
	<20120523092113.GG10452@quack.suse.cz>
	<CAC5umyi=ridqRZGGh0+_xw0-GCN+69B33Qz82-9x4dVODGGx6w@mail.gmail.com>
	<20120523131559.GA7064@parisc-linux.org>
Date: Thu, 24 May 2012 20:54:16 +0900
Message-ID: <CAC5umyhPzvAhX8Y-oa5Kr-G7ZAJ15HV_H2HMgxrV2KZUJadsNw@mail.gmail.com>
Subject: Re: [PATCH 01/10] string: introduce memweight
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, Anders Larsen <al@alarsen.net>,
	Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
	linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/5/23 Matthew Wilcox <matthew@wil.cx>:
> On Wed, May 23, 2012 at 09:12:18PM +0900, Akinobu Mita wrote:
>> size_t memweight(const void *ptr, size_t bytes)
>
> Why should this return size_t instead of unsigned long?

I just use the same type as the bytes argument without mature
consideration.  If unsigned long is better than size_t, I'll
change the return type.

>> {
>> � � � size_t w = 0;
>> � � � size_t longs;
>> � � � const unsigned char *bitmap = ptr;
>>
>> � � � for (; bytes > 0 && ((unsigned long)bitmap) % sizeof(long);
>> � � � � � � � � � � � bytes--, bitmap++)
>> � � � � � � � w += hweight8(*bitmap);
>>
>> � � � longs = bytes / sizeof(long);
>> � � � BUG_ON(longs >= INT_MAX / BITS_PER_LONG);
>> � � � w += bitmap_weight((unsigned long *)bitmap, longs * BITS_PER_LONG);
>> � � � bytes -= longs * sizeof(long);
>> � � � bitmap += longs * sizeof(long);
>>
>> � � � for (; bytes > 0; bytes--, bitmap++)
>> � � � � � � � w += hweight8(*bitmap);
>>
>> � � � return w;
>> }
>
> bitmap_weight copes with a bitmask that isn't a multiple of BITS_PER_LONG
> in size already. �So I think this can be done as:
>
> unsigned long memweight(const void *s, size_t n)
> {
> � � � �const unsigned char *ptr = s;
> � � � �unsigned long r = 0;
>
> � � � �while (n > 0 && (unsigned long)ptr % sizeof(long)) {
> � � � � � � � �r += hweight8(*ptr);
> � � � � � � � �n--;
> � � � � � � � �ptr++;
> � � � �}
>
> � � � �BUG_ON(n >= INT_MAX / 8)
>
> � � � �return r + bitmap_weight((unsigned long *)ptr, n * 8);
> }

This works perfectly on little-endian machines.  But it doesn't work
on big-endian machines, if the bottom edge of memory area is not
aligned on long word boundary.
