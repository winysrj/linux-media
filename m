Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAP7wdnT006124
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 02:58:39 -0500
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAP7vg3i024205
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 02:57:42 -0500
Message-ID: <492BB15B.7030202@hhs.nl>
Date: Tue, 25 Nov 2008 09:03:39 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: kilgota@banach.math.auburn.edu
References: <mailman.208512.1227000563.24145.sqcam-devel@lists.sourceforge.net>
	<49269369.90805@hhs.nl>
	<Pine.LNX.4.64.0811211244120.4475@banach.math.auburn.edu>
	<200811212157.21254.linux@baker-net.org.uk>
	<Pine.LNX.4.64.0811211658290.4727@banach.math.auburn.edu>
	<492A8E76.3070701@redhat.com>
	<Pine.LNX.4.64.0811241446210.6862@banach.math.auburn.edu>
In-Reply-To: <Pine.LNX.4.64.0811241446210.6862@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Hans de Goede <hdegoede@redhat.com>, video4linux-list@redhat.com,
	sqcam-devel@lists.sourceforge.net
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

kilgota@banach.math.auburn.edu wrote:
> 
> 
> On Mon, 24 Nov 2008, Hans de Goede wrote:
<snip>

>> I've been thinking along similar lines (keeping /dev/videoX present 
>> when using the still image function). But thinking about this some 
>> more I don't think this is worth the trouble. A camera which can do 
>> both still images and function as webcam really is a multifunction 
>> device, with one function active at a time, this is just like any usb 
>> device with multiple usb configurations,
> 
> Ah, but the problem is that USB devices which are "good citizens" 
> usually have a different Product number when running in different modes.
> 

Well, that would make things consistent then with my proposal for cams who hide 
multiple functions behind one ID, if one function is used, the other 
disappears, including the /dev/videoX device.

>> and when you change the configuration certain functionality becomes 
>> not available and other becomes available. If this cam would be 
>> correctly using usb configuaration profiles for this, the /dev/videoX 
>> would also disappear.
>>
>> Also by just unloading the driver removing /dev/videoX things stay KISS.
> 
> Well, I am not sure that this is simpler, actually, which is why I 
> brought the subject up for discussion.
> 

Well, drivers need to handle disconnect anyways, so this requires no additional 
code from the driver, how simple do you want it to be ?

>>
>> Last it is not that strange for the webcam not to show up as a webcam 
>> to choose from for use in a webcam app, when you've got a photo app 
>> open for importing photo's (and when the import dialog is closed the 
>> device should be given back to the /dev/videoX driver).
>>
>> So all in all I believe that having some mechanism:
>> -to unload the driver when libusb wants access *AND*
>> -reload it when libusb is done
> 
> This does not address the question of whether the owner of the machine 
> wants the kernel module installed, or not. I can imagine that the owner 
> might not be interested at all in loading the module if said owner is 
> not interested in running the camera as a webcam. I can also imagine 
> that the outcome is
> 

If you look at any up2date Linux distro, all drivers for all available hardware 
will get loaded. This is just how things work now a days, and this is the right 
thing todo for 99.99 % of all users. And I really don't care about that other 
0.01 %

> 1. owner gets still photos off the camera.
> 2. owner exits from photo-getting app
> 3. libgphoto2 releases the camera, and libusb loads the kernel module -- 
> which was, prior to (1), *not* loaded.

No, as Adam explained libgphoto would trigger a rescanning of the usb bus, if 
the driver was not loaded at plugin / boot because it was blacklisted for 
example, the rescan wont load it either.

But this is a corner case. One should never design / optimize for corner case. 
Design / optimize for the straight path / normal expected use scenario and then 
  see what needs and can be done for special cases.

> 
>>
>> Is enough, and is nice and KISS, which I like.
> 
> 
> Yeah. I just love to have modules installed to support hardware which I 
> do not intend to use. Don't we all? ;)

Erm, yes we do all love that, because then when I do decide to buy a bluetooth 
gizmo, even though I did not have any use for the entire bluetooth stack being 
loaded on my desktop before, now all of a sudden it works out of the box.

I'm sorry but not loading modules is something from a recent past, we just 
don't do that anymore. Just like almost no one builds its own kernels now.

> What is "simple" about that?

That if I decide to change my mind and use the functionality after all things 
will just work.

> If I 
> am running some low-powered piece of hardware, why would I want all 
> kinds of support for devices X, Y, and Z installed in the kernel unless 
> and until I am actually going to use one of them?
> 

If you run on a low-powered piece of hardware, you will need a custom distro 
anyways.

> The ideal solution probably can not work for ten thousand good reasons, 
> but what ought to happen is that a libgphoto2-based app could turn off 
> or remove the module (unless the module is in use), and an app requiring 
> the kernel module could cause it to be installed, unless the device is 
> in use by some app already. This would actually be most ideal and would 
> make it unnecessary for libusb to install kernel modules which, perhaps, 
> no one is going to use during the next week after installation.
> 

No, that will never work, because now a days we have a model where drivers gets 
loaded when hardware is detected, not when apps need the functionality. This 
allows applications to ask the system which devices are present. Since 
applications now ask the system which devices are present, they cannot tell it 
to load the driver, otherwise we get a classic chicken and egg problem.

> So in other words the ability of libusb to load up a kernel module is 
> another trick which may alleviate the problem for some people, but does 
> not solve the problem. Not yet.

I disagree, it is not a trick, it is a nice and very *simple* solution. Maybe 
I'm wring, time will tell then and then we can start thinking about more 
complex solutions, for now this seems the way forward to me.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
