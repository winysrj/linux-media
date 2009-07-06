Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n660AjDA013506
	for <video4linux-list@redhat.com>; Sun, 5 Jul 2009 20:10:45 -0400
Received: from mail-bw0-f221.google.com (mail-bw0-f221.google.com
	[209.85.218.221])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n660ASaA026243
	for <video4linux-list@redhat.com>; Sun, 5 Jul 2009 20:10:28 -0400
Received: by bwz21 with SMTP id 21so3441881bwz.3
	for <video4linux-list@redhat.com>; Sun, 05 Jul 2009 17:10:28 -0700 (PDT)
Message-ID: <4A5140F0.40909@gmail.com>
Date: Mon, 06 Jul 2009 04:10:24 +0400
From: fsulima <fsulima@gmail.com>
MIME-Version: 1.0
To: Jackson Yee <jackson@gotpossum.com>
References: <4A5089CF.3070606@gmail.com>	
	<26aa882f0907051330y6f092ca3x18e1f58e883352d4@mail.gmail.com>	
	<4A511E18.2010305@gmail.com>
	<26aa882f0907051606x9b9f63bi6a7a9d5ea7db6126@mail.gmail.com>
In-Reply-To: <26aa882f0907051606x9b9f63bi6a7a9d5ea7db6126@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Please advise: 4channel capture device with HW compression for
 Linux based DVR
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

Thanks a huge, it is exhausting!
Please see inline.

Jackson Yee wrote:
> Yep, been down that road before myself.
>
> The truth of the matter is that slim profile, multiple port cards are
> available with Linux drivers, but they are quite expensive ($500 for
> the cheapest that I could find, although it is a very nice looking 16
> port system).
>   
Oh, this is too pricy.
Are you talking only about cards with H/W encoding or about all low 
profile multiple port capture cards?
> I have a mini-ITX system sitting by my television right now which I
> would love to use my new STK-1160 4-port USB adapter (marketed as
> EasyCap 4-port DVR USB) with, but unfortunately, we're still working
> out NTSC support for it. The guys using PAL and Zoneminder have
> apparently gotten it to work pretty well.
>   
It appears like STK-1160 has 25/30 overall fps, so it's not quite the 
same thing.
> I've never used an Atom system, but from what I understand, although
> the CPU is quite power efficient, it is also utterly crushed in
> performance by the cheapest dual-cores available today. That's why
> Nvidia's Ion platform was so attractive to people looking to do 720p
> or 1080p on their televisions - the Atom simply did not have the power
> to handle HD video. A D1 stream is much easier to work with, but
> encoding is also more processor intensive than decoding by an order of
> magnitude. You could probably do one D1 stream with MPEG4, but if you
> plan on using real-time x264 or more than one stream... I would have
> to believe that your system would be quite incapable of keeping up the
> framerate.
>   
It was tricky to make ATOM decode HD, I had to employ multicore CoreAVC 
decoder. Decoding of 720p was consuming about 30% of CPU time (assuming 
it has 2 HT cores, each of 4 HW threads was busy 30% of time), and 1020p 
was about 50-70% AFAIR. It can be outperformed by regular P4.
So my system must be definitely unsuitable for real time encoding :(

> Believe me, I would love to say that I have a solution for you since
> that would mean a solution for me as well, but the reality of the
> matter is that we are just not quite there yet on driver support for a
> multiple channel USB capture device. If you're just planning on doing
> one D1 stream at a time, the WinTV PVR USB2 has hardware encoding and
> is supported quite well. I suppose that you could hook up a couple of
> these, but whether the system could handle these USB devices is beyond
> my experience.
>   
Yes, there are single channel devices with encoding, combining 4 of them 
together may be less pricy, but it's odd anyway. :)
> Please let me know if you have any success with this project.
>   
It looks it's not worth wasting time trying this on Atom.
I may need to consider an upgrade.
I'm considering Intel mini-itx motherboard. 
http://www.mini-box.com/Intel-DG41MJ-FSB1333-Socket-775-Mini-ITX-Motherboard
The price of the upgrade looks comparable with price of HW encoding 
solution, but it is more beneficial.

So, could you please say more about LP vs regular PCI capturers (W/O H/W 
encoding)? Are there inexpensive LP solutions?

Regards,
F S
> Regards,
> Jackson Yee
> The Possum Company
> 540-818-4079
> me@gotpossum.com
>   

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
