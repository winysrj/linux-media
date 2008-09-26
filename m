Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dyn60-31.dsl.spy.dnainternet.fi ([83.102.60.31]
	helo=shogun.pilppa.org) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lamikr@pilppa.org>) id 1Kj9fS-0002tk-FZ
	for linux-dvb@linuxtv.org; Fri, 26 Sep 2008 11:31:18 +0200
Date: Fri, 26 Sep 2008 12:31:05 +0300 (EEST)
From: Mika Laitio <lamikr@pilppa.org>
To: Markus Rechberger <mrechberger@gmail.com>
In-Reply-To: <d9def9db0809251044k7fbcaa1awdf046edb2ca9b020@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0809261141320.13249@shogun.pilppa.org>
References: <002101c91f1a$b13c4e60$0401a8c0@asrock>
	<a3ef07920809250815k21948f99m7780e852088b96f@mail.gmail.com>
	<48DBBAC0.7030201@gmx.de>
	<d9def9db0809251044k7fbcaa1awdf046edb2ca9b020@mail.gmail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [ANNOUNCE] DVB API improvements End-user point of
 viwer
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

> You can also find patched enduser applications on mcentral.de which can be used
> with other devices and provide extra features which are required in
> order to get devices
> work properly.
> There's gqradio patched to support lirc and digital audio
> automatically, same with vlc and tvtime
> (the last one also having different video output plugins which allow
> software rendering if xvideo
> hardware acceleration isn't available.
>
> Still one fact till now is that not all devices which have worked in
> v4l-dvb-experimental back in time
> are now supported by v4l-dvb on linuxtv.org and nor all the em28xx
> based devices are yet in the
> em28xx-new tree, whereas the second one is the result of heavy
> refactoring and better manufacturer
> support for some back then reverse engineered components (-which is
> good that they got replaced in order
> to raise the signal strength).

The problem here is that only a few developers knows about this, while 
there could be a hundred of thousands of end users. If some hardware like
HVR-4000 or AF9015 have been able to get working by developers let's say 
about 6 month ago, then that support should be available in the latest 
kernels and latest distros. It is really messy for them try to figure out
multiple different repositories which support their hardware and then
compile and try each of them separately to find out

a) which are supported with their kernel versions
b) differences in supported features and patches in each repository
c) how to get hardware A supported by repository X and hardware B 
supported by the repository Y work together with user app Z which requires 
patch C for hardware A and patch D for hardware B...

So the only solution is really to get things from development trees back 
to main v4l-dvb development repository which acts like a final barrier 
for checking co-existence of different works before things get merged to Linux 
kernel.

For me it seems that this is now not happening because people argue from 
a) different ways the ways how to do things (this is good as there are often multiple
different requirements and possibilities for doing things)
b) How to make a good technical decision between multiple different 
choises after the discussion that satisfies everybody (this is the thing 
that is currently not happening)

As step (b) is now failing, the gap between main repository and 
development repositories get huge and messy.

What do you think, could think work better if there would be a couple of 
people who would actively try to find things that work for example in 
Mantis, multiproto, af915 and S2API trees  and then try to find a way for 
re-formatting those patches to form that would be acceptable to main 
repository. This would after all follow the spirit of GPL which encourages 
the evolment of work made by people, instead of making anybody to be the 
only owner of certain new work (that is in after all based to work made by 
others earlier)

Good thing in that would be that it would speeden up the 
merging of the development. Bad thing would be that in perfect world this 
"patch monkey" would not be needed at all because developers would them 
self send "signed of" patches with much faster frequency than what is 
currently happening. In addition this "I r

Afterwards it is easy to be wise, but maybe following development steps 
would have worked much better 2-1 years ago with multiproto tree for 
example

a) manu send patch (was done)
b) somebody reviweed it (was done)
c) discussion from a and b...
c) vote in the list whether some of the directions suggested with a, b and 
c steps is the way to go
d) announcement of the vote result
e) everybody agrees and somebody would have started to assist manu for 
getting agreed changes to DVB-V4L tree.
f) manu and others would have started to merge work from multiproto tree 
to V4L-DVB tree...

So instead of trying to make things work perfectly in development tree,
big steps should be agreed and then start working with smaller steps to 
get things faster merged back to main tree.

Mika

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
