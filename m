Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5AGOPdS008740
	for <video4linux-list@redhat.com>; Tue, 10 Jun 2008 12:24:25 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5AGO41e026247
	for <video4linux-list@redhat.com>; Tue, 10 Jun 2008 12:24:05 -0400
Message-ID: <484EAA9D.1050701@hhs.nl>
Date: Tue, 10 Jun 2008 18:23:57 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Thierry Merle <thierry.merle@free.fr>
References: <484C594A.3040908@hhs.nl>
	<.195.6.25.114.1213098615.squirrel@82.255.184.47>
In-Reply-To: <.195.6.25.114.1213098615.squirrel@82.255.184.47>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Elmar Kleijn <elmar_kleijn@hotmail.com>, spca50x-devs@lists.sourceforge.net,
	video4linux-list@redhat.com, "need4weed@gmail.com" <need4weed@gmail.com>
Subject: Re: v4l1 compat version 0.6 aka V4L2 apps stay working
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Thierry Merle wrote:
> Hi Hans,
>> Hi All,
>>
>> Changes since last version:
>> v4l1-compat-0.6 (V4L2 apps stay working)
>> ----------------------------------------
>> * Do not go into emulation mode of rgb24 immediately, but only after a
>>    GPICT ioctl which has not been preceded by a SPICT ioctl, AKA do not
>> get
>>    in the way of V4L2 read calls by doing conversion on them
>> * Do not get in the way of mmap calls made by V4L2 applications
>> * Fix swapping of red and blue in bayer -> bgr24 decode routine
>> * Remember the v4l1 palette asked for with SPICT and return that, as
>>    otherwise we loose information when going v4l1 -> v4l2 -> v4l1, for
>> example
>>    YUV420P becomes YUV420, which are separate in v4l1.
>>
>> Given the high rate of me pushing out releases I was planning to stop
>> spamming
>> the list with tarbals (however small), but my personal webspace is down
>> (yeah!)
>> so one more time in spam modues, sorry.
>>
>> With this version all apps tried sofar:
>> * spcaview read / mmap mode, yuv420 and bgr24
>> * ekiga v4l1 read / mmap mode
>> * camorama including changing capture resolution while streaming
>>
>> Work fine, note with some cams camorama might need a small bugfix though,
>> as it
>> assumes that cams have a resolution exactly half of their max resolution
>> available, and as such ignores then width/height returned by VIDEOCSWIN,
>> assuming it got what it asked for, the patch against camorama 0.19
>> attached to
>> my 0.5 announcement mail fixes this.
>>
>> Regards,
>>
>> Hans
>>
> I took a look at your library, seems simple and interesting!
> You are overloading open/close/ioctl/read/mmap and catch these operations
> on /dev/videoX path to do whatever you want, like frame conversion.
> This is a simpler solution than the one on
> http://www.linuxtv.org/v4lwiki/index.php/V4L2UserspaceLibrary
> that is complex and incomplete regarding the implementation, sadly.

> - You said that arts is using the same system. Does it conflict with the
> use of arts from an application point of view?

Not that I know of it also intercepts open and a few others like my lib does, 
also through using LD_PRELOAD, when you've arts installed there is an artsdsp 
command, so to run an app foo which wants to use oss soundoutput though arts 
one could do:
artsdsp foo

And then the artsdsp shell script would set the necessary env. variables 
causing libartsdsp.so.0 to be LD_PRELOAD-ed, intercepting open / write of / to 
/dev/dsp redirecting that to arts.

> - The device driver will still have to declare the compressed pixel
> formats (V4L2_PIX_FMT_MJPEG, ...) to interface the library. The usbvision
> device provides a proprietary pixel format but I cannot name it; how we
> will cope with that?
> 

Just make up your own fourcc code and V4L2_PIX_FMT_MJPEG define and get that 
added to include/linux/videodev2.h (and make your driver report this format) 
after that I would be happy to take patches to add support for this format to 
my wrapper.

In the future I plan to even do v4l2 -> v4l2 emulation doing conversion only, 
so that not all v4l2 apps need to know about all exotic formats like 
usbvision's format.

Regards,

Hans




> Regards,
> Thierry
> 
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
