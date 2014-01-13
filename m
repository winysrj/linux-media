Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:18052 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaAMRX7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 12:23:59 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZC00GFSOBX5N70@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 Jan 2014 12:23:58 -0500 (EST)
Date: Mon, 13 Jan 2014 15:23:50 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 3/6] DocBook media: partial rewrite of
 "Opening and Closing Devices"
Message-id: <20140113152350.1ab23491@samsung.com>
In-reply-to: <52D4112C.5040902@xs4all.nl>
References: <1389100017-42855-1-git-send-email-hverkuil@xs4all.nl>
 <1389100017-42855-4-git-send-email-hverkuil@xs4all.nl>
 <20140113132013.06f558a0@samsung.com> <52D4112C.5040902@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 13 Jan 2014 17:15:40 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 01/13/2014 04:20 PM, Mauro Carvalho Chehab wrote:
> > Em Tue,  7 Jan 2014 14:06:54 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > 
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> This section was horribly out of date. A lot of references to old and
> >> obsolete behavior have been dropped.

Forgot to mention, put patches 1 and 2 are ok. I'll review the patches 4-6
later this week.

> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >>  Documentation/DocBook/media/v4l/common.xml | 188 ++++++++++-------------------
> >>  1 file changed, 67 insertions(+), 121 deletions(-)
> >>
> >> diff --git a/Documentation/DocBook/media/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
> >> index 1ddf354..da08df9 100644
> >> --- a/Documentation/DocBook/media/v4l/common.xml
> >> +++ b/Documentation/DocBook/media/v4l/common.xml
> >> @@ -38,70 +38,41 @@ the basic concepts applicable to all devices.</para>
> >>  
> >>        <para>V4L2 drivers are implemented as kernel modules, loaded
> >>  manually by the system administrator or automatically when a device is
> >> -first opened. The driver modules plug into the "videodev" kernel
> >> +first discovered. The driver modules plug into the "videodev" kernel
> >>  module. It provides helper functions and a common application
> >>  interface specified in this document.</para>
> >>  
> >>        <para>Each driver thus loaded registers one or more device nodes
> >> -with major number 81 and a minor number between 0 and 255. Assigning
> >> -minor numbers to V4L2 devices is entirely up to the system administrator,
> >> -this is primarily intended to solve conflicts between devices.<footnote>
> >> -	  <para>Access permissions are associated with character
> >> -device special files, hence we must ensure device numbers cannot
> >> -change with the module load order. To this end minor numbers are no
> >> -longer automatically assigned by the "videodev" module as in V4L but
> >> -requested by the driver. The defaults will suffice for most people
> >> -unless two drivers compete for the same minor numbers.</para>
> >> -	</footnote> The module options to select minor numbers are named
> >> -after the device special file with a "_nr" suffix. For example "video_nr"
> >> -for <filename>/dev/video</filename> video capture devices. The number is
> >> -an offset to the base minor number associated with the device type.
> >> -<footnote>
> >> -	  <para>In earlier versions of the V4L2 API the module options
> >> -where named after the device special file with a "unit_" prefix, expressing
> >> -the minor number itself, not an offset. Rationale for this change is unknown.
> >> -Lastly the naming and semantics are just a convention among driver writers,
> >> -the point to note is that minor numbers are not supposed to be hardcoded
> >> -into drivers.</para>
> >> -	</footnote> When the driver supports multiple devices of the same
> >> -type more than one minor number can be assigned, separated by commas:
> >> -<informalexample>
> >> +with major number 81 and a minor number between 0 and 255. Minor numbers
> >> +are allocated dynamically unless the kernel is compiled with the kernel
> >> +option CONFIG_VIDEO_FIXED_MINOR_RANGES. In that case minor numbers are
> >> +allocated in ranges depending on the device node type (video, radio, etc.).</para>
> >> +
> >> +      <para>Many drivers support "video_nr", "radio_nr" or "vbi_nr"
> >> +module options to select specific video/radio/vbi node numbers. This allows
> >> +the user to request that the device node is named e.g. /dev/video5 instead
> >> +of leaving it to chance. When the driver supports multiple devices of the same
> >> +type more than one device node number can be assigned, separated by commas:
> >> +	<informalexample>
> >>  	  <screen>
> >> -&gt; insmod mydriver.o video_nr=0,1 radio_nr=0,1</screen>
> >> +&gt; modprobe mydriver video_nr=0,1 radio_nr=0,1</screen>
> >>  	</informalexample></para>
> >>  
> >>        <para>In <filename>/etc/modules.conf</filename> this may be
> >>  written as: <informalexample>
> >>  	  <screen>
> >> -alias char-major-81-0 mydriver
> >> -alias char-major-81-1 mydriver
> >> -alias char-major-81-64 mydriver              <co id="alias" />
> >> -options mydriver video_nr=0,1 radio_nr=0,1   <co id="options" />
> >> +options mydriver video_nr=0,1 radio_nr=0,1
> >>  	  </screen>
> >> -	  <calloutlist>
> >> -	    <callout arearefs="alias">
> >> -	      <para>When an application attempts to open a device
> >> -special file with major number 81 and minor number 0, 1, or 64, load
> >> -"mydriver" (and the "videodev" module it depends upon).</para>
> >> -	    </callout>
> >> -	    <callout arearefs="options">
> >> -	      <para>Register the first two video capture devices with
> >> -minor number 0 and 1 (base number is 0), the first two radio device
> >> -with minor number 64 and 65 (base 64).</para>
> >> -	    </callout>
> >> -	  </calloutlist>
> >> -	</informalexample> When no minor number is given as module
> >> -option the driver supplies a default. <xref linkend="devices" />
> >> -recommends the base minor numbers to be used for the various device
> >> -types. Obviously minor numbers must be unique. When the number is
> >> -already in use the <emphasis>offending device</emphasis> will not be
> >> -registered. <!-- Blessed by Linus Torvalds on
> >> -linux-kernel@vger.kernel.org, 2002-11-20. --></para>
> >> -
> >> -      <para>By convention system administrators create various
> >> -character device special files with these major and minor numbers in
> >> -the <filename>/dev</filename> directory. The names recommended for the
> >> -different V4L2 device types are listed in <xref linkend="devices" />.
> >> +	</informalexample> When no device node number is given as module
> >> +option the driver supplies a default.</para>
> >> +
> >> +      <para>Normally udev will create the device nodes in /dev automatically
> >> +for you. If udev is not installed, then you need to enable the
> >> +CONFIG_VIDEO_FIXED_MINOR_RANGES kernel option in order to be able to correctly
> >> +relate a minor number to a device node number. I.e., you need to be certain
> >> +that minor number 5 maps to device node name video5. With this kernel option
> >> +different device types have different minor number ranges. These ranges are
> >> +listed in <xref linkend="devices" />.
> >>  </para>
> >>  
> >>        <para>The creation of character special files (with
> >> @@ -110,63 +81,40 @@ devices cannot be opened by major and minor number. That means
> >>  applications cannot <emphasis>reliable</emphasis> scan for loaded or
> >>  installed drivers. The user must enter a device name, or the
> >>  application can try the conventional device names.</para>
> >> -
> >> -      <para>Under the device filesystem (devfs) the minor number
> >> -options are ignored. V4L2 drivers (or by proxy the "videodev" module)
> >> -automatically create the required device files in the
> >> -<filename>/dev/v4l</filename> directory using the conventional device
> >> -names above.</para>
> >>      </section>
> >>  
> >>      <section id="related">
> >>        <title>Related Devices</title>
> >>  
> >> -      <para>Devices can support several related functions. For example
> >> -video capturing, video overlay and VBI capturing are related because
> >> -these functions share, amongst other, the same video input and tuner
> >> -frequency. V4L and earlier versions of V4L2 used the same device name
> >> -and minor number for video capturing and overlay, but different ones
> >> -for VBI. Experience showed this approach has several problems<footnote>
> >> -	  <para>Given a device file name one cannot reliable find
> >> -related devices. For once names are arbitrary and in a system with
> >> -multiple devices, where only some support VBI capturing, a
> >> -<filename>/dev/video2</filename> is not necessarily related to
> >> -<filename>/dev/vbi2</filename>. The V4L
> >> -<constant>VIDIOCGUNIT</constant> ioctl would require a search for a
> >> -device file with a particular major and minor number.</para>
> >> -	</footnote>, and to make things worse the V4L videodev module
> >> -used to prohibit multiple opens of a device.</para>
> >> -
> >> -      <para>As a remedy the present version of the V4L2 API relaxed the
> >> -concept of device types with specific names and minor numbers. For
> >> -compatibility with old applications drivers must still register different
> >> -minor numbers to assign a default function to the device. But if related
> >> -functions are supported by the driver they must be available under all
> >> -registered minor numbers. The desired function can be selected after
> >> -opening the device as described in <xref linkend="devices" />.</para>
> >> -
> >> -      <para>Imagine a driver supporting video capturing, video
> >> -overlay, raw VBI capturing, and FM radio reception. It registers three
> >> -devices with minor number 0, 64 and 224 (this numbering scheme is
> >> -inherited from the V4L API). Regardless if
> >> -<filename>/dev/video</filename> (81, 0) or
> >> -<filename>/dev/vbi</filename> (81, 224) is opened the application can
> >> -select any one of the video capturing, overlay or VBI capturing
> >> -functions. Without programming (e.&nbsp;g. reading from the device
> >> -with <application>dd</application> or <application>cat</application>)
> >> -<filename>/dev/video</filename> captures video images, while
> >> -<filename>/dev/vbi</filename> captures raw VBI data.
> >> -<filename>/dev/radio</filename> (81, 64) is invariable a radio device,
> >> -unrelated to the video functions. Being unrelated does not imply the
> >> -devices can be used at the same time, however. The &func-open;
> >> -function may very well return an &EBUSY;.</para>
> >> +      <para>Devices can support several functions. For example
> >> +video capturing, VBI capturing and radio support.</para>
> > 
> > "function" seems to be a poor choice of word here. Ok, it comes from the
> > original text, but it is still not clear.
> > 
> > I would use another word, like "broadcast type", in order to refer to
> > radio, software defined radio, VBI and video.
> 
> I agree that it is not the best word, but neither is (IMHO) "broadcast type".
> This would be something for a follow-up patch.

I think we should use the right word here on this fix. Other suggestions:
	"stream type", "media type".

In any case, we should enumerate all those types here, maybe even putting
them into a table, in order to define precisely to what we're referring to.

> >> +
> >> +      <para>The V4L2 API creates different nodes for each of these functions.
> >> +One exception to this rule is the overlay function: this is shared
> >> +with the video capture node (or video output node for output overlays).</para>
> > 
> > The mention to overlay here is completely out of context, and proofs
> > my point that "function" is a very bad choice: overlay is not a
> > broadcast type. It is just one of the ways to output the data. The same
> > device node can support multiple "delivery types":
> > 	- overlay;
> > 	- dma-buf;
> > 	- mmap;
> > 	- read or write.
> > 
> > Let's not mix those two concepts in the new text.
> > 
> > Also, the delivery type has nothing to do with "Opening and closing devices".
> 
> I like the word "delivery type" in this context and I agree with you here.
> I'll see if I can improve this text.

Thanks!
 
> > 
> >> +
> >> +      <para>The V4L2 API was designed with the idea that one device node could support
> >> +all functions. However, in practice this never worked: this 'feature'
> >> +was never used by applications and many drivers did not support it and if
> >> +they did it was certainly never tested. In addition, switching a device
> >> +node between different functions only works when using the streaming I/O
> >> +API, not with the read()/write() API.</para>
> >> +
> >> +      <para>Today each device node supports just one function, with the
> >> +exception of overlay support.</para>
> >>  
> >>        <para>Besides video input or output the hardware may also
> >>  support audio sampling or playback. If so, these functions are
> >> -implemented as OSS or ALSA PCM devices and eventually OSS or ALSA
> >> -audio mixer. The V4L2 API makes no provisions yet to find these
> >> -related devices. If you have an idea please write to the linux-media
> >> -mailing list: &v4l-ml;.</para>
> >> +implemented as ALSA PCM devices with optional ALSA audio mixer
> >> +devices.</para>
> >> +
> >> +      <para>One problem with all these devices is that the V4L2 API
> >> +makes no provisions to find these related devices. Some really
> >> +complex devices use the Media Controller (see <xref linkend="media_controller" />)
> >> +which can be used for this purpose. But most drivers do not use it,
> >> +and while some code exists that uses sysfs to discover related devices,
> >> +there is no standard library yet. If you want to work on this please write
> >> +to the linux-media mailing list: &v4l-ml;.</para>
> > 
> > Not true. It is there at v4l-utils. Ok, patches are always welcome.
> 
> Well, sort of. That library only handles sysfs, not the mc.

Yes, but that covers almost all devices, as the ones that use mc (except for
uvc) have more serious issues, as libv4l still don't work with them. So, they
demand dedicated applications anyway.

> I know Laurent
> has been working on a better replacement, but that's been stalled for ages.
> In other words, someone needs to spend time on this and create a proper
> library for this.

True, but, again, media controller based devices also need the libv4l
pieces that Sakari is working (also stalled).

Let's not mix things: associating media devices via sysfs has already
a library. If you want to mention about that, please point to it.

A more generic work that will make libv4l and that library to also work
with media controllers is a work to be done/finished.

> 
> > 
> >>      </section>
> >>  
> >>      <section>
> >> @@ -176,19 +124,22 @@ mailing list: &v4l-ml;.</para>
> >>  When this is supported by the driver, users can for example start a
> >>  "panel" application to change controls like brightness or audio
> >>  volume, while another application captures video and audio. In other words, panel
> >> -applications are comparable to an OSS or ALSA audio mixer application.
> >> -When a device supports multiple functions like capturing and overlay
> >> -<emphasis>simultaneously</emphasis>, multiple opens allow concurrent
> >> -use of the device by forked processes or specialized applications.</para>
> >> -
> >> -      <para>Multiple opens are optional, although drivers should
> >> -permit at least concurrent accesses without data exchange, &ie; panel
> >> -applications. This implies &func-open; can return an &EBUSY; when the
> >> -device is already in use, as well as &func-ioctl; functions initiating
> >> -data exchange (namely the &VIDIOC-S-FMT; ioctl), and the &func-read;
> >> -and &func-write; functions.</para>
> >> -
> >> -      <para>Mere opening a V4L2 device does not grant exclusive
> >> +applications are comparable to an ALSA audio mixer application.
> >> +Just opening a V4L2 device should not change the state of the device.
> >> +Unfortunately, opening a radio device often switches the state of the
> >> +device to radio mode in many drivers.</para>
> > 
> > This is an API spec document. It should say what is the expected behavior,
> > and not mention non-compliant stuff.
> 
> How about putting this in a footnote? I do agree with you, but the fact is
> that most if not all drivers that support both radio and video behave this
> way. So one could argue that it is the spec that is non-compliant :-)

If so, let's then fix the API to reflect that opening a radio device will
change the behavior.
> 
> That said, at some point this should be fixed.

Yes. one way or the other.

> > 
> >> +
> >> +      <para>Almost all drivers allow multiple opens although there are
> >> +still some old drivers that have not been updated to allow this.
> >> +This implies &func-open; can return an &EBUSY; when the
> >> +device is already in use.</para>
> > 
> > What drivers? We should fix the driver, not the API doc.
> 
> vino.c (I do have fixes for this in an old branch), timblogiw.c, fsl-viu.c.
> There are probably a few more. Generally such drivers are old and/or obscure.

Maybe in this specific case, a footnote could be added, although the better
would be to simply fix or remove/move to staging those drivers.

> Since I am still working (slowly) on converting drivers to the modern frameworks
> I'll come across these eventually.
> 
> > Also, we need more discussions. It could make sense to return EBUSY
> > even on new drivers, for example, if they're already in usage by some
> > other broadcast type?
> 
> You are not using it until you actually start streaming (or allocating buffers,
> or whatever). There is no reason within the current framework to return EBUSY
> for just opening a device node.
> 
> Not being able to open a device node a second time makes it impossible to
> create e.g. monitoring applications that do something when an event happens.

Agreed.

> > 
> >> +
> >> +      <para>It is never possible to start streaming when
> >> +streaming is already in progress. So &func-ioctl; functions initiating
> >> +data exchange (e.g. the &VIDIOC-STREAMON; ioctl), and the &func-read;
> >> +and &func-write; functions can return an &EBUSY;.</para>
> > 
> > Here, the Overlay is a somewhat an exception, not in the sense that 
> > they'll call streamon latter, but in the sense that overlay ioctls
> > can happen after streaming.
> 
> I'll make a note of that.
> 
> > I don't remember well how DMA buf works,
> > but I think you can also start to use a mmaped copy of the dma buffers
> > after start streaming.
> 
> Possibly, but that has nothing to do with this paragraph. Once a file
> handle calls STREAMON, then no other file handle of the same device node
> can call STREAMON, unless the owner stops streaming and releases all
> resources (REQBUFS(0)).

Well, then the paragraph text is not quite right, as it mentions 
"initiating data exchange".

If one mmaps memory latter to use it on an already started DMA buffer,
it is initiating the "memory copy" data exchange with the mmap.

STREAMON is just one of the ways to initiate a data exchange.

> > 
> >> +
> >> +      <para>Merely opening a V4L2 device does not grant exclusive
> >>  access.<footnote>
> >>  	  <para>Drivers could recognize the
> >>  <constant>O_EXCL</constant> open flag. Presently this is not required,
> >> @@ -206,12 +157,7 @@ additional access privileges using the priority mechanism described in
> >>        <para>V4L2 drivers should not support multiple applications
> >>  reading or writing the same data stream on a device by copying
> >>  buffers, time multiplexing or similar means. This is better handled by
> >> -a proxy application in user space. When the driver supports stream
> >> -sharing anyway it must be implemented transparently. The V4L2 API does
> >> -not specify how conflicts are solved. <!-- For example O_EXCL when the
> >> -application does not want to be preempted, PROT_READ mmapped buffers
> >> -which can be mapped twice, what happens when image formats do not
> >> -match etc.--></para>
> >> +a proxy application in user space.</para>
> >>      </section>
> >>  
> >>      <section>
> > 
> > 
> 
> Thanks!
> 
> 	Hans


-- 

Cheers,
Mauro
