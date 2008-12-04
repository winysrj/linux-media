Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB4IArLx031736
	for <video4linux-list@redhat.com>; Thu, 4 Dec 2008 13:10:53 -0500
Received: from mail-qy0-f21.google.com (mail-qy0-f21.google.com
	[209.85.221.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB4I9r7N027172
	for <video4linux-list@redhat.com>; Thu, 4 Dec 2008 13:09:53 -0500
Received: by qyk14 with SMTP id 14so4939091qyk.3
	for <video4linux-list@redhat.com>; Thu, 04 Dec 2008 10:09:52 -0800 (PST)
Message-ID: <7d7f2e8c0812041009w487b5aabwaf27d5c7d917b1ab@mail.gmail.com>
Date: Thu, 4 Dec 2008 10:09:52 -0800
From: "Steve Fink" <sphink@gmail.com>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0812040659l2c441ed8mcc9cd00573b3f939@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7d7f2e8c0812032307y3b12f74cr8c00175618add7a1@mail.gmail.com>
	<412bdbff0812040659l2c441ed8mcc9cd00573b3f939@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: v4l support for "Pinnacle PCTV HD Pro USB Stick"
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

Ok, thanks. I guess I'll try returning this one, then.

I wonder if there's any way to apply pressure -- I mean, encouragement
-- to manufacturers to either change model numbers or at least release
serial number ranges or something along with specs for their hardware.
The only reason I bought this device was because it had composite
input and Linux support -- or at least, the earlier version with
exactly the same description did.

I suppose I could take a quick stab at making my app decode the mpeg
frames, but it's really suboptimal for my setup (I am very sensitive
to latency and CPU load.)

Anyway, thanks for your work!
Steve

On Thu, Dec 4, 2008 at 6:59 AM, Devin Heitmueller
<devin.heitmueller@gmail.com> wrote:
> On Thu, Dec 4, 2008 at 2:07 AM, Steve Fink <sphink@gmail.com> wrote:
>> After getting some help from this list, I ended up buying the
>> "Pinnacle PCTV HD Pro USB Stick"
>> <http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_HD_Pro_Stick_(801e)>.
>> Unfortunately, it turned out to be the newer version, which appears to
>> only have DVB support (despite having a cx25843 chip for analog
>> decoding.) Is there any way to access to the raw frames coming from
>> the A/D converter?
>>
>> I've read up on the wiki, and I now understand what DVB stands for.
>> But in practice, it appears that DVB support means you'll get handed
>> encoded mpeg-2 frames, whereas if your device has v4l support, you can
>> get back decoded frames. I want raw frames. I don't want to watch TV;
>> I just want a stream of analog NTSC frames to get digitized and handed
>> over to me via USB. It appears to me that the only driver that
>> supports my device is a DVB driver, but that driver really is just a
>> DVB driver and so won't handle my analog input even though that A/D
>> converter is supported elsewhere for other drivers. Is that accurate,
>> or is there some way of using the dvb-usb stuff to get to the raw
>> digitized stream and start frame grabbing?
>>
>> It's also very possible that I'm completely confused about how
>> everything fits together. Hints appreciated.
>>
>> Thanks,
>> Steve
>>
>> (argh -- I wonder if I can return this damn tv stick...)
>
> No Steve, you're not confused.  I only implemented the digital
> ATSC/QAM support on the stick and not the analog support.  This was
> because the framework used for the dibcom driver doesn't currently
> have analog support, so it will be a significant amount of work.  If
> the dibcom framework gets analog support, then making this device work
> within that framework would be relatively simple.
>
> The LinuxTV wiki does properly reflect the status of the device.
>
> Devin
>
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
