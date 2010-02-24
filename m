Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58970 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152Ab0BXNm2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 08:42:28 -0500
Message-ID: <4B852CB5.5040909@infradead.org>
Date: Wed, 24 Feb 2010 10:42:13 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Brandon Philips <brandon@ifup.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
References: <4B55445A.10300@infradead.org> <4B57B6E4.2070500@infradead.org> <20100121024605.GK4015@jenkins.home.ifup.org> <201001210834.28112.hverkuil@xs4all.nl> <4B5B30E4.7030909@redhat.com> <20100222225426.GC4013@jenkins.home.ifup.org> <4B839687.4090205@redhat.com> <4B83F635.9030501@infradead.org> <4B83F97A.60103@redhat.com> <4B84799E.4000202@infradead.org> <4B8521CF.7090500@redhat.com>
In-Reply-To: <4B8521CF.7090500@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans de Goede wrote:
> Hi,
> 
> On 02/24/2010 01:58 AM, Mauro Carvalho Chehab wrote:
>> Hans de Goede wrote:
>>> Hi,
>>>
>>> On 02/23/2010 04:37 PM, Mauro Carvalho Chehab wrote:
>>>> Hans de Goede wrote:
>>>>
>>>>> Ok, so this will give me a local tree, how do I get this onto
>>>>> linuxtv.org ?
>>>>
>>>> I added it. In thesis, it is open for commit to you, me, hverkuil and
>>>> dougsland.
>>>>
>>>
>>> I see good, thanks! Can someone (Douglas ?) with better hg / git powers
>>> then me please
>>> somehow import all the libv4l changes from:
>>> http://linuxtv.org/hg/~hgoede/libv4l
>>
>> Ok, I added there. The procedure were simple: I ran Brandon script again,
>> but after pulling from your tree. Then, I used git format-patch to
>> generate
>> a quilt series, and used git quiltimport on the correct -git tree.
>>
> 
> Thanks!
> 
> 
>>> Once that is done I'll retire my own tree, and move all my userspace
>>> work to
>>> the git tree.
>>>
>>> For starters I plan to create / modify Makefiles so that everything will
>>> build
>>> out of the box, and has proper make install targets which can be used by
>>> distro's
>>>
>>> So:
>>> -proper honoring of CFLAGS
>>> -work with standard (and possibly somewhat older kernel headers)
>>> -honor DESTDIR, PREFIX and LIBDIR when doing make install
>>
>> The better here is to have the latest kernel headers copied on the tree.
>> This way, it is possible to compile libv4l2 with an older kernel
>> version and
>> later upgrade the kernel, if needed, or to use a fast machine to compile
>> it, and then use it on another machine.
>>
> 
> If possible I would like to avoid this, afaik no other userspace utility
> packages
> are doing this.
> 
> Where necessary libv4l currently has code snippets like:
> 
> #ifndef V4L2_PIX_FMT_SPCA501
> #define V4L2_PIX_FMT_SPCA501 v4l2_fourcc('S','5','0','1') /* YUYV per
> line */
> #endif
> 
> So libv4l (in its current state) will already compile fine with older
> kernel
> headers. I expect that the other utilities will not need a lot of
> recent kernel ABI. So for now I would like to try and extend the above
> approach
> to the other utilities.

I think build will fail. I remember I had some such troubles when compiling
it against RHEL5, before we did the merge with the in-tree videodev2.h.

It should be reminded that, when people upgrade their kernels by hand,
they generally don't run "make headers_install". So, the kernel headers
on /usr/include/linux are the ones found on the original distro kernel,
and not the ones that are needed by the user.

> The reason for this is that I want to avoid carrying a copy of a dir
> from some
> other tree, with all getting stale and needing sync all the time issues
> that
> come with that,

The sync problem will keep existing, since some of the tools from
this tree are used as examples on media-specs.

> not to mention chicken and egg problems in the case of
> new formats which simultaneously  need to be added to both libv4l and
> the kernel.
> 
> For example often I add support for V4L2_PIX_FMT_NEW_FOO to libv4l,
> before it
> hits any official v4l-dvb kernel tree, with the:
> #ifndef V4L2_PIX_FMT_SPCA501
> #define V4L2_PIX_FMT_SPCA501 v4l2_fourcc('S','5','0','1') /* YUYV per
> line */
> #endif
> 
> Approach this works fine, if I were to carry an include tree copy, that
> would
> now need to become a patched include tree copy, and with the next sync I
> then
> need to ensure that any needed patches are either already in the sync
> source,
> or applied again.

True, but the additional work for those occasional changes are minimum, and
may save some time when handling complains about why the tree don't build
on his machine.

-- 

Cheers,
Mauro
