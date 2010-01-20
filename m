Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339Ab0ATKoB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 05:44:01 -0500
Message-ID: <4B56DE56.2040207@redhat.com>
Date: Wed, 20 Jan 2010 11:43:34 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Paulo Assis <pj.assis@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>,
	Brandon Philips <brandon@ifup.org>
Subject: libwecam & uvcdynctrl (was Re: [ANNOUNCE] git tree repositories &
 libv4l)
References: <4B55445A.10300@infradead.org>	 <201001190853.11050.hverkuil@xs4all.nl>	 <4B5592BF.8040201@infradead.org> <4B56C078.8000502@redhat.com> <59cf47a81001200154n57280719sce946e9553e8e06b@mail.gmail.com>
In-Reply-To: <59cf47a81001200154n57280719sce946e9553e8e06b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 01/20/2010 10:54 AM, Paulo Assis wrote:
> Hi,
>
>> The uvcdynctrl utility is part of the libwebcam project:
>> http://www.quickcamteam.net/software/libwebcam
>>
>> But given that libwebcam is unmaintained and not used by anything AFAIK, I'm
>> patching
>> uvcdynctrl to no longer need it. The plan is to add uvcdynctrl to libv4l
>> soon, as that
>> is needed to be able to control the focus on some uvc autofocus cameras.
>
> Actually libwebcam is still maintained in svn:
>

Looking at the clog, maintained is a very big word here, there is some activity
here but very little to speak of.

> http://www.quickcamteam.net/documentation/how-to/how-to-install-the-webcam-tools
>

Looking at that page, the only reason stated there to install it is
uvcdynctrl, not libwebcam itself. And the installation as described there
is a pain.

Also the current state of uvcdynctrl + uvcvideo + the xml database is not
exactly one that is end user ready.

The reset pan/tilt controls don't work properly (they should be of the
button type).

The led controls don't work properly (the led control one should be
a menu, the frequency should have a minimum of 1 not 0).

I'm working on:

1) Dropping the unnecessary libwebcam dependency (done), which was
    surprisingly easy. There really is nothing uvcdynctrl needs libwebcam
    for, other then uvcvideo /dev/video devices detection, but given
    that uvcdynctrl's primary use will be from udev, there is no need
    for that, the udev rule can simply pass in the device node as argument.

2) Making installation a breeze (and getting it included in most distros)

3) Making it actually user friendly, once uvcdynctrl is executed a user should
be able to startup a gui v4l2 control panel like v4l2ucp and have meaning full,
working controls there, without any error messages being shown.

> but you are right just a few applications use it, and since it's not
> yet included in any distribution most end users will miss some advance
> features on their webcams.
> I'm just a bit worried that having two different packages providing
> the same set of tools may cause some compatibility problems in the
> future. Binary packages of libwebcam are being prepared and will be
> available soon, so I guess some compat tests may be in order, maybe
> splitting uvcdynctrl from libwebcam into a different package and
> making it incompatible with libv4l would be a good idea.
>

My plan is to remove the dependency of uvcdynctrl on libwebcam, and
then incorporate uvcdynctrl inside libv4l. I was doing this under
the assumption that the libwebcam project was pretty much dead, I was
already planning on mailing Martin Rubli and will do so shortly.

I have various requests from users who need the additional controls
(for things like focus on the "Logitech Quickcam Pro 9000"), and was
asked to incorporate uvcdynctrl into libv4l by Laurens Pinchart.

I'm sorry if this comes over as hijacking the code / project, that is
not what this is about, this is about enabling the additional controls
for end users in a plug and play way. Which I believe is easiest done
by adding uvcdynctrl to libv4l, as that is actively maintained and
packaged in most distros.

Regards,

Hans
