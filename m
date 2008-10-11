Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9BICs5W025292
	for <video4linux-list@redhat.com>; Sat, 11 Oct 2008 14:12:54 -0400
Received: from smtp4.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9BICb63022408
	for <video4linux-list@redhat.com>; Sat, 11 Oct 2008 14:12:39 -0400
Message-ID: <48F0ED20.2010809@hhs.nl>
Date: Sat, 11 Oct 2008 20:14:56 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
References: <bug-11741-10286@http.bugzilla.kernel.org/>
	<20081011103612.efa9beaa.akpm@linux-foundation.org>
In-Reply-To: <20081011103612.efa9beaa.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-usb@vger.kernel.org,
	bugme-daemon@bugzilla.kernel.org, michael.letzgus@uni-bielefeld.de
Subject: Re: [Bugme-new] [Bug 11741] New: Webcam: Logitech QuickCam
 Communicate won't work with 2.6.27
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

Andrew Morton wrote:
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
> 
> On Sat, 11 Oct 2008 10:13:36 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
> 
>> http://bugzilla.kernel.org/show_bug.cgi?id=11741
>>
>>            Summary: Webcam: Logitech QuickCam Communicate won't work with
>>                     2.6.27
>>            Product: Drivers
>>            Version: 2.5
>>      KernelVersion: 2.6.27
>>           Platform: All
>>         OS/Version: Linux
>>               Tree: Mainline
>>             Status: NEW
>>           Severity: high
>>           Priority: P1
>>          Component: Other
>>         AssignedTo: drivers_other@kernel-bugs.osdl.org
>>         ReportedBy: michael.letzgus@uni-bielefeld.de
>>
>>
>> Latest working kernel version: 2.6.26.2 + additional GSPCA
>> Earliest failing kernel version: 2.6.27 (with internal GSPCA)
> 
> It's a regression.
> 

Nack, GSPCAv1 was never part of the official kernel, so the cam did not work 
*at all* with the previous official kernel, this is not a regression. Also see 
below about features which gscpa as in kernel misses compared to the old one, 
where the missing of this features actually is a feature.

>> Distribution: Debian lenny
>> Hardware Environment: AMD64, Core2Duo
>>
>> Problem Description:
>>
>> Camera does not work!
> 
> Is it due to DVB or to USB?
> 

??

Its a USB cam.

>> Trying "camstream":
>>  VDLinux::run() VIDIOCMCAPTURE failed (Invalid argument)
>>  run(): VIDIOCSYNC(1) failed (Invalid argument)
>>

That is because camstream is a v4l1 application and the new gspca is a v4l2 
driver. Besides that camstream does not support the JPEG image format produced 
by zc3xxx cam's such as yours. gspcav1 (the out of tree version) used to do 
JPEG decompression in kernelspace and happily offer RGB format data to 
applications, even though the cam does not, doing in kernel format conversion 
and esp. decompression is completely unacceptable, this clearly belongs in 
userspace.

I've written a userspace library which handles the format conversion in 
userspace, and which can be used as a libc library wrapper to transparently do 
format conversion for apps which need this. As an added bonus it can also 
emulate the v4l1 API on top of v4l2 devices, see:
http://hansdegoede.livejournal.com/3636.html
Download the latest version here:
http://people.atrpms.net/~hdegoede/libv4l-0.5.0.tar.gz
And see the README for installation instructions, then LD_PRELOAD v4l1compat.so 
and camstream should work fine. Note that work is underway to write patches for 
all FOSS v4l using apps to use libv4l directly so that LD_PRELOAD wont be 
necessary, see:
http://linuxtv.org/v4lwiki/index.php/Libv4l_Progress

Also note that the Ubuntu devs are aware they need to patch all their apps to 
use libv4l to work seamlessly with cams supported by the new gspca when moving 
to 2.6.27. I'm very certain they know this as I personally told their 
kerneldevs this at the Plumbers conference.

>> Skype:
>>  No error message but colorful noise instead of input signal
>>

I don't know what skype does at it is closed source, I do know many people have 
successfully used it with the new gspca in combination with LD_PRELOAD 
v4l1compat.so

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
