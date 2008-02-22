Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp102.rog.mail.re2.yahoo.com ([206.190.36.80])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <CityK@rogers.com>) id 1JSgYm-0006iS-Ph
	for linux-dvb@linuxtv.org; Fri, 22 Feb 2008 23:40:05 +0100
Message-ID: <47BF4F18.6040801@rogers.com>
Date: Fri, 22 Feb 2008 17:39:20 -0500
From: CityK <CityK@rogers.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
References: <18b102300802210712o76dcccf9j2857d8092d1e9846@mail.gmail.com>		<47BDB0FA.7080500@rogers.com>	<18b102300802211051m3823e365v1fa025ac46edca0b@mail.gmail.com>
	<47BF15FB.4090105@rogers.com> <47BF3126.2020707@gmail.com>
In-Reply-To: <47BF3126.2020707@gmail.com>
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

Manu Abraham wrote:
> CityK wrote:
>> To be specific, its because the DVB API is about the reception of a 
>> Digital Video Broadcast, and those are made in form of a Transport 
>> Stream modulated onto a RF carrier....
>
> DVB isn't completely about a RF carrier. It is used in the studios,
> (interconnectivity) at the production levels (studios) as DVB-ASI as 
> well.

This is true, but the context was in regards to the DVB API.   In any 
case, I had made mention_of/alluded_to ASI & SPI later on.

>
>> consequently, anything DVB entails a receiver....second thing to note 
>> is that, although the terminology "capture" is widely used in 
>> reference to digital applications just as much as it is with analog, 
>> it is a misnomer when it comes to DVB....
>
> There are DVB-ASI transmitters too.

Very true ... my focus/thought was on the end user at the time of 
writing ... but we should not loose sight of the complete picture -- 
which of course involves the broadcast delivery chain

>
>> DVB devices are essentially network interfaces ... they are entirely 
>> akin to your computer's modem --- both have a receiver that acquires 
>> an RF siganl and then demodulates the underlying information of 
>> interest off that carrier wave.
>
> This is true for DVB demods, not otherwise. Generally we see a lot of DVB
> demods, but doesn't mean it is just that alone.

I don't follow.

>
>> There is little difference between downloading a file from 
>> kernel.org, or Mircosoft, or from where ever, and saving that file to 
>> your hard disk, as there is to tuning to ABC, or PBS, or whatever 
>> station, and saving the TS or the underlying program stream 
>> (multiplexed within the TS) to your harddisk.
>>
>> So, turning to the examples quoted above:
>> - Component: an analog signal that has nothing to do with DVB ... 
>> sure, you can build a DVB device that includes the facilities to 
>> capture component (and other analog sources) ... and by capture here, 
>> its meant that ADC has to be done first to convert the analog to a 
>> digital bitstream and then place it into a particular container 
>> format and save to disk.... but that aspect has nothing to do with 
>> DVB, and hence is covered by other subsystem (V4L)
>
>
> many newer DVB devices will switch over to a "one single package concept"
> where it will be one chip for all, in such cases, no V4L will exist 
> for such devices,
> except for a vanilla TV out interface. Such devices feature a generic 
> framebuffer
> under the Video subsystem (not to be confused with V4L), where devices 
> might
> be handled.
>
> For V4L to work with devices that way, it will need to copy more from 
> the other
> subsystems such as Video, DVB and ALSA since V4L alone is not any 
> specific
> "real" subsystem pertaining to something in real life. V4L just 
> originated as a
> means to tune Analog TV cards under Linux, which later went in a 
> different tangent.

While the move to multi-purpose, single IC devices is inevitable, the 
processing stages for the varying applications which the IC will perform 
(i.e. demodulation, encoding, ADC, etc)  remain the same ... I don't see 
how V4L would be cut out of the block ... unless, of course, that means 
DVB means to expand its capabilities and/or absorbing some of those 
currently handled by V4L

> At these levels, the hardware to be used is much proprietary and Linux 
> won't
> make much of a dent, where the users are quite used to their production
> environments with other OS and applications (such as Viz RT for 
> example) since
> there isn't anything quite near or usable to this under Linux, nothing 
> DVB or V4L
> will be seen in the public, though there (are/might be) some 
> proprietary solutions at
> some intermittent stages, but nothing that will have a whole Linux 
> concept in such
> areas of usage
>
> In such cases the hardware and hardware device drivers are of very 
> little concern,
> but the main concern is about the virtual instruments implemented in 
> software such
> as decks and other things and so on.
>
> A broadcast professional, never has the time to learn or work with 
> applications
> stuck together with plaster. He just wants to get things done in the 
> minimal time
> for something to be aired. He doesn't care about the cost, nor the OSS 
> philosophy,
> but just about time involved in it.
>
> Generally Linux makes a dent where cost is involved, but at the High 
> end where cost
> is not a subject, yet to see Linux, even if something exists, that 
> will be completely
> proprietary, nothing OSS.
>
> ...[snip]...
>
> For large applications, storage isn't much of a concern, as the users 
> such as studios
> have extremely large video servers, explicitly used for the same 
> purpose. Little to be
> heard about Linux in this area where Windows and Mac systems rule. The 
> users also
> educated only on specific applications that run on them. 

What you've said about the broadcast/tv_studio industry is absolutely 
true.  But such capture devices do not really have a place in them anyway.

These devices do, however, have a very large relevance to, and home 
within, the movie and production studios; and in those  environments, 
quite contrary to what you have written, the Penguin rules the roost.   
It is true that, in those industries, users aren't employing these 
devices with open APIs such as V4L-DVB (and I made mention of this in 
one of the prior messages), but nonetheless, these devices are very much 
so being fully utilized under Linux.  A nice little summary can be found 
here:
 
http://www.linuxmovies.org/index.html

And here's a practical example, from a few years back, that is of some 
notoriety (first 4:4:4 10 bit):

http://linuxdevices.com/news/NS8217660071.html

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
