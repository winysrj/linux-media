Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8JETB9J028815
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 10:29:12 -0400
Received: from www.curtronics.com
	(h69-129-7-18.nwblwi.dedicated.static.tds.net [69.129.7.18])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8JET9cN019319
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 10:29:09 -0400
Message-ID: <48D3B730.9060204@curtronics.com>
Date: Fri, 19 Sep 2008 09:29:04 -0500
From: Curt Blank <Curt.Blank@curtronics.com>
MIME-Version: 1.0
To: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
References: <48D32F0E.1000903@curtronics.com>
	<200809190435.17646.vanessaezekowitz@gmail.com>
In-Reply-To: <200809190435.17646.vanessaezekowitz@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Kworld PlusTV HD PCI 120 (ATSC 120)
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

Hi,

Thanks yo the reply. I had read through all your posts from back in 
February and did see you got it working. I've got a few questions.

Vanessa Ezekowitz wrote:
> On Thursday 18 September 2008 11:48:14 pm Curt Blank wrote:
>   
>> I'm trying to get this  card working  and I'm having some trouble and
>> I'm not sure exactly where. I'm using the 2.6.26.5 kernel gen'd to
>> include all the v4l support.
>>     
>
> I don't know if that version of the kernel has the full driver or not, however, 
> it would be a good idea to use the v4l-dvb repository instead, as that code is 
> more up to date.
>
> Mauro, does any current kernel contain these drivers yet?  I've not been 
> following v4l-dvb-->kernel merges.
>   
I looked at the cx88_cards.c code and I see it has the Kworld PlusTV HD 
PCI 120 (ATSC 120) card listed in it. It looks to me it was included 
since 2.6.26. I do have the v4l code fro the repository, I was 
experimenting with using it in the 2.6.25.22 kernel but decided 2.6.26.5 
might be better. If I don't have any luck with you suggestions and the 
2.6.26.5 code I'll switch back to the repository code.
>   
>> Using Kradio I can manually tune in a station  but the audio only comes
>> out the Line Out jack on the card. Alsa is installed and working, I can 
>> play CD's, listen to streaming music, KDE sound effects work, so it
>> appears my sound subsystem is working. The alsa config in Kradio is set
>> to what it determined and it appears to match the device as far as
>> things go.
>>     
>   
> The first thing that comes to mind here is that Kradio chose the wrong audio 
> device but made it look like it chose correctly.  I seem to recall it doing 
> the same thing on my box as well.  This card provides audio via a digital 
> stream, and the drivers put that stream on /dev/dsp1, so you must chose that 
> as your capture card/device, and set the playback card/device to use your 
> usual sound card.
>   
So this card follows the oss format instead of the alas format? I wasn't 
sure which one to use. I switched Kradio's V4L Config Options to use OSS 
and tried both /dev/dsp and /dev/dsp1 and there is no sound. I had 
experimented with this before also.
> Also, the current version of the driver no longer provides or requires the 
> cx88-alsa module (it has apparently been merged with other parts of the 
> driver).  Don't try to load this module, as it will probably cause a bunch of 
> errors and break things.  I've just updated the KW120 article to reflect this 
> change in driver behavior (and to fix some other errors on my part).
>   
>> When I try to scan for stations it doesn't find any but I can 
>> tune to any local station and get it.
>>
>> I also can't get the video (HDTV) to work either. When it starts up I get
>> a:
>>     
>
> At the present, you can't load both the digital- and analog-mode drivers at the 
> same time - this card uses a "hybrid" tuner, which the drivers can't quite 
> deal with properly yet (this is being worked on).  The end result is that 
> neither mode will work at all, or may work only intermittently (last time I 
> tried, the result was unpredictable).
>
> You must select one more or the other, and you must reboot the computer 
> (actually, a hard power-off is better) when switching modes.
>
> Basically, it boils down to blacklisting several modules and then loading 
> either the cx8800 or cx88-dvb module (for analog or digital, respectively).
>   
I did experiment with the blacklisting and I did notice that I could 
listen to the radio (through the cards line out) when the cx8800 was 
loaded without the cx88-alsa module loaded. At the moment I have 
blacklisted everything, powered down and now only have the cx8800 module 
loaded.
>   
>   
>> I also can't get the video (HDTV) to work either. When it starts up I get a:
>> [...]
>> When I run kdetv in a terminal window I see this:
>>     
>
> [errors snipped]
>
> Last time I tried to use it, KDETV only worked with analog video/TV and other 
> v4l capture devices.  For digital TV, you need to use something like 
> Kaffeine/Xine, MythTV, etc.  Basically any video player that can read from a 
> DVB device.
>
> Also note that KDETV, unless it's changed since I last looked, isn't aware of 
> that separate digital stream for analog TV, so you probably won't get any 
> audio from it.  Most of the other TV programs are like this also.  Kradio is 
> aware of it, however, and worked fine for me last time I used it.
>   
I do have kaffine and xine, I will try that when I get a chance later today.
>   
>> I've read the Wiki at http://www.linuxtv.org including the
>> http://www.linuxtv.org/wiki/index.php/KWorld_ATSC_120 info. I also
>> downloaded the archived list messages back to January 2007 and looked
>> through them for help.
>>     
>
> I know it sounds a little Windows-ish, but since the driver is still 
> experimental, and the ATSC 120 is kinda finicky, a reboot is the first thing 
> to do here, just to get the card back into a predictable state.  Get the 
> blacklist into place before you do that, check after the reboot to make sure 
> that worked, then try just the analog mode.  One that works, reboot again, 
> enable digital mode, and scan for channels with dvbscan or whatever your 
> distro calls it.
>
> Stuart and I wrote most of what's in the ATSC 120 info page, so if it didn't 
> work for you, I'd like to see if we can figure out what went wrong, so I can 
> update the page to address the problem.  I'm kinda partial to the idea of 
> seeing this card working fully for those who have one. :-)
>   
Thanks. I'll work on all your suggestions more in depth when I have more 
time later today and over the weekend and report back. The first thing 
I'd like to get working as a stepping stone is the sound not using the 
cards line out. I've been trying this in a box using that MSI MB, it's 
going to be used in different box with an Asus m3a78-em MB that should 
be arriving today so I will probably move to that. I've had some issues 
with MSI MB's and media cards (video) in the last year where they did 
not work and that's why I've switched back to Asus.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
