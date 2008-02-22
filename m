Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JSeYZ-00068y-BO
	for linux-dvb@linuxtv.org; Fri, 22 Feb 2008 21:31:43 +0100
Message-ID: <47BF3126.2020707@gmail.com>
Date: Sat, 23 Feb 2008 00:31:34 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: CityK <CityK@rogers.com>
References: <18b102300802210712o76dcccf9j2857d8092d1e9846@mail.gmail.com>		<47BDB0FA.7080500@rogers.com>	<18b102300802211051m3823e365v1fa025ac46edca0b@mail.gmail.com>
	<47BF15FB.4090105@rogers.com>
In-Reply-To: <47BF15FB.4090105@rogers.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HD capture
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

CityK wrote:
> James Klaas wrote:
>> On 2/21/08, CityK <CityK@rogers.com> wrote:
>>   
>>> James Klaas wrote:
>>>  > HD capture ...... HDMI/component/composite
>>>  >
>>>
>>>  Whether it be done through an analog connection (eg. component) or
>>>  digital connection (eg. HDMI/DVI/SDI), it all falls under the realm of
>>>  the V4L subsystem, not DVB.
>>>     
>> Is that because it purports to capture the streams without
>> compression?  Or does that have more to do with a lack of a tuner?
> 
> To be specific, its because the DVB API is about the reception of a 
> Digital Video Broadcast, and those are made in form of a Transport 
> Stream modulated onto a RF carrier....

DVB isn't completely about a RF carrier. It is used in the studios,
(interconnectivity) at the production levels (studios) as DVB-ASI as well.

consequently, anything DVB entails
> a receiver....second thing to note is that, although the terminology 
> "capture" is widely used in reference to digital applications just as 
> much as it is with analog, it is a misnomer when it comes to DVB....

There are DVB-ASI transmitters too.

> DVB 
> devices are essentially network interfaces ... they are entirely akin to 
> your computer's modem --- both have a receiver that acquires an RF 
> siganl and then demodulates the underlying information of interest off 
> that carrier wave.

This is true for DVB demods, not otherwise. Generally we see a lot of DVB
demods, but doesn't mean it is just that alone.

> There is little difference between downloading a 
> file from kernel.org, or Mircosoft, or from where ever, and saving that 
> file to your hard disk, as there is to tuning to ABC, or PBS, or 
> whatever station, and saving the TS or the underlying program stream 
> (multiplexed within the TS) to your harddisk.
> 
> So, turning to the examples quoted above:
> - Component: an analog signal that has nothing to do with DVB ... sure, 
> you can build a DVB device that includes the facilities to capture 
> component (and other analog sources) ... and by capture here, its meant 
> that ADC has to be done first to convert the analog to a digital 
> bitstream and then place it into a particular container format and save 
> to disk.... but that aspect has nothing to do with DVB, and hence is 
> covered by other subsystem (V4L)


many newer DVB devices will switch over to a "one single package concept"
where it will be one chip for all, in such cases, no V4L will exist for 
such devices,
except for a vanilla TV out interface. Such devices feature a generic 
framebuffer
under the Video subsystem (not to be confused with V4L), where devices 
might
be handled.

For V4L to work with devices that way, it will need to copy more from 
the other
subsystems such as Video, DVB and ALSA since V4L alone is not any specific
"real" subsystem pertaining to something in real life. V4L just 
originated as a
means to tune Analog TV cards under Linux, which later went in a 
different tangent.

> - HDMI: an uncompressed RGB or YUV digital bitstream ... not applicable 
> to DVB ... sure, you can build a DVB device that includes the facilities 
> to capture that digital bitstream...and by capture here, its meant that 
> the stream is placed it in a particular container and saved to disk 
> (either uncompressed or, if you so choose, with a codec -- either a 
> lousy one or a loseless one) .... but that aspect has nothing to do with 
> DVB, and hence should be covered by another subsystem (V4L)
> - DVI: same as HDMI
> - SDI (and in this case, you'd be interested specifically in HD-SDI, in 
> SMPTE 372M): another uncompressed digital bitstream interface protocol 
> ... comments are the same as the others
> 
> In fact, speaking of what V4L would/should cover, see the first 
> paragraph here: 
> http://www.linuxtv.org/v4lwiki/index.php/Development:_Video4Linux_APIs
> 
> About the only thing otherwise related to the DVB API would be the 
> highly related DVB-ASI or SPI.  Questions about extending the DVB API to 
> include coverage of those were raised last year when Manu solicited 
> suggestions on progression of the API; if you're really interested, see 
> this lengthy thread here:  
> http://marc.info/?l=linux-dvb&m=118989203715847&w=2 )
> 
>> Partly what piqued my interest is there has been a great deal of talk
>> about how capturing HD streams without compression is very difficult
>> without very high end components, very expensive capture cards etc,
>> etc.  
> 
> - Uncompressed is actually not very CPU intensive, but it is (a) HIGHLY 
> bandwidth intensive and, consequently, (b) GIGANTICALLY_EXPENSIVE 
> storage wise . 
> 
> It is very easy to describe both the bandwidth and, hence, storage 
> considerations --- mathematically, for the video portion, its simply a 
> Fn(frame size (i.e. resolution), frame rate, subsampling (i.e. 4:4:4, 
> 4:2:2,...), and bit depth).   To completely describe the rate, you can 
> factor in the overhead requirements of the file container which you use, 
> though its contribution to the total is entirely negligible compared to 
> that of essence's.
> 
> For an example of how to apply that knowledge to real world examples, 
> read through from this post:
> http://forum.doom9.org/showthread.php?p=916752#post916752
> 
> - Compressed, on the other hand, is CPU Intensive


At these levels, the hardware to be used is much proprietary and Linux won't
make much of a dent, where the users are quite used to their production
environments with other OS and applications (such as Viz RT for example) 
since
there isn't anything quite near or usable to this under Linux, nothing 
DVB or V4L
will be seen in the public, though there (are/might be) some proprietary 
solutions at
some intermittent stages, but nothing that will have a whole Linux 
concept in such
areas of usage

In such cases the hardware and hardware device drivers are of very 
little concern,
but the main concern is about the virtual instruments implemented in 
software such
as decks and other things and so on.

A broadcast professional, never has the time to learn or work with 
applications
stuck together with plaster. He just wants to get things done in the 
minimal time
for something to be aired. He doesn't care about the cost, nor the OSS 
philosophy,
but just about time involved in it.

Generally Linux makes a dent where cost is involved, but at the High end 
where cost
is not a subject, yet to see Linux, even if something exists, that will 
be completely
proprietary, nothing OSS.

>> It was surprising to me that you could in fact find something
>> like this for less than $1000.  With a card like this, it would be
>> conceivable to create a HD capture system for well under a $1000.
> 
> Computers are getting more powerful, and components are getting 
> cheaper....still, there are more things to consider then meets the eye 
> -- as that Doom9 thread alludes to, depending upon whether your trying 
> uncompressed or compressed, there are storage considerations, sustained 
> transfer rates to consider, codec issues, maybe digital restrictions 
> management issues (with an interface like HDMI), processor considerations...


For large applications, storage isn't much of a concern, as the users 
such as studios
have extremely large video servers, explicitly used for the same 
purpose. Little to be
heard about Linux in this area where Windows and Mac systems rule. The 
users also
educated only on specific applications that run on them.


Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
