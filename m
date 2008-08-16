Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7G7rGAK010128
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 03:53:16 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7G7r2UA024381
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 03:53:02 -0400
Message-ID: <48A689C1.7070007@hhs.nl>
Date: Sat, 16 Aug 2008 10:03:13 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Mark Ferrell <majortrips@gmail.com>
References: <20080816050023.GB30725@thumper> <48A67A8D.8040104@hhs.nl>
	<7813ee860808160046s60de698bu307ab5255631a5e@mail.gmail.com>
In-Reply-To: <7813ee860808160046s60de698bu307ab5255631a5e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] Add support for OmniVision OV534 based USB cameras.
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

Mark Ferrell wrote:
> On Sat, Aug 16, 2008 at 08:58:21AM +0200, Hans de Goede wrote:
>> majortrips@gmail.com wrote:
>>> Adds suport for OmniVision OV534 based cameras:
>>>  - Hercules Blog Webcam
>>>  - Hercules Dualpix HD Webcam
>>>  - Sony HD PS3 Eye (SLEH 00201)
>>> Currently only supports 640x480 YUYV non-interlaced output.
>>> Signed-off-by: Mark Ferrell <majortrips@gmail.com>
>> Hi Mark,
>>
>> Have you taken a look at the ov519 driver which is currently in gspca,
>> which is  in 2.6.27rc1 and more general (latest version) available here:
>> http://linuxtv.org/hg/~jfrancois/gspca/
>>
>> That driver does do jpeg, maybe it can give some clues. gspca is a webcam
>> driver framework. Would you consider porting your driver to gspca, I (we ?)
>> really want to see all usb webcam drivers start using the gspca framework
>> to share as much code as possible.
> 
> I would definitely be willing to merge the code into an existing driver,
> though I was under the impression that the gspca core was for ISOC based
> USB devices.  The ov534's imagine end-point is bulk transfer, with the
> audio endpoints being isoc.
> 

Ah yes it is I didn't know non isoc cams existed, so thats why your driver is 
so small I already was sorta missing the isoc setup stufff :)

In that case its fine as is. Mauro as this is a new driver and looks clean (and 
uses videobuf) any chance this can get merged for 2.6.27 ?

I'll work together with Mark on getting YUYV support added to libv4l so that 
userspace support is taken care of.

>>> +The ov534 outputs frames in YUYV format, non-interlaced, at 640x480. This
>>> +format does not yet have wide support among user-land applications.
>>> Though at
>>> +the time of this writing xawtv was known to work correctly.
>>> +
>> This (custom cam formats) was a big problem with gspca too, for this I've
>> written libv4l, which is a library which does format conversion from many
>> cam specific formats to more general formats in userspace. A joined effort
>> between Debian, Suse and Fedora is currently working on making all v4l apps
>> use libv4l, patches have already been written for gstreamer (cheese), pwlib
>> (ekiga) and xawtv.
>>
>> For more on libv4l see:
>> http://hansdegoede.livejournal.com/3636.html
>> http://linuxtv.org/v4lwiki/index.php/Libv4l_Progress
>>
>> Maybe you can write a patch to add YUYV input support to libv4l, if you do
>> that please base your work on the latest version which is available here:
>> http://linuxtv.org/hg/~hgoede/v4l-dvb
> 
> Thanks, will take a look.
> 

Let me know how it goes. I'll gladly help where I can, but I prefer people with 
hardware to test to write the actual code. All you need todo is add support for 
YUYV to libv4lconvert/libv4lconvert.c and add a file under libv4lconvert with 
the actual conversion routines. Also take a good look at libv4lconvert/rgbyuv.c 
for some good inspiration for the YUV->RGB conversion routines.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
