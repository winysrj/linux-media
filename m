Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.aster.pl ([212.76.33.45])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Daniel.Perzynski@aster.pl>) id 1LD3tS-00041W-Fo
	for linux-dvb@linuxtv.org; Wed, 17 Dec 2008 22:25:22 +0100
From: "Daniel Perzynski" <Daniel.Perzynski@aster.pl>
To: "'Andy Walls'" <awalls@radix.net>
References: <4728568367913277327@unknownmsgid>	
	<412bdbff0812151428q798c8f48l79caba49e72306a@mail.gmail.com>	
	<8829222570103551382@unknownmsgid>	
	<412bdbff0812151512k72f70d70j88427b5761585d16@mail.gmail.com>	
	<2944906433286851876@unknownmsgid>	
	<412bdbff0812151527l43029409q2dbacce63ea60cc9@mail.gmail.com>	
	<1229389488.3122.23.camel@palomino.walls.org>	
	<412bdbff0812152107r5e3ac546h2530f9b28d8c8f94@mail.gmail.com>	
	<000001c95f71$82bfc980$883f5c80$@Perzynski@aster.pl>
	<1229482284.3108.98.camel@palomino.walls.org>
In-Reply-To: <1229482284.3108.98.camel@palomino.walls.org>
Date: Wed, 17 Dec 2008 22:24:32 +0100
Message-ID: <000501c9608d$da60ec10$8f22c430$@Perzynski@aster.pl>
MIME-Version: 1.0
Content-Language: en-us
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Avermedia A312 - patch for review
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



-----Original Message-----
From: Andy Walls [mailto:awalls@radix.net] 
Sent: Wednesday, December 17, 2008 3:51 AM
To: Daniel Perzynski
Cc: 'Devin Heitmueller'; linux-dvb@linuxtv.org
Subject: RE: [linux-dvb] Avermedia A312 - patch for review

On Tue, 2008-12-16 at 12:29 +0100, Daniel Perzynski wrote:
> From: Devin Heitmueller [mailto:devin.heitmueller@gmail.com] 
> On Mon, Dec 15, 2008 at 8:04 PM, Andy Walls <awalls@radix.net> wrote:
> > On Mon, 2008-12-15 at 18:27 -0500, Devin Heitmueller wrote:
> >> On Mon, Dec 15, 2008 at 6:23 PM, Daniel Perzynski
> >> <Daniel.Perzynski@aster.pl> wrote:
> >
> >> > Could you please look at the wiki for that card and tell me what will
> be the
> >> > analog video decoder for that card (I don't have /dev/videoX device).
> >>
> >> Hmm....  It's a cx25843.  I would have to look at the code to see how
> >> to hook that into the CY7C68013A bridge.  I'll take a look tonight
> >> when I get home.
> >
> > The cxusb.[ch] files seem to devoid of analog support.  There's this
> > comment which sums it up:
> >
> > * TODO: Use the cx25840-driver for the analogue part
> >
> >
> > Although the linux/media/video/pvrusb2 driver appears to have at least
> > two hybrid boards with a cx2584x and an FX2 (WinTV HVR-1900 and HVR-1950
> > in pvrusb2_devattr.c).  Maybe that driver could help... (or maybe I
> > haven't got a clue :] )
> >
> > Regards,
> > Andy

> > Daniel - This is going to be a project - we're not talking adding just
> > another device profile.  Analog support is a huge piece of the
> > framework that this driver outright doesn't exist.  Someone would have
> > to add analog support to dvb_usb and then make it work with the cxusb
> > driver, and then add the appropriate device profile for the Avermedia
> > A312.


> Hmm, not good then :( How we can start that project? I have to tell you
that
> I'm not a programmer and I've added a312 support to cxusb based on the
> similarities to Avermedia Volar.

Andy Walls' off the cuff steps to starting a project:

1. Define the requirements: analog TV and video, FM radio, and ideally
digital TV support for the AverMedia A312 in v4l-dvb.  Done.

2. Identify resources and constraints: limited hardware test asset
availability due to laptop family specific packaging, limits of time for
experienced programmers, number of testers, ability of testers to
exercise all functions (e.g. ATSC in Europe is unlikely), who's going to
do the coding and the testing?, etc.

3. Develop some strategic options: add analog support to cxusb, modify
pvrusb2, write a new driver based on existing one, etc.

4. Asses relative feasibility of strategies and scope the work

5. Develop a work break down of the preferred strategy, with tasks and
milestones to accomplish, and set an overall schedule goal.


Of the above, I'd suggest assessing a strategy of modifying the pvrusb2
driver first, as I have a feeling that will have the best return on time
invested.  Mike Isley would probably be able to provide you with an
expert opinion on feasibility of modifying pvrusb2 to support the A312,
given that he maintains the pvrusb2 driver, IIRC, and you can point him
to fairly decent information on the wiki page for the A312.


> There is a radio also in that card (I don't know which chipset is
> responsible for that) + WM8739 for which the driver do exist (wm8739.c).

Likely the tuner outputs baseband FM L and R audio that's fed into the
WM8739 for digitization, and then passed to the CX25843 as serial audio
data on the I2S input to the CX25843.  That's the way it works on many
of the ivtv and cx18 supported cards.


>  I
> can try to modify pvrusb2 but the question is if we shouldn't have one
> "driver" to support both analog and digital TV + Radio on that card?

That's an easy one to answer: Why shouldn't one driver do it?  

There's precedent as other drivers do this:  At least the cx18 driver
supports cards that can capture analog video, FM radio and digital TV.
The ivtv driver supports cards that perform analog video capture and FM
radio capture.

The real answer is that there are finite resources available (people
with time and experience and test assets) and that will limit what gets
done.  So what's most important to you to get working?


(Not that I have time to really help - just apparently time enough to
write long rambling e-mails)

Regards,
Andy

> Daniel,
Hi Andy,

Thank you very much for that long and valuable post. The top priority for me
would be analog TV + Radio. If one driver can do analog TV and Video + Radio
and another digital TV the option would be to update pvrusb2 driver with
support for that card (analog TV + radio) and test my patch to cxusb driver
for digital TV (I need to find someone with A312 card in his/her laptop).

Regards,



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
