Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns218.ovh.net ([213.186.34.114])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <webdev@chaosmedia.org>) id 1Jy1Ll-0007Lv-5J
	for linux-dvb@linuxtv.org; Mon, 19 May 2008 11:08:13 +0200
Message-ID: <4831434A.7000502@chaosmedia.org>
Date: Mon, 19 May 2008 11:07:22 +0200
From: "ChaosMedia > WebDev" <webdev@chaosmedia.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48310988.8080806@pilppa.org>
In-Reply-To: <48310988.8080806@pilppa.org>
Subject: Re: [linux-dvb] Well working S2 cards?
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


> Mika Laitio wrote:
>
> I am planning to obtain satellite dish and some PCI or PCIE satellite 
> card for my Linux box that is running X86-64 on amd 4850e.
>
> So far I have found the Technotrend S2-3200 and WinTV NOVA-HD-S2 that 
> seems to be pretty equally priced. Then the HVR-4000 costs about 50 euro 
> more but has in addition the DVB-T support.
>   
don't know about the hvr-4000
i have a tt s2-3200 it's cheap and works well, i don't use the CI 
though, so i can't tell if it's well supported by the driver 
(multiproto) but besides the CI part i couldn't tell you what's not 
properly working with this card at the moment..

you'll get some good info on linuxtv wiki : 
http://www.linuxtv.org/wiki/index.php/DVB-S2_PCI_Cards


But if you're going for Sat HD (1080i h264) on linux 64bit, i don't 
think the dvb device will be the problem as long as it has a working driver.

> What card you would recommend for the Linux usage and for which one the 
> drivers are working best? (running on AMD x86-64 with 4850e cpu)
> And is there any differences in the tuner quality of these cards?
>   
With 1080i H264 that you'll get on DVB-T or DVB-S2 (in europe) the main 
problem will be to properly decode it.

If you're on 32bit you'll probably go for a dvb app with a CoreAVC patch 
and use that windows 32bit decoder, then your CPU hardware or the stream 
source, won't really matter as it's a very fast, full featured, decoder..

On 64bit, you won't be able to use CoreAVC as simply as on 32bit, it's a 
work in progress as far as i can tell. Then the only straight way to 
decode h264 is through ffmpeg (ffh264) and that decoder will probably 
have some troubles decoding some (most) sat streams.
Problems will come either from the stream specifications, unsuported in 
ffh264, that will produce a jerky decoding or from the lack of CPU of 
your system..
Although it seems that latest ffh264 version do use multithreading on 
those 1080i streams, tested myself on ANIXEHD/ ASTRA PROMO HD streams, 
ffh264 is not a multithreaded decoder to begin with so in the worst case 
senario it'll use one single core of your CPU for decoding and then you 
can get in serious troubles..

I personnaly have now a much better experience with my little intel 
e2180 than i got with my previous AMD be2350, both are overclocked 
around 2.8-3.0GHz.


So choosing your dvb-s2 hardware/system is important regarding the DVB 
part but also and probably more important regarding h264 decoding, 
especially when using 64bit systems..

sorry it was a bit long ;)

Marc

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
