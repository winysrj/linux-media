Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333Ab0BWPum (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 10:50:42 -0500
Message-ID: <4B83F97A.60103@redhat.com>
Date: Tue, 23 Feb 2010 16:51:22 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Brandon Philips <brandon@ifup.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
References: <4B55445A.10300@infradead.org> <4B57B6E4.2070500@infradead.org> <20100121024605.GK4015@jenkins.home.ifup.org> <201001210834.28112.hverkuil@xs4all.nl> <4B5B30E4.7030909@redhat.com> <20100222225426.GC4013@jenkins.home.ifup.org> <4B839687.4090205@redhat.com> <4B83F635.9030501@infradead.org>
In-Reply-To: <4B83F635.9030501@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 02/23/2010 04:37 PM, Mauro Carvalho Chehab wrote:
> Hans de Goede wrote:
>
>> Ok, so this will give me a local tree, how do I get this onto linuxtv.org ?
>
> I added it. In thesis, it is open for commit to you, me, hverkuil and dougsland.
>

I see good, thanks! Can someone (Douglas ?) with better hg / git powers then me please
somehow import all the libv4l changes from:
http://linuxtv.org/hg/~hgoede/libv4l

Once that is done I'll retire my own tree, and move all my userspace work to
the git tree.

For starters I plan to create / modify Makefiles so that everything will build
out of the box, and has proper make install targets which can be used by distro's

So:
-proper honoring of CFLAGS
-work with standard (and possibly somewhat older kernel headers)
-honor DESTDIR, PREFIX and LIBDIR when doing make install

When I'm satisfied (and have created some proof of concept packages for
Fedora to make sure everything is reasonably usable for distros). I'll
send a mail to the list announcing my intend to release a 0.8.0 version
(building on top of existing libv4l release scheme to make clear
  which libv4l version is included). If there are then no objections /
bugs found I'll do a 0.8.0 release .

Regards,

Hans

