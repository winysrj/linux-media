Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759058Ab0BYKvd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Feb 2010 05:51:33 -0500
Message-ID: <4B865662.5000500@redhat.com>
Date: Thu, 25 Feb 2010 11:52:18 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Brandon Philips <brandon@ifup.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
References: <4B57B6E4.2070500@infradead.org> <20100121024605.GK4015@jenkins.home.ifup.org> <201001210834.28112.hverkuil@xs4all.nl> <4B5B30E4.7030909@redhat.com> <20100222225426.GC4013@jenkins.home.ifup.org> <4B839687.4090205@redhat.com> <4B83F635.9030501@infradead.org> <4B83F97A.60103@redhat.com> <4B84799E.4000202@infradead.org> <4B8521CF.7090500@redhat.com> <20100224143202.GE20308@jenkins.stayonline.net>
In-Reply-To: <20100224143202.GE20308@jenkins.stayonline.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 02/24/2010 03:32 PM, Brandon Philips wrote:
> On 13:55 Wed 24 Feb 2010, Hans de Goede wrote:

<snip>
>> Where necessary libv4l currently has code snippets like:
>>
>> #ifndef V4L2_PIX_FMT_SPCA501
>> #define V4L2_PIX_FMT_SPCA501 v4l2_fourcc('S','5','0','1') /* YUYV per line */
>> #endif
>
> I don't think this is less work than copying the header file from the
> Kernel. Test building under all versions of the Kernel headers that
> exist to make sure something isn't missed isn't possible. It really is
> easier just to sync the header file up.
>
>> The reason for this is that I want to avoid carrying a copy of a dir
>> from some other tree, with all getting stale and needing sync all
>> the time issues that come with that, not to mention chicken and egg
>> problems in the case of new formats which simultaneously need to be
>> added to both libv4l and the kernel.
>
> Worst case is that if it is stale then it won't build since it depends
> on fancy new feature XYZ. But, at least it won't build on all systems
> instead of randomly breaking based on installed kernel headers
> version.
>
>> For example often I add support for V4L2_PIX_FMT_NEW_FOO to libv4l, before it
>> hits any official v4l-dvb kernel tree, with the:
>
> Please don't add features to releases before they are merged with
> Linus. It would suck to ship a copy of libv4l that has a different
> idea of structs or constants then the upstream Kernel.
>

Note the only thing added is a V4L2_PIX_FMT_xxx define, IOW this makes libv4l
recognize (and convert from) a new video format, which is to be generated
by a going upstream soon driver. With older kernels this won't make any
difference as those don't generate that format.

>> Approach this works fine, if I were to carry an include tree copy, that would
>> now need to become a patched include tree copy, and with the next sync I then
>> need to ensure that any needed patches are either already in the sync source,
>> or applied again.
>
> Or just fix it upstream with #ifdef __KERNEL__ tags once and for all,
> right?

I wasn't even talking about #ifdef __KERNEL__ issues, although yes those
exist too.

Regards,

Hans
