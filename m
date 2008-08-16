Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7G7kdob008449
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 03:46:39 -0400
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.182])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7G7kI09020245
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 03:46:18 -0400
Received: by wa-out-1112.google.com with SMTP id j32so2111970waf.7
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 00:46:18 -0700 (PDT)
Message-ID: <7813ee860808160046s60de698bu307ab5255631a5e@mail.gmail.com>
Date: Sat, 16 Aug 2008 02:46:18 -0500
From: "Mark Ferrell" <majortrips@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <48A67A8D.8040104@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080816050023.GB30725@thumper> <48A67A8D.8040104@hhs.nl>
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

On Sat, Aug 16, 2008 at 08:58:21AM +0200, Hans de Goede wrote:
> majortrips@gmail.com wrote:
>> Adds suport for OmniVision OV534 based cameras:
>>  - Hercules Blog Webcam
>>  - Hercules Dualpix HD Webcam
>>  - Sony HD PS3 Eye (SLEH 00201)
>> Currently only supports 640x480 YUYV non-interlaced output.
>> Signed-off-by: Mark Ferrell <majortrips@gmail.com>
>
> Hi Mark,
>
> Have you taken a look at the ov519 driver which is currently in gspca,
> which is  in 2.6.27rc1 and more general (latest version) available here:
> http://linuxtv.org/hg/~jfrancois/gspca/
>
> That driver does do jpeg, maybe it can give some clues. gspca is a webcam
> driver framework. Would you consider porting your driver to gspca, I (we ?)
> really want to see all usb webcam drivers start using the gspca framework
> to share as much code as possible.

I would definitely be willing to merge the code into an existing driver,
though I was under the impression that the gspca core was for ISOC based
USB devices.  The ov534's imagine end-point is bulk transfer, with the
audio endpoints being isoc.

>> +The ov534 outputs frames in YUYV format, non-interlaced, at 640x480. This
>> +format does not yet have wide support among user-land applications.
>> Though at
>> +the time of this writing xawtv was known to work correctly.
>> +
>
> This (custom cam formats) was a big problem with gspca too, for this I've
> written libv4l, which is a library which does format conversion from many
> cam specific formats to more general formats in userspace. A joined effort
> between Debian, Suse and Fedora is currently working on making all v4l apps
> use libv4l, patches have already been written for gstreamer (cheese), pwlib
> (ekiga) and xawtv.
>
> For more on libv4l see:
> http://hansdegoede.livejournal.com/3636.html
> http://linuxtv.org/v4lwiki/index.php/Libv4l_Progress
>
> Maybe you can write a patch to add YUYV input support to libv4l, if you do
> that please base your work on the latest version which is available here:
> http://linuxtv.org/hg/~hgoede/v4l-dvb

Thanks, will take a look.


-- Mark Ferrell

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
