Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n02Gt1IV012807
	for <video4linux-list@redhat.com>; Fri, 2 Jan 2009 11:55:01 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.231])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n02GoLwn016206
	for <video4linux-list@redhat.com>; Fri, 2 Jan 2009 11:54:48 -0500
Received: by rv-out-0506.google.com with SMTP id f6so6783351rvb.51
	for <video4linux-list@redhat.com>; Fri, 02 Jan 2009 08:50:17 -0800 (PST)
Message-ID: <c785bba30901020850y51c7b9d2i47fd418828cd150c@mail.gmail.com>
Date: Fri, 2 Jan 2009 09:50:17 -0700
From: "Paul Thomas" <pthomas8589@gmail.com>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0812311452o64538cdav4b948f6a9214ccdd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c785bba30812301646vf7572dcua9361eb10ec58716@mail.gmail.com>
	<c785bba30812311220pc0a5143i67101e896b62e870@mail.gmail.com>
	<c785bba30812311258v1349ecb2pa95cd4ffbcf523c1@mail.gmail.com>
	<412bdbff0812311323rd83eac8l35f29195b599d3e@mail.gmail.com>
	<c785bba30812311330w26ce5817l10db52d5be98d175@mail.gmail.com>
	<412bdbff0812311420n3f42e13ew899be73cd855ba5d@mail.gmail.com>
	<c785bba30812311424r87bd070v9a01828c77d6a2a6@mail.gmail.com>
	<412bdbff0812311435n429787ecmbcab8de00ba05b6b@mail.gmail.com>
	<c785bba30812311444l65b3825aq844b79dd6f420c09@mail.gmail.com>
	<412bdbff0812311452o64538cdav4b948f6a9214ccdd@mail.gmail.com>
Cc: video4linux-list <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: em28xx issues
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

On Wed, Dec 31, 2008 at 3:52 PM, Devin Heitmueller
<devin.heitmueller@gmail.com> wrote:
> On Wed, Dec 31, 2008 at 5:44 PM, Paul Thomas <pthomas8589@gmail.com> wrote:
>> How was it working with Skype? Can we hard code the settings for testing?
>>
>> thanks,
>> Paul
>
> Well, regardless of the device profile issue, it's not clear why it is
> segfaulting.  In theory, it should work but you should only get a
> single input available instead of being able to pick between composite
> and s-video.
>
> I think with this device you should be able to set a modprobe option
> for "debug=1" which might provide a bit more insight.
>
> Try this.  Unplug the device, run "make unload", and then "modprobe
> em28xx".  Then plug the device in.  You should start seeing more info
> in the dmesg output.  Then start the app that segfaults and report the
> dmesg contents.
>
> Devin
>
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
>

Thanks CityK. I was able to enable core_debug=1. Here is what I have
in dmesg after I camstream seg faults:

Em28xx: Initialized (Em28xx Audio Extension) extension
em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,72)
em28xx #0 em28xx_uninit_isoc :em28xx: called em28xx_uninit_isoc
em28xx #0 em28xx_uninit_isoc :em28xx: called em28xx_uninit_isoc
em28xx #0 em28xx_set_alternate :minimum isoc packet size: 2888 (alt=6)
em28xx #0 em28xx_set_alternate :setting alternate 6 with wMaxPacketSize=2892
em28xx #0 em28xx_accumulator_set :em28xx Scale: (1,1)-(179,71)
em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,72)
em28xx #0 em28xx_uninit_isoc :em28xx: called em28xx_uninit_isoc
em28xx #0 em28xx_set_alternate :minimum isoc packet size: 2888 (alt=6)
em28xx #0 em28xx_set_alternate :setting alternate 6 with wMaxPacketSize=2892
em28xx #0 em28xx_accumulator_set :em28xx Scale: (1,1)-(179,71)
em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,72)
em28xx #0 em28xx_init_isoc :em28xx: called em28xx_prepare_isoc
em28xx #0 em28xx_uninit_isoc :em28xx: called em28xx_uninit_isoc
camstream[18436]: segfault at 0 ip 000000000043ea76 sp
00007fff1ca5d7a8 error 6 in camstream[400000+5a000]
em28xx #0 em28xx_uninit_isoc :em28xx: called em28xx_uninit_isoc
em28xx #0 em28xx_irq_callback :urb resubmit failed (error=-1)
em28xx #0 em28xx_irq_callback :urb resubmit failed (error=-1)
em28xx #0 em28xx_irq_callback :urb resubmit failed (error=-1)
em28xx #0 em28xx_irq_callback :urb resubmit failed (error=-1)
em28xx #0 em28xx_irq_callback :urb resubmit failed (error=-1)

thanks,
Paul

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
