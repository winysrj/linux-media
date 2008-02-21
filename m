Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp109.rog.mail.re2.yahoo.com ([68.142.225.207])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <CityK@rogers.com>) id 1JSEz2-00083b-2z
	for linux-dvb@linuxtv.org; Thu, 21 Feb 2008 18:13:20 +0100
Message-ID: <47BDB0FA.7080500@rogers.com>
Date: Thu, 21 Feb 2008 12:12:26 -0500
From: CityK <CityK@rogers.com>
MIME-Version: 1.0
To: James Klaas <jklaas@appalachian.dyndns.org>
References: <18b102300802210712o76dcccf9j2857d8092d1e9846@mail.gmail.com>
In-Reply-To: <18b102300802210712o76dcccf9j2857d8092d1e9846@mail.gmail.com>
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
> HD capture ...... HDMI/component/composite 
>   

Whether it be done through an analog connection (eg. component) or 
digital connection (eg. HDMI/DVI/SDI), it all falls under the realm of 
the V4L subsystem, not DVB.

V4L API's current facilities may not even extend far enough for such 
applications anyway .... I'm not certain, nor really qualified to 
comment (so someone with a more authoritative opinion should be listened 
to/consulted), but I expect that this would be rather pioneering with 
the current API and, hence, would require some additions/extensions to 
be made before such tasks could be realized.

> There was a discussion over on the mythtv-users forum on HD capture
> that devolved into another discussion, but there was an article on
> converting your HD-DVDs to Blue-Ray
> (http://howto.wired.com/wiki/Convert_Your_HD_DVDs_to_Blu-Ray).  They
> pointed to a HDMI/component/composite capture card at
> http://www.blackmagic-design.com/products/intensity/.
>
> While I wouldn't expect this to be supported anytime soon, has anyone
> even looked at this?

- By chance, in that discussion on the mythtv-users forum to which you 
refer, did any of the contributers/posters search that m/l's own 
archives in respect to the Intensity? If not, then in this thread ( 
http://www.gossamer-threads.com/lists/mythtv/users/223410#223410 ) you 
will see that Blackmagic reportedly expressed some openness towards the 
idea of Linux support. I haven't heard of anything further on the matter 
than that ... that doesn't mean that there hasn't been anything else 
said, and perhaps there is indeed some follow up ... I don't know ... 
but either way, that will require some searching, and that I leave as an 
exercise for someone else.

- in regards to whether anyone around here has looked at this, I don't 
think any of the regulars ever have ... let alone ever considered it ... 
most people wouldn't even be aware of it (and the other existing 
alternatives ) ... in addition, it would be new territory, and likely a 
difficult development process ... so if there is anyone working on that 
device, or looking at it, its likely they are not directly associated or 
involved around here.

- in addition to BM's Intensity and Intensity Pro, there are a few other 
"cheaper" solutions that are available. This thread on Doom9 (and 
despite its title) makes mention of them and provides examples of some 
of them in use: http://forum.doom9.org/showthread.php?p=1044824#post1044824

- as far as I know, the more expensive professional and prosumer 
solutions (i.e the AJA xena's, BM Decklinks, Accustreams, Bluefish444 
cards etc etc) do have Linux support ... albeit, it is through 
proprietary SDKs or developed inhouse by the production studios using 
such products . There was a brief discussion about these on the V4L 
mailing list a few years ago; see/read through this thread: 
http://marc.info/?l=linux-video&m=115374256412690&w=2

- lastly, did that MythTV-users thread mention the forthcoming Hauppauge 
HD-PVR (component input) ? ... given that the LinuxTV developer rank 
does include a couple of guys from Hauppauge, and given that both of 
them have made mention of that device, and given Hauppauge's stance on 
Linux support is very positive, I'd be willing to bet that the chances 
of open/publicly available support for this device materializing are 
far, far greater than any of the other devices mentioned 
above.....though, bear in mind there are, of course, never any 
guarantees or certainties, nor am I speaking on the behave of anyone.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
