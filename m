Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59604 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013Ab0BXN03 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 08:26:29 -0500
Message-ID: <4B8528F5.5010708@infradead.org>
Date: Wed, 24 Feb 2010 10:26:13 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Brandon Philips <brandon@ifup.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
References: <4B55445A.10300@infradead.org> <4B57B6E4.2070500@infradead.org> <20100121024605.GK4015@jenkins.home.ifup.org> <201001210834.28112.hverkuil@xs4all.nl> <4B5B30E4.7030909@redhat.com> <20100222225426.GC4013@jenkins.home.ifup.org> <4B839687.4090205@redhat.com> <4B83F635.9030501@infradead.org> <4B83F97A.60103@redhat.com> <20100224060545.GA20308@jenkins.stayonline.net> <4B851F26.4060907@redhat.com>
In-Reply-To: <4B851F26.4060907@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans de Goede wrote:
> Hi,
> 
> On 02/24/2010 07:05 AM, Brandon Philips wrote:
>> On 16:51 Tue 23 Feb 2010, Hans de Goede wrote:
>>> On 02/23/2010 04:37 PM, Mauro Carvalho Chehab wrote:
>>>> Hans de Goede wrote:
>>>>
>>>>> Ok, so this will give me a local tree, how do I get this onto
>>>>> linuxtv.org ?
>>>>
>>>> I added it. In thesis, it is open for commit to you, me, hverkuil
>>>> and dougsland.
>>>>
>>>
>>> I see good, thanks! Can someone (Douglas ?) with better hg / git
>>> powers then me please somehow import all the libv4l changes from:
>>> http://linuxtv.org/hg/~hgoede/libv4l
>>>
>>> Once that is done I'll retire my own tree, and move all my userspace
>>> work to the git tree.
>>>
>>> For starters I plan to create / modify Makefiles so that everything
>>> will build out of the box, and has proper make install targets which
>>> can be used by distro's
>>>
>>> So:
>>> -proper honoring of CFLAGS
>>> -work with standard (and possibly somewhat older kernel headers)
>>> -honor DESTDIR, PREFIX and LIBDIR when doing make install
>>
>> Do you still want me to convert to autoconf? I was still planning on
>> doing that. We discussed it a month ago when this conversation
>> started.
>>
>> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/15009
>>
>>
> 
> I know that was mentioned then, but re-thinking this, as this will all
> be Linux specific, I don't really see a need for autotools atm, and as
> I personally find autotools a bit overcomplicated. I would like to try
> just using plain Makefiles for now. If it turns out this does not work
> we can always switch to autotools later.

I suspect it won't work fine. There are some library dependencies at 
utils/contrib, like libsysfs and libqt stuff. The build system should or
refuse to compile or disable some of those tools if the dependencies are
missing.

Of course you may create a non-autotools configure script that checks for
those libraries. They aren't many, so this approach works, but it will
likely require more time than using autotools.


Cheers,
Mauro
