Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8JKha7D023368
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 16:43:36 -0400
Received: from d1.scratchtelecom.com (69.42.52.179.scratchtelecom.com
	[69.42.52.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8JKhM2s003478
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 16:43:22 -0400
Date: Fri, 19 Sep 2008 16:43:15 -0400 (EDT)
From: Keith Lawson <lawsonk@lawson-tech.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0809191331i4a9d6767s2a5477486a84e19e@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0809191642390.19977@vegas>
References: <alpine.DEB.1.10.0809191623050.19977@vegas>
	<412bdbff0809191331i4a9d6767s2a5477486a84e19e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: video4linux-list@redhat.com
Subject: Re: tm6000 load errors
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



On Fri, 19 Sep 2008, Devin Heitmueller wrote:

> Try rebooting your PC.  In many cases this is caused by the videobuf
> module already being loaded, and when you did a "make install" you
> ended up with a mix of new modules running as well as modules that
> were already loaded (and make install doesn't unload existing
> modules).
>
> Devin
>

DOH, that was it. Thanks for the quick response.

> On Fri, Sep 19, 2008 at 4:27 PM, Keith Lawson <lawsonk@lawson-tech.com> wrote:
>> Hello,
>>
>> I'm attempting to get a Diamond VC500 USB capture device working. I opened
>> the device and it has a TM5600 chipset so I grabbed the experimental drivers
>> from http://linuxtv.org/hg/~mchehab/tm6010. I copied my kernel .conf to the
>> v4l directory and did "make kernel-links, make, make install" but when I do
>> a "modprobe tm6000" I get the following output in dmesg:
>>
>> tm6000: disagrees about version of symbol video_ioctl2
>> tm6000: Unknown symbol video_ioctl2
>> tm6000: disagrees about version of symbol v4l2_type_names
>> tm6000: Unknown symbol v4l2_type_names
>> tm6000: disagrees about version of symbol video_unregister_device
>> tm6000: Unknown symbol video_unregister_device
>> tm6000: disagrees about version of symbol video_device_alloc
>> tm6000: Unknown symbol video_device_alloc
>> tm6000: disagrees about version of symbol video_register_device
>> tm6000: Unknown symbol video_register_device
>> tm6000: disagrees about version of symbol video_device_release
>> tm6000: Unknown symbol video_device_release
>>
>> Did I build the module incorrectly?
>>
>> I'm also having trouble finding the firmware file for the device, can anyone
>> point me in the right direction for that?
>>
>> TIA,
>> Keith.
>>
>> --
>> video4linux-list mailing list
>> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>
>
>
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
