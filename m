Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.243])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jklaas@appalachian.dyndns.org>) id 1JSGWW-0003fw-Oa
	for linux-dvb@linuxtv.org; Thu, 21 Feb 2008 19:52:01 +0100
Received: by an-out-0708.google.com with SMTP id d18so42571and.125
	for <linux-dvb@linuxtv.org>; Thu, 21 Feb 2008 10:51:56 -0800 (PST)
Message-ID: <18b102300802211051m3823e365v1fa025ac46edca0b@mail.gmail.com>
Date: Thu, 21 Feb 2008 13:51:55 -0500
From: "James Klaas" <jklaas@appalachian.dyndns.org>
To: CityK <CityK@rogers.com>
In-Reply-To: <47BDB0FA.7080500@rogers.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <18b102300802210712o76dcccf9j2857d8092d1e9846@mail.gmail.com>
	<47BDB0FA.7080500@rogers.com>
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

First, let me say that This is not in my near term purchase plans, but
I was mostly curious to know the possiblities of support of this (or
something like it) long term. This is the thread that got me
interested in asking
http://www.gossamer-threads.com/lists/mythtv/users/317435.

Partly what piqued my interest is there has been a great deal of talk
about how capturing HD streams without compression is very difficult
without very high end components, very expensive capture cards etc,
etc.  It was surprising to me that you could in fact find something
like this for less than $1000.  With a card like this, it would be
conceivable to create a HD capture system for well under a $1000.

On 2/21/08, CityK <CityK@rogers.com> wrote:
> James Klaas wrote:
>  > HD capture ...... HDMI/component/composite
>  >
>
>  Whether it be done through an analog connection (eg. component) or
>  digital connection (eg. HDMI/DVI/SDI), it all falls under the realm of
>  the V4L subsystem, not DVB.

Is that because it purports to capture the streams without
compression?  Or does that have more to do with a lack of a tuner?

>  V4L API's current facilities may not even extend far enough for such
>  applications anyway .... I'm not certain, nor really qualified to
>  comment (so someone with a more authoritative opinion should be listened
>  to/consulted), but I expect that this would be rather pioneering with
>  the current API and, hence, would require some additions/extensions to
>  be made before such tasks could be realized.

>  > There was a discussion over on the mythtv-users forum on HD capture
>  > that devolved into another discussion, but there was an article on
>  > converting your HD-DVDs to Blue-Ray
>  > (http://howto.wired.com/wiki/Convert_Your_HD_DVDs_to_Blu-Ray).  They
>  > pointed to a HDMI/component/composite capture card at
>  > http://www.blackmagic-design.com/products/intensity/.
>  >
>  > While I wouldn't expect this to be supported anytime soon, has anyone
>  > even looked at this?
>
>
> - By chance, in that discussion on the mythtv-users forum to which you
>  refer, did any of the contributers/posters search that m/l's own
>  archives in respect to the Intensity? If not, then in this thread (
>  http://www.gossamer-threads.com/lists/mythtv/users/223410#223410 ) you
>  will see that Blackmagic reportedly expressed some openness towards the
>  idea of Linux support. I haven't heard of anything further on the matter
>  than that ... that doesn't mean that there hasn't been anything else
>  said, and perhaps there is indeed some follow up ... I don't know ...
>  but either way, that will require some searching, and that I leave as an
>  exercise for someone else.

That particular thread did not mention the Intensity.  But it did
mention the HD-PVR at one point at least.

>  - in regards to whether anyone around here has looked at this, I don't
>  think any of the regulars ever have ... let alone ever considered it ...
>  most people wouldn't even be aware of it (and the other existing
>  alternatives ) ... in addition, it would be new territory, and likely a
>  difficult development process ... so if there is anyone working on that
>  device, or looking at it, its likely they are not directly associated or
>  involved around here.
>
>  - in addition to BM's Intensity and Intensity Pro, there are a few other
>  "cheaper" solutions that are available. This thread on Doom9 (and
>  despite its title) makes mention of them and provides examples of some
>  of them in use: http://forum.doom9.org/showthread.php?p=1044824#post1044824
>
>  - as far as I know, the more expensive professional and prosumer
>  solutions (i.e the AJA xena's, BM Decklinks, Accustreams, Bluefish444
>  cards etc etc) do have Linux support ... albeit, it is through
>  proprietary SDKs or developed inhouse by the production studios using
>  such products . There was a brief discussion about these on the V4L
>  mailing list a few years ago; see/read through this thread:
>  http://marc.info/?l=linux-video&m=115374256412690&w=2
>
>  - lastly, did that MythTV-users thread mention the forthcoming Hauppauge
>  HD-PVR (component input) ? ... given that the LinuxTV developer rank
>  does include a couple of guys from Hauppauge, and given that both of
>  them have made mention of that device, and given Hauppauge's stance on
>  Linux support is very positive, I'd be willing to bet that the chances
>  of open/publicly available support for this device materializing are
>  far, far greater than any of the other devices mentioned
>  above.....though, bear in mind there are, of course, never any
>  guarantees or certainties, nor am I speaking on the behave of anyone.
>

Thank you all for the information.  I had no idea it would spark such
a lively discussion.

James

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
