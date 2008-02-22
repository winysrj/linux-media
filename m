Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp107.rog.mail.re2.yahoo.com ([68.142.225.205])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <CityK@rogers.com>) id 1JSckw-0005Mc-5V
	for linux-dvb@linuxtv.org; Fri, 22 Feb 2008 19:36:22 +0100
Message-ID: <47BF15FB.4090105@rogers.com>
Date: Fri, 22 Feb 2008 13:35:39 -0500
From: CityK <CityK@rogers.com>
MIME-Version: 1.0
To: James Klaas <jklaas@appalachian.dyndns.org>
References: <18b102300802210712o76dcccf9j2857d8092d1e9846@mail.gmail.com>	
	<47BDB0FA.7080500@rogers.com>
	<18b102300802211051m3823e365v1fa025ac46edca0b@mail.gmail.com>
In-Reply-To: <18b102300802211051m3823e365v1fa025ac46edca0b@mail.gmail.com>
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

James Klaas wrote:
> On 2/21/08, CityK <CityK@rogers.com> wrote:
>   
>> James Klaas wrote:
>>  > HD capture ...... HDMI/component/composite
>>  >
>>
>>  Whether it be done through an analog connection (eg. component) or
>>  digital connection (eg. HDMI/DVI/SDI), it all falls under the realm of
>>  the V4L subsystem, not DVB.
>>     
>
> Is that because it purports to capture the streams without
> compression?  Or does that have more to do with a lack of a tuner?

To be specific, its because the DVB API is about the reception of a 
Digital Video Broadcast, and those are made in form of a Transport 
Stream modulated onto a RF carrier....consequently, anything DVB entails 
a receiver....second thing to note is that, although the terminology 
"capture" is widely used in reference to digital applications just as 
much as it is with analog, it is a misnomer when it comes to DVB....DVB 
devices are essentially network interfaces ... they are entirely akin to 
your computer's modem --- both have a receiver that acquires an RF 
siganl and then demodulates the underlying information of interest off 
that carrier wave.   There is little difference between downloading a 
file from kernel.org, or Mircosoft, or from where ever, and saving that 
file to your hard disk, as there is to tuning to ABC, or PBS, or 
whatever station, and saving the TS or the underlying program stream 
(multiplexed within the TS) to your harddisk.

So, turning to the examples quoted above:
- Component: an analog signal that has nothing to do with DVB ... sure, 
you can build a DVB device that includes the facilities to capture 
component (and other analog sources) ... and by capture here, its meant 
that ADC has to be done first to convert the analog to a digital 
bitstream and then place it into a particular container format and save 
to disk.... but that aspect has nothing to do with DVB, and hence is 
covered by other subsystem (V4L)
- HDMI: an uncompressed RGB or YUV digital bitstream ... not applicable 
to DVB ... sure, you can build a DVB device that includes the facilities 
to capture that digital bitstream...and by capture here, its meant that 
the stream is placed it in a particular container and saved to disk 
(either uncompressed or, if you so choose, with a codec -- either a 
lousy one or a loseless one) .... but that aspect has nothing to do with 
DVB, and hence should be covered by another subsystem (V4L)
- DVI: same as HDMI
- SDI (and in this case, you'd be interested specifically in HD-SDI, in 
SMPTE 372M): another uncompressed digital bitstream interface protocol 
... comments are the same as the others

In fact, speaking of what V4L would/should cover, see the first 
paragraph here: 
http://www.linuxtv.org/v4lwiki/index.php/Development:_Video4Linux_APIs

About the only thing otherwise related to the DVB API would be the 
highly related DVB-ASI or SPI.  Questions about extending the DVB API to 
include coverage of those were raised last year when Manu solicited 
suggestions on progression of the API; if you're really interested, see 
this lengthy thread here:  
http://marc.info/?l=linux-dvb&m=118989203715847&w=2 )

> Partly what piqued my interest is there has been a great deal of talk
> about how capturing HD streams without compression is very difficult
> without very high end components, very expensive capture cards etc,
> etc.  

- Uncompressed is actually not very CPU intensive, but it is (a) HIGHLY 
bandwidth intensive and, consequently, (b) GIGANTICALLY_EXPENSIVE 
storage wise . 

It is very easy to describe both the bandwidth and, hence, storage 
considerations --- mathematically, for the video portion, its simply a 
Fn(frame size (i.e. resolution), frame rate, subsampling (i.e. 4:4:4, 
4:2:2,...), and bit depth).   To completely describe the rate, you can 
factor in the overhead requirements of the file container which you use, 
though its contribution to the total is entirely negligible compared to 
that of essence's.

For an example of how to apply that knowledge to real world examples, 
read through from this post:
http://forum.doom9.org/showthread.php?p=916752#post916752

- Compressed, on the other hand, is CPU Intensive

> It was surprising to me that you could in fact find something
> like this for less than $1000.  With a card like this, it would be
> conceivable to create a HD capture system for well under a $1000.

Computers are getting more powerful, and components are getting 
cheaper....still, there are more things to consider then meets the eye 
-- as that Doom9 thread alludes to, depending upon whether your trying 
uncompressed or compressed, there are storage considerations, sustained 
transfer rates to consider, codec issues, maybe digital restrictions 
management issues (with an interface like HDMI), processor considerations...

The neat thing about the forthcoming Hauppauge device is that:
- its analog (component) input ... thereby removing potential DRM 
considerations
- and in addition to performing the ADC, the chip utilized is also a 
encoder, compressesing using h.264/AVC   .... this completely removes 
all the other issues

- so long as the quality is acceptable,  this should be a nice solution 
for most end users .... but it will, of course, not meet the needs of 
prosumers/professional, who would still want to be using an uncompressed 
or loselessly compressed solution, so that they can perform editing etc.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
