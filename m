Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <guzowskip@linuxmail.org>) id 1L2m9X-0000Gl-DT
	for linux-dvb@linuxtv.org; Wed, 19 Nov 2008 13:27:31 +0100
Received: from wfilter.us4.outblaze.com.int (wfilter.us4.outblaze.com.int
	[192.168.9.180])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	535E21800132
	for <linux-dvb@linuxtv.org>; Wed, 19 Nov 2008 12:27:18 +0000 (GMT)
Content-Disposition: inline
MIME-Version: 1.0
From: "Paul Guzowski" <guzowskip@linuxmail.org>
To: linux-dvb@linuxtv.org
Date: Wed, 19 Nov 2008 06:27:18 -0600
Message-Id: <20081119122718.425517BD53@ws5-10.us4.outblaze.com>
Subject: Re: [linux-dvb] HVR 850 analog
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello all:

I have a Hauppauge HVR-850, and I am trying to get it to work with
Linux.  I am able to use the au0828 drivers in the 2.6.27 kernel to
get digital signals from my 850, but I can't seem to find any way to
get an analog signal.  I have searched all around and could not find a
solution.  Does anyone have any information on this?

To clarify, my kernel version is 2.6.27, the HVR-850's USB ID is
2040:7240.  I found some links saying that the 850 is similar to the
950Q, if so, any information on that might help too.

I know the hardware supports analog, as the Windows software is able
to get a signal.

Thanks for your time!
-Tom

*************************
Tom,

Not sure I can help but I'll throw out a couple of ideas since I was having=
 a similar issue and tuner is similar to yours (I think they are based on t=
he same chipset). I'm running Ubuntu 8.10 (Intrepid Ibex).  I have a Pinnac=
le HDTV Pro USB stick that works in Windows to show analog and I wanted to =
do the same in Linux so I could watch a TV signal coming from my cable set =
top box via RF-out.  It was a long journey but thanks to a lot of folks on =
this forum, particularly Devin Heitmuller, I finally got it working so I'll=
 summarize the steps I took.

First, I had quite a job to get the right driver configured and that was co=
mpounded by the fact that there were two of them out there.  By kernel 2.6.=
27 (I think) my hardware was recognized out of the box.  The other issue I =
had was firmware but that one was easily solved.  If you are getting digita=
l signals, it sounds like you have these issues resolved already.

Secondly, I needed a software program with which to view TV with the usb tu=
ner.  I might add, I was doing this at the same time I was fiddling with dr=
ivers which was probably counterproductive.  Since you apparently have the =
connectivity issue resolve, this shouldn't be an issue for you.  =


I tried MeTV, MythTV, Kaffeine, TVTime, XawTV, Gnome TV, Zapping TV viewer,=
 Xine, and a couple of others.  The only one of those I could get to work w=
as TVTime and even then I didn't have sound.  Most of the others need a cha=
nnels.conf file which is done by scanning according to certain parameters w=
ith either a built-in scanner or a command-line tool like scan or w_scan.  =
Depending on your distribution you may have these available already or you =
may need to download/install them.  In any case, I never had any success de=
veloping a channels.conf file by scanning either from the RF-out line off t=
he cable box or from the native cable signal coming out of the wall.

I finally succeeded by using MPlayer and passing a bunch of parameters to i=
t from the command line.  Once I got it working I set up a launcher with th=
e entire command string so that all I had to do is hit the button on my des=
ktop to show TV.  The command I am using is: =


mplayer -vo xv tv:// -tv driver=3Dv4l2:alsa:immediatemode=3D0:adevice=3Dhw.=
1,0:norm=3Dntsc:chanlist=3Dus-cable:channel=3D3

This gives me a simple window tuned to NTSC channel three.  I change the ch=
annel on my cable box and change the volume with either the computer or cab=
le box or both.  MPlayer has a lot more capability but this is all I am usi=
ng.  There is a companion recorder function called Mencoder which you can u=
se to record the signal if you are looking for a DVR function.  I have not =
used it yet but a typical command line looks like the following:

mencoder tv:// -tv driver=3Dv4l2:alsa:immediatemode=3D0:adevice=3Dhw.1,0:no=
rm=3Dntsc:chanlist=3Dus-broadcast:input=3D0:norm=3Dntsc:width=3D640:height=
=3D480:forceaudio:audiorate=3D48000 buffersize=3D64 -ovc lavc -lavcopts vco=
dec=3Dmpeg4:vbitrate=3D400:keyint=3D30 -oac mp3lame -lameopts br=3D32:cbr:m=
ode=3D3 -ffourcc divx -o =93test.avi=94

Hope this helps.

Paul in NW Florida

S

=3D
Donarius=AE Church Management Software
The easy way to track contributions, members & pledges to your church.
http://a8-asy.a8ww.net/a8-ads/adftrclick?redirectid=3D38a15aabe50664e1b34f1=
b843507bc43


-- =

Powered by Outblaze

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
