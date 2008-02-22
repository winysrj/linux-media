Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JShR0-0002kb-Hw
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 00:36:06 +0100
Message-ID: <47BF5C5D.3090500@gmail.com>
Date: Sat, 23 Feb 2008 03:35:57 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: CityK <CityK@rogers.com>
References: <18b102300802210712o76dcccf9j2857d8092d1e9846@mail.gmail.com>		<47BDB0FA.7080500@rogers.com>	<18b102300802211051m3823e365v1fa025ac46edca0b@mail.gmail.com>
	<47BF15FB.4090105@rogers.com> <47BF3126.2020707@gmail.com>
	<47BF4F18.6040801@rogers.com>
In-Reply-To: <47BF4F18.6040801@rogers.com>
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
> Manu Abraham wrote:
>> CityK wrote:
>>> To be specific, its because the DVB API is about the reception of a 
>>> Digital Video Broadcast, and those are made in form of a Transport 
>>> Stream modulated onto a RF carrier....
>>
>> DVB isn't completely about a RF carrier. It is used in the studios,
>> (interconnectivity) at the production levels (studios) as DVB-ASI as 
>> well.
> 
> This is true, but the context was in regards to the DVB API.   In any 
> case, I had made mention_of/alluded_to ASI & SPI later on.
> 
>>
>>> consequently, anything DVB entails a receiver....second thing to note 
>>> is that, although the terminology "capture" is widely used in 
>>> reference to digital applications just as much as it is with analog, 
>>> it is a misnomer when it comes to DVB....
>>
>> There are DVB-ASI transmitters too.
> 
> Very true ... my focus/thought was on the end user at the time of 
> writing ... but we should not loose sight of the complete picture -- 
> which of course involves the broadcast delivery chain
> 
>>
>>> DVB devices are essentially network interfaces ... they are entirely 
>>> akin to your computer's modem --- both have a receiver that acquires 
>>> an RF siganl and then demodulates the underlying information of 
>>> interest off that carrier wave.
>>
>> This is true for DVB demods, not otherwise. Generally we see a lot of DVB
>> demods, but doesn't mean it is just that alone.
> 
> I don't follow.

Generally people think that since we deal with demods alone mostly, people
think that is the start and that is the end. (Meant on a very general level)

>>> There is little difference between downloading a file from 
>>> kernel.org, or Mircosoft, or from where ever, and saving that file to 
>>> your hard disk, as there is to tuning to ABC, or PBS, or whatever 
>>> station, and saving the TS or the underlying program stream 
>>> (multiplexed within the TS) to your harddisk.
>>>
>>> So, turning to the examples quoted above:
>>> - Component: an analog signal that has nothing to do with DVB ... 
>>> sure, you can build a DVB device that includes the facilities to 
>>> capture component (and other analog sources) ... and by capture here, 
>>> its meant that ADC has to be done first to convert the analog to a 
>>> digital bitstream and then place it into a particular container 
>>> format and save to disk.... but that aspect has nothing to do with 
>>> DVB, and hence is covered by other subsystem (V4L)
>>
>>
>> many newer DVB devices will switch over to a "one single package concept"
>> where it will be one chip for all, in such cases, no V4L will exist 
>> for such devices,
>> except for a vanilla TV out interface. Such devices feature a generic 
>> framebuffer
>> under the Video subsystem (not to be confused with V4L), where devices 
>> might
>> be handled.
>>
>> For V4L to work with devices that way, it will need to copy more from 
>> the other
>> subsystems such as Video, DVB and ALSA since V4L alone is not any 
>> specific
>> "real" subsystem pertaining to something in real life. V4L just 
>> originated as a
>> means to tune Analog TV cards under Linux, which later went in a 
>> different tangent.
> 
> While the move to multi-purpose, single IC devices is inevitable, the 
> processing stages for the varying applications which the IC will perform 
> (i.e. demodulation, encoding, ADC, etc)  remain the same ... I don't see 
> how V4L would be cut out of the block ... unless, of course, that means 
> DVB means to expand its capabilities and/or absorbing some of those 
> currently handled by V4L

The in between stages will be masked out by larger stages which will wrap
around them, thereby you don't see those small basic controls. As you see
compared to the old days, you don't have that micro level controls anymore
these days. Those are getting phased out at a reasonable pace, with more
hardware doing those functionality of manual control. (features getting
packed in to make look like something different)

For example, When there is so much integration at such a stage, you feel
silly including something gigantic for something too silly. In such a 
case for
example of a TV output, you might not even need something that complex,
for such a small feature. (to cite as a crude example, maybe a bad example,
but i hope you get the idea)

>> At these levels, the hardware to be used is much proprietary and Linux 
>> won't
>> make much of a dent, where the users are quite used to their production
>> environments with other OS and applications (such as Viz RT for 
>> example) since
>> there isn't anything quite near or usable to this under Linux, nothing 
>> DVB or V4L
>> will be seen in the public, though there (are/might be) some 
>> proprietary solutions at
>> some intermittent stages, but nothing that will have a whole Linux 
>> concept in such
>> areas of usage
>>
>> In such cases the hardware and hardware device drivers are of very 
>> little concern,
>> but the main concern is about the virtual instruments implemented in 
>> software such
>> as decks and other things and so on.
>>
>> A broadcast professional, never has the time to learn or work with 
>> applications
>> stuck together with plaster. He just wants to get things done in the 
>> minimal time
>> for something to be aired. He doesn't care about the cost, nor the OSS 
>> philosophy,
>> but just about time involved in it.
>>
>> Generally Linux makes a dent where cost is involved, but at the High 
>> end where cost
>> is not a subject, yet to see Linux, even if something exists, that 
>> will be completely
>> proprietary, nothing OSS.
>>
>> ...[snip]...
>>
>> For large applications, storage isn't much of a concern, as the users 
>> such as studios
>> have extremely large video servers, explicitly used for the same 
>> purpose. Little to be
>> heard about Linux in this area where Windows and Mac systems rule. The 
>> users also
>> educated only on specific applications that run on them. 
> 
> What you've said about the broadcast/tv_studio industry is absolutely 
> true.  But such capture devices do not really have a place in them anyway.

Once i was looking at a cheaper capture card/device for the broadcast arena.
One of the devices that i was pointed to was around 40,000 - 200,000 
Euro. In
the broadcast scenario, encoders/capture devices are used quite a lot, 
though
it is not mandatory, as some of the devices output HD-SDI for eg. In 
this example
you still have uncompressed video where encoding is still necessary. The 
features
on such devices are well out of the scope to be integrated into a 
general purpose
API. In many cases there is no API even, but just read/write. The API 
comes in due
to the user/kernel split. In most cases, it doesn't make much sense to copy
streams in and out of kernel and hence a generic API doesn't fit for those
applications which require performance. As time passes by, we will see 
more of this
issue.


> These devices do, however, have a very large relevance to, and home 
> within, the movie and production studios; and in those  environments, 
> quite contrary to what you have written, the Penguin rules the roost.

There are some areas where Linux excels such as distributed computing,
an example is Cinelerra. But that wasn't what i was trying to express, 
it is
a different thing altogether. eg. you have a certain piece of eqpt. The 
eqpt.
manufacturer provides a plugin to an existing standard application. In such
cases you are tied to that and this happens to be the standard thing.

> It is true that, in those industries, users aren't employing these 
> devices with open APIs such as V4L-DVB (and I made mention of this in 
> one of the prior messages), but nonetheless, these devices are very much 
> so being fully utilized under Linux.  A nice little summary can be found 
> here:
> 
> http://www.linuxmovies.org/index.html
> 
> And here's a practical example, from a few years back, that is of some 
> notoriety (first 4:4:4 10 bit):
> 
> http://linuxdevices.com/news/NS8217660071.html
> 

I am not saying there aren't any, but as i said there are intermittent 
links, many
places constituting, but the percentage of OSS drivers/apps in the whole 
chain
is very small, to say the penguin rules the roost. A mistake many Linux 
fans make
(including myself) when there is a small breeze thinking it's a tornado 
(It is like
running after a moving bus, still there exists a too large gap after 
running so long ...
The bus is moving too, maybe much faster than what you can run)

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
