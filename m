Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAJ8d7Bn006938
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 03:39:07 -0500
Received: from smtp4.versatel.nl (smtp4.versatel.nl [62.58.50.91])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAJ8aZci014689
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 03:36:35 -0500
Message-ID: <4923D159.9070204@hhs.nl>
Date: Wed, 19 Nov 2008 09:42:01 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Adam Baker <linux@baker-net.org.uk>
References: <mailman.208512.1227000563.24145.sqcam-devel@lists.sourceforge.net>
	<Pine.LNX.4.64.0811181216270.2778@banach.math.auburn.edu>
	<200811190020.15663.linux@baker-net.org.uk>
In-Reply-To: <200811190020.15663.linux@baker-net.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, sqcam-devel@lists.sourceforge.net,
	kilgota@banach.math.auburn.edu
Subject: Re: [sqcam-devel] Advice wanted on producing an in kernel sq905
	driver
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



Adam Baker wrote:

<huge snip>

>>> First off some thoughts on how I'd like to proceed.
>>>
>>> The chip exposes the Bayer sensor output directly to the driver so the
>>> current driver uses code borrowed from libgphoto2 to do the Bayer decode
>>> in kernel. Obviously this is wrong and now we have libv4l it should use
>>> that instead.
>> Ah, Bayer demosaicing. I wonder if my new demosaicing algorithm for
>> libgphoto2 could run fast enough to work for a webcam, or at least for a
>> slow webcam. It does give much better output for still shots.
>>
> 
> The out of kernel code has just copy and pasted from libgphoto2 for the Bayer 
> demosaicing but if I rely on libv4l this becomes Hans de Goede's problem to 
> select the best algorithm, not mine.
> 

libv4l currently uses linear interpolated demosaicing, the 4 (or 2) surrounding 
pixels with the missing color components are taken and then straight forward 
averaged. At the borders only those pixels which are actually present get used 
ofcourse.

This works pretty good and is reasonable fast, I don't want to add a zillion 
demosaicing algorithms to libv4l and keep in mind that webcams which produce 
raw bayer in general are real cheap and have matching have poor image quality, 
so using some highly advanced bayer algorithm is not going to help. Also keep 
in mind some demosaicing algorithms are patented.

I'm always open for convincing examples of differences in algorithms, esp. when 
backed up with a proposed patch and benchmarks showing the additional costs.

>>> 3) The current driver needs to do some up/down and left/right flips of
>>> the data to get it in the right order to do the Bayer decode that depend
>>> on the version info the camera returns to its init sequence.
>> That is correct. If you don't know which camera it is, then you cannot
>> correctly process the images because of these orientation issues. The
>> Bayer tiling scheme also is dependent on the model version number, so if
>> this is not accounted for then the colors will be wrong as well as the
>> orientation.
>>
>> Should that code remain
>>
>>> in the driver and if not how should the driver communicate what is
>>> needed.
>> My two cents is that you have to read the version number and make the
>> appropriate use of that information. There is no other way to communicate
>> what is needed.
>>
> 
> I clearly have to read the version and either flip the data myself or inform 
> libv4l that it needs to be flipped. The do as much work in userspace as 
> possible argument says I should just provide an indicator that it needs 
> flipping but I don't know how to do that.
> 

Ah interesting, 2 things:

1) Do not do the flipping in the kernel libv4l already has all the necessary
    code.

2) Currently there is no API for telling libv4l to do the flipping, but I think
    we should design one. Currently for the few cams which need software
    flipping (or rather software rotate 180 as that is what libv4l does), are
    detected by libv4l by doing string comparisons on the v4l2_capability struct
    card string. We could cheat and let the sq905 driver put something special
    in there for cams with upside down mounted sensors, but given that this is a
    re-occuring problem, defining a proper API for this would be good I think.

<snip>

>>> And then make sure your applications are either patched to use libv4l, or
>>> use the LD_PRELOAD libc wrapper (see libv4l docs).
>>>
> 
> I've been testing with LD_PRELOAD but discovered it was rejecting the camera 
> because the current driver doesn't support mmap for V4L2 so doesn't set the 
> streaming flag.
> 

Correct libv4l only works with v4l2 devices which do mmap (and will happily 
emulate read() access on top of that).


>>>> 2) The existing driver needed to perform a gamma adjustment after
>>>> performing the Bayer decode. I couldn't find anything in libv4l that
>>>> obviously did that so I'm guessing it isn't needed for existing devices
>>>> - should that be added to libv4l if needed and if so how should the
>>>> driver indicate it is needed - could it be indicated with a new value
>>>> for v4l2_colorspace?
>>> Hmm interesting for now lets ignore this and first get it up and running
>>> without this, and the revisit this. I'm asking for this because gamma
>>> correction might be interesting for other cams too, so I would like to
>>> see a generic solution for this, which will take some design work, etc.
> 
> OK, I wondered if anyone else might be able to make use of it. The 
> implementation in the current driver is just a single fixed correction. There 
> is a version at http://philippe.corbes.free.fr/sqcam/ in which someone has 
> implemented 8 gamma tables selected by VIDIOCSPICT (that driver is pure V4L1) 
> but libv4l is allowed to use floating point so could calculate the table on 
> the fly upon receiving an ioctl. This doesn't sound too hard to add to libv4l 
> if needed - the only problem is in selecting an appropriate initial value as 
> that may be camera dependent.
> 

Yes, what we are seeing with libv4l and webcams is that there are a lot of 
things, which libv4l needs to know about the cam and the current API doesn't 
give us, like:
-does this cam need software whitebalance
-does this cam need software auto exposure
-does this cam need gamma correction, and what initial gamma to use
-if the sensor is mounted upside down, and the hardware cannot flip the image
  itself

And this are just a few examples. I've been thinking about ways to use the 
existing API for some of these, but others are more trouble some to fit into 
the existing API.

I will send an RFC for this problem to video4linux-list@redhat.com, please 
comment on it :)

>>>> 3) The current driver needs to do some up/down and left/right flips of
>>>> the data to get it in the right order to do the Bayer decode that depend
>>>> on the version info the camera returns to its init sequence. Should that
>>>> code remain in the driver and if not how should the driver communicate
>>>> what is needed.
>>> It should communicate what is needed all possible bayer orders are
>>> covered by the 4 formats I gave above, and libv4l knows how to handle all
>>> 4 of them, for the defines of the last 2 see
>>> libv4lconvert/libv4lconvert-priv.h
> 
> This isn't just a question of Bayer selection, the image will be upside down 
> and possibly mirror imaged too. The question is mainly one of how can the 
> driver communicate such info to libv4l.
> 

Ack.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
