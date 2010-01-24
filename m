Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55954 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0AXAm2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jan 2010 19:42:28 -0500
Message-ID: <4B5B976B.1080309@infradead.org>
Date: Sat, 23 Jan 2010 22:42:19 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Brandon Philips <brandon@ifup.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
References: <4B55445A.10300@infradead.org> <20100120210740.GJ4015@jenkins.home.ifup.org> <4B57B6E4.2070500@infradead.org> <201001210823.04739.hverkuil@xs4all.nl> <4B5B31A3.9060903@redhat.com>
In-Reply-To: <4B5B31A3.9060903@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans de Goede wrote:
> Hi,
> 
> On 01/21/2010 08:23 AM, Hans Verkuil wrote:
>>>
> 
> <snip>
> 
>>> Yes, but, as we have also non-c code, some rules there don't apply.
>>> For example the rationale for not using // comments don't apply to c++,
>>> since it is there since the first definition.
>>
>> Most apps are already in 'kernel' style. The main exception being libv4l.

Well... they are "close" to kernel style, but if you run checkpatch over
all files there, I'm sure you'll see lots of violations.

> 
> Ack,
> 
> which in hind sight may not have been the best choice (I have no personal
> coding style, I'm used to adjusting my style to what ever the project
> I'm working on uses).
> 
> Still I would like to keep libv4l as an exception,

If we're adopting one CodingStyle, this should be done for everything, otherwise
it makes no sense to standardize.

> re-indenting it is
> not going to do it any good (I did my best to keep lines within 80
> chars, but moving to tabs as indent will ruin this, and there are quite
> a few nasty nested if cases in there).

The 80 chars limit is nowadays a "soft" simit. There are even some discussions from
people that the resulting code of people sending patches that just avoids the limit
is worse than before.

The idea behind this limit is that lines of code with more than 80 chars is an indication
that the code is more complex than it needs to be. So, the logic there may re-implemented
on a better way.

Just for fun, I ran this indent command (with kernel CodingStyle, except for the 80 chars
limit), over v4l2-apps/libv4l/libv4l2:

	indent -npro -kr -i8 -ts8 -sob  -ss -ncs -cp1  -l260 *.c

Except for one or two things, the resulting code seems a way better. Yet, as pointed by
Brandon, some manual work is needed to fix some parts of the result, as the indent is not
perfect.

Again for fun, I ran a checkpatch over the resulting code, removing all warnings due
to 80 cols (see enclosed). I think the troubles with the goto labels were introduced by
indent.

---

>From my side, it would be better to use the same CodingStyle also at v4l2-apps,
since this makes easier for people to contribute on both kernel and userspace. Also, 
I can read the code faster when it uses the Kernel CodingStyle.

Yet, not all checkpatch warnings apply to userspace, as some are specific to usage
of kernel deprecated functions. That's said, by using an style close to the kernel one,
it is easy to remove from checkpatch the warnings that won't apply to userspace.


Cheers,
Mauro

-

/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '	if ((result = SYS_IOCTL(devices[index].fd, VIDIOC_REQBUFS, &req)) < 0) {':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:102: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '		if ((result = SYS_IOCTL(devices[index].fd, VIDIOC_STREAMON, &type))) {':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:193: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '	if ((result = SYS_IOCTL(devices[index].fd, VIDIOC_QBUF, &buf))) {':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:238: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '	if ((result = v4l2_map_buffers(index)))':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:255: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '		if ((result = SYS_IOCTL(devices[index].fd, VIDIOC_DQBUF, buf))) {':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:259: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '	}':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:287: warning: braces {} are not necessary for single statement blocks
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '	}':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:338: warning: braces {} are not necessary for single statement blocks
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '	if ((result = v4l2_request_read_buffers(index)))':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:377: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '	if ((result = v4l2_map_buffers(index)))':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:380: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '	if ((result = v4l2_queue_read_buffers(index)))':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:383: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '	if ((result = v4l2_streamoff(index)))':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:395: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '	if (!v4l2_log_file && (lfname = getenv("LIBV4L2_LOG_FILENAME")))':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:493: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '	if (!(convert = v4lconvert_create(fd)))':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:518: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '	if ((index = v4l2_get_index(fd)) == -1)':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:601: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '	if ((index = v4l2_get_index(fd)) == -1)':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:648: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '	if ((index = v4l2_get_index(fd)) == -1)':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:718: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '			if ((result = v4l2_check_buffer_change_ok(index)))':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:897: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '			if ((result = v4l2_check_buffer_change_ok(index)))':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:942: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '				if ((result = v4l2_deactivate_read_stream(index)))':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:964: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '			if ((result = v4l2_deactivate_read_stream(index)))':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:984: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '			if ((result = v4l2_map_buffers(index)))':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:989: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '				if ((result = v4l2_deactivate_read_stream(index)))':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:1000: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '			if ((result = v4l2_deactivate_read_stream(index)))':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:1046: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '	if ((index = v4l2_get_index(fd)) == -1)':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:1074: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '		if ((result = v4l2_activate_read_stream(index)))':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:1095: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '      leave:':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:1113: warning: labels should not be indented
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '	if ((index = v4l2_get_index(fd)) == -1 ||':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:1125: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '      leave:':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:1168: warning: labels should not be indented
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '	if ((index = v4l2_get_index(fd)) == -1) {':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:1221: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '	if ((result = v4lconvert_vidioc_queryctrl(devices[index].convert, &qctrl)))':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:1227: ERROR: do not use assignment in if condition
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c: In '	if ((index = v4l2_get_index(fd)) == -1) {':
/home/v4l/master/v4l2-apps/libv4l/libv4l2/libv4l2.c:1248: ERROR: do not use assignment in if condition

