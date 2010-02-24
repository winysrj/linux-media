Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52668 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab0BXA6R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 19:58:17 -0500
Message-ID: <4B84799E.4000202@infradead.org>
Date: Tue, 23 Feb 2010 21:58:06 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Brandon Philips <brandon@ifup.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
References: <4B55445A.10300@infradead.org> <4B57B6E4.2070500@infradead.org> <20100121024605.GK4015@jenkins.home.ifup.org> <201001210834.28112.hverkuil@xs4all.nl> <4B5B30E4.7030909@redhat.com> <20100222225426.GC4013@jenkins.home.ifup.org> <4B839687.4090205@redhat.com> <4B83F635.9030501@infradead.org> <4B83F97A.60103@redhat.com>
In-Reply-To: <4B83F97A.60103@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans de Goede wrote:
> Hi,
> 
> On 02/23/2010 04:37 PM, Mauro Carvalho Chehab wrote:
>> Hans de Goede wrote:
>>
>>> Ok, so this will give me a local tree, how do I get this onto
>>> linuxtv.org ?
>>
>> I added it. In thesis, it is open for commit to you, me, hverkuil and
>> dougsland.
>>
> 
> I see good, thanks! Can someone (Douglas ?) with better hg / git powers
> then me please
> somehow import all the libv4l changes from:
> http://linuxtv.org/hg/~hgoede/libv4l

Ok, I added there. The procedure were simple: I ran Brandon script again,
but after pulling from your tree. Then, I used git format-patch to generate
a quilt series, and used git quiltimport on the correct -git tree.

> Once that is done I'll retire my own tree, and move all my userspace
> work to
> the git tree.
> 
> For starters I plan to create / modify Makefiles so that everything will
> build
> out of the box, and has proper make install targets which can be used by
> distro's
> 
> So:
> -proper honoring of CFLAGS
> -work with standard (and possibly somewhat older kernel headers)
> -honor DESTDIR, PREFIX and LIBDIR when doing make install

The better here is to have the latest kernel headers copied on the tree.
This way, it is possible to compile libv4l2 with an older kernel version and
later upgrade the kernel, if needed, or to use a fast machine to compile
it, and then use it on another machine.

-- 

Cheers,
Mauro
