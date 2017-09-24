Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:51023 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753122AbdIXWRz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Sep 2017 18:17:55 -0400
From: Soeren Moch <smoch@web.de>
Subject: Re: [GIT PULL] SAA716x DVB driver
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Regel <andreas.regel@gmx.de>,
        Manu Abraham <manu@linuxtv.org>,
        Oliver Endriss <o.endriss@gmx.de>, linux-media@vger.kernel.org,
        Eugene Syromiatnikov <esyr@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
References: <50e5ba3c-4e32-f2e4-7844-150eefdf71b5@web.de>
 <d693cf1b-de3d-5994-5ef0-eeb0e37065a3@web.de>
 <20170827073040.6e96d79a@vento.lan>
 <e9d87f55-18fc-e57b-f9aa-a41c7f983b34@web.de>
 <20170909181123.392cfbb0@vento.lan>
 <a44b8eb0-cdd5-aa28-ad30-68db0126b6f6@web.de>
 <20170916125042.78c4abad@recife.lan>
Message-ID: <fab215f8-29f3-1857-6f33-c45e78bb5e3c@web.de>
Date: Mon, 25 Sep 2017 00:17:00 +0200
MIME-Version: 1.0
In-Reply-To: <20170916125042.78c4abad@recife.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16.09.2017 19:49, Mauro Carvalho Chehab wrote:
> Em Sat, 16 Sep 2017 14:54:15 +0200
> Soeren Moch <smoch@web.de> escreveu:
>
>> On 09.09.2017 23:20, Mauro Carvalho Chehab wrote:
>>> Em Sat, 9 Sep 2017 14:52:18 +0200
>>> Soeren Moch <smoch@web.de> escreveu:
>>>  
>>>> You explicitly
>>>> want to discourage new driver and application implementations.   
>>> Me? It is just the opposite: sticking with a poorly documented API
>>> that almost nobody knows seems to be what discouraged new drivers
>>> and applications.  
>> OK, then you are fine to keep the audio/video/osd API in this driver, great!
> My current understanding is that keeping audio/video API doesn't make
> any sense, for a couple of reasons:
For me, keeping this interface makes a lot of sense.
> 1. it was never fully documented;
Nothing what prevents existing drivers to work, and new drivers
to be written, as can be seen from this pull request.
> 2. the only upstream hardware that supports them was developed on
>    about 17 years ago;
But was sold for several years in lots of different versions,
even hardware modifications were developed and applied
by lots of users to improve the performance of these cards,
and most important, these cards are still in use.
> 3. the API is broken with regards to compat32 and Y2038 (see more
>    below);
Not unique for this driver and, since this API has no business
with wall clock time, not too complicated to fix.
> 4. almost all (if not all) features they support are also supported
>    by V4L2 and ALSA;
Here we come to the point. The DVB audio/video API just
works, there are working drivers, working applications (vdr)
and happy users.
The audio/video/osd device nodes are nicely grouped below
1 adapter, so it is immediately clear, which devices belong
together. It is very easy to implement the classic multimedia
set-top box use case (audio and video decoding with menu
overlays). For this use case it is the ideal interface.

You propose V4L2/ALSA instead, what has "almost all features".
May be, but "almost all" is not all, and a collection of features
does not give us a working system. /dev/videoX device names
are not stable across boots, it is even more complicated to
find matching devices for different hardware with otherwise
similar capabilities. With V4L2/ALSA there is no real A/V
synchronisation, selected ALSA devices are reassigned during
suspend or even HDMI hotplug. So audio gets lost when
switching the monitor off and on again.

So while audio/video/osd is an integrated multimedia
interface with working drivers and happy users, for me
V4L2/ALSA is not ready to immediately replace it.

> 5. V4L2 supports a lot more features that video decoders support
>    than video API, like H.264 and other newer video standards, plus
>    HDMI setup features.
The S2-6400 card also decodes H.264, and the API is not
limited to any set of video coding standards. This card
decodes frame synchronous audio and video and correctly
signals audio/video formats in HDMI AVI frames  (e.g.
AC3 / PCM audio, video aspect ratios,...). You did not explain
how this should work with V4L2/ALSA.

For other use cases other types of v4l2 devices could be
more appropriate. The two APIs coexist for years in
mainline linux without problems.
> In the past, we tried a lot to get documentation for those
> DVB APIs, but, unfortunately, nobody that worked on its development
> sent us patches addressing the API documentation.
You probably know why the ttpci developers stopped
sending patches to linux-media.
> With regards to OSD, as no other documented API emerged to
> fulfill what it does, it could make sense to keep it, if
> someone properly documents it.
>
>>>> With linux core APIs for FF you probably mean some new
>>>> API combination as successor of the audio/video/osd API.
>>>> The S2-6400 unfortunately directly implements the old API
>>>> in hardware and is therefore the worst possible match for
>>>> such new driver generation.  
>>> It sounds weird that the API is directly implemented in hardware.
>>> I can't tell much, though, as I didn't see the code yet.  
>> All the available code is in this pull request.
> I know. I'll look on it if we reach an agreement.
>
>> I really don't understand your Kaffeine use case. Kaffeine is a media
>> player, which displays the decoded video on a KDE/Gnome desktop.
>> With the S2-6400 it is not possible to read the decoded video back,
>> so it is not possible to display something in a desktop window.
>> I cannot image what you want to do with this hardware and Kaffeine.
> I see.
>
>>>>> One alternative we could do would be to add the proper APIs for the
>>>>> driver and keep for a couple of Kernel versions, in staging, a module
>>>>> that would provide backward compatibility to the legacy APIs. This way,
>>>>> applications will have some time to add support for the new API.
>>>>>
>>>>> If you're willing to do that, I can merge the patches.    
>>>> Here I do not understand what you expect me to do. The audio/video/osd
>>>> devices are closely tied together (as frontend/demux/dvr are for the
>>>> input side). The S2-6400 card expects an transport stream with audio and
>>>> video packets to be written to that video device (the audio device is
>>>> not used) and commands  for overlay text/graphics over the osd device.  
>>> There are two options here:
>>>
>>> 1) if the hardware itself allows to direct a filtered MPEG-TS to the demod,
>>>    by hardware, instead of reading it from /dev/dvb/.../dvr and writing it
>>>    to /dev/dvb.../video, you could use the Media Controller to
>>>    direct the video PID to the video decoder hardware directly;  
>> This is what you want me to implement: this shortcut from
>> /dev/dvb/.../dvr to /dev/dvb.../video ? Since you said above that this
>> is already implemented in the dvb core, this should be easy and.
>> can of course be implemented in this driver.
>>>    The V4L2 driver device node (let's say, /dev/video0) will just
>>>    implement the HDMI output.  
>> There is no separate decoder / HDMI hardware, from the driver's
>> point of view. The decoded video directly goes to the HDMI output.
> If there's nothing that can be controlled at the HDMI output, why do
> you need a /dev/dvb.../video devnode? If it can be controlled, a 
> V4L2 output will do the job.
As I wrote several times, the TS stream, which will be decoded,
is written to /dev/dvb/adapterX/video.
>>> 2) if there's no hardware pipelines between the demux and the decoders,
>>>    userspace will read video from .../dvr and write it to a /dev/video
>>>    capture device node, implemented by a mem2mem V4L2 driver.  
>> There cannot be a separate capture device node for the decoded
>> video. You probably refer to the video_cature:one-shot feature,
>> which is switched off by default.
>> This is a debug feature, which vdr supports. It is intended to
>> take a snapshot of the output image, something for debugging
>> vdr-skins, the graphical user interface of vdr.
> Ah, so it can't play an arbitrary MPEG-TS stream from other
> sources, right?
The card will decode the TS stream written to the video device
and display the decoded audio and video over HDMI.
>
>> From the msleep(100); in the read path you can easily see, that
>> this is meant for still images, not for video. Due to bandwidth
>> limitations on the hardware this should normally not be used
>> during normal decoding.
>>>    The mem2mem output device node (let's say, /dev/video1) will control
>>>    the HDMI output.  
>> As mentioned several times, it is only possible to write a transport
>> stream to the video device, and osd commands to the osd device.
> Hmm... now, I'm confused. Can it play a MPEG-TS video stored at the
> computer or not?
The TS stream, written to the video device for decoding,
can come from the same adapter's  dvr device, from any
other adapter's dvr device, from harddisk or where-ever.
>
>> There is no hardware interface to directly access the HDMI output.
>> So it is not possible to create a separate v4l2 HDMI output device.
>>>> The osd part you considered to keep as-is. There is no general video
>>>> output possible as over a DRM device, there is no GPU processing
>>>> possible, and there is no API for video decoding as in a general v4l2
>>>> decoder device. This card's decoder only implements exactly the DVB
>>>> video and osd devices in hardware (well, card firmware I guess, as
>>>> hobbyist programmer I have no access to that), with this somewhat
>>>> strange mix of audio and video (for the card it is not strange, as audio
>>>> and video are always mux'ed in DVB streams).
>>>>  
>>>>>> I agree that new drivers should use modern APIs in the general case. But
>>>>>> for this driver the legacy DVB decoder API is a hard requirement for me,
>>>>>> as described. So I hope you will dispense with the v4l2 conversion for
>>>>>> this special case. I'm pretty sure that there will be no new hardware
>>>>>> and therefore no new driver with this legacy API, this saa716x_ff driver
>>>>>> also has a 7-year development history, in this sense it is not really new
>>>>>> and one could also think of it as some sort of legacy code.    
>>>>> FF hardware is still common on embedded devices. Sooner or later support
>>>>> for them will be added upstream, and applications that support it
>>>>> will appear.    
>>>> Yes, I would really like to get the same functionality as with S2-6400
>>>> on modern SoCs (i.MX6Q, Allwinner H5, meson-gxbb Amlogic S905,...)
>>>> with modern APIs, in an uniform way, see the other thread.  
>>> They likely need a lot more, as modern SoC may have lots of IP
>>> blocks to control (multiple inputs, scalers, mpeg encoding, etc). By
>>> adding MC support, the gaps can be fulfilled.  
>> Maybe this is a misunderstanding here. I do not plan to support
>> other hardware with this saa716x_ff driver. The other thread [1]
>> about documentation of modern APIs for modern SoCs is somewhat
>> related, but independent from this driver for the S2-6400.
>> This driver as successor of ttpci must implement the same DVB API
>> to support existing users.
>>
>> Drivers for modern hardware may use other APIs, please answer
>> about this in the other thread (or maybe in a new one, if this is more
>> appropriate).
> Yeah, perhaps there's a misunderstanding here. What we currently have
> upstream is a single driver (av7110) that supports a hardware, developed
> about 17 years ago, and that it is out of production for a long time.
As already mentioned, this hardware was sold over a very long
period of time in different versions, it was hardware-modded for
better performance and is still in use.
> We should remove this driver some day, but, as there isn't any strong
> reason to remove, it is staying (and so the API header files to talk
> with it).
And now we have another driver with the same already in-tree
interface, with happy users for several years, which can as well
stay there. And, as I already offered to maintain both drivers, you
would get a maintainer for the DVB decoding API.
>
> Actually, a couple of weeks before your saa716x pull request, there was
> a report that the current DVB video API is broken with regards to 
> compat32 and fix would break kABI [1]. It is also incompatible with
> Y2038 fixes that are happening system wide. So, perhaps is time to
> get rid of it for good.
As the fixes are happening tree-wide, this driver should be fixed
in the same way. There are happy users of this driver, and a
maintainer for it if you agree, no need to remove this driver.
>
> [1] see https://patchwork.kernel.org/patch/7187851/ and related
>     e-mails.
>
> If/when we add another full-featured DVB hardware (outside staging),
> as the API defined on audio/video is too old (from the time that all
> video decoders were MPEG 2), and it didn't receive any updates to
> support modern hardware, it is unlikely that it would work for such
> hardware.
Here you just received a driver for more modern H.264 full-featured
DVB hardware, it is working great with this API.
>  I bet that using V4L2/ALSA (perhaps with a few minor additions)
> would work a way better, as those APIs always got updatates as new audio
> and video codecs got added. The V4L2 also supports the needed bits to
> detect HDMI monitors and adjust parameters like resolution, 3D mode
> and fps rate there.
As described above, V4L2/ALSA has a lot of problems for this
use-case. All the advantages you describe for V4L2/ALSA
"with a few minor additions" are already working great
without additions in this available driver.
> Now, on this thread you're proposing to add another driver using
> DVB video obsolete (and Y2028 broken) API.
This API is used in a popular application from happy users,
so it is not obsolete.
>  What I'm saying is that,
> if we're adding it on staging, we need to have a plan to reimplement
> it to whatever API replaces the DVB video API, as this API likely
> won't stay upstream much longer.
AFAIK it is not usual linux policy to remove existing drivers
with happy users and even someone who volunteered to
maintain this.

Regards,
Soeren
> Thanks,
> Mauro
