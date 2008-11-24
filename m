Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <8567605f0811241156xc855543p82e5d455fc84256@mail.gmail.com>
Date: Mon, 24 Nov 2008 20:56:51 +0100
From: "kevinlux -" <kevinlux@gmail.com>
To: "hermann pitton" <hermann-pitton@arcor.de>
In-Reply-To: <1227479368.4665.42.camel@pc10.localdom.local>
MIME-Version: 1.0
Content-Disposition: inline
References: <8567605f0811160257i66ea44a1i8b16a45c1580d5a9@mail.gmail.com>
	<8567605f0811231027w4bca54dej414d353e31ff1e5f@mail.gmail.com>
	<1227479368.4665.42.camel@pc10.localdom.local>
Cc: Hartmut Hackmann <hartmut.hackmann@t-online.de>,
	video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] pinnacle 310i doesn't works very well
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
List-ID: <video4linux-list@redhat.com>

Hi all,
i'm talking about this tv tuner card : My Cinema-P7131 Hybrid
http://www.asus.com/products.aspx?l1=18&l2=83&l3=252&l4=0&model=547&modelmenu=1

I'm sorry but i have to confirm that both cards (the asus  p7131 and
pinnacle 310i ) stilii not working correctly with the last mercurial
(also in analog mode).
Otherwise i also have an usb Pinnacle dvb stick that works perfecty
under win and linux (with the driver em28xx from mcentral.de
(http://mcentral.de/hg/~mrec/v4l-dvb-kernel)). If there's something
that i can do (testing and something like that) don't esitate to
ask... you will be welcome.
Best regards and thanks

kev

2008/11/23, hermann pitton <hermann-pitton@arcor.de>:

>
> Kevin, I saw your previous post, but I can't test on something like the
>  310i with tda827x_config/tuner_config = 1 and I was waiting for some
>  confirmation. Maybe someone on the video4linux-list can test on it.
>
>  Which of the P7131 Dual cards you have. The Dual Hybrid with LNA ?
>
>  This one uses tda827x/tuner config = 2.
>
>  This configuration I can test on the recently added Asus Tiger 3in1.
>
>  We partly have heavy snowfall currently, but on the same DVB-T RF feed,
>  with the most critical transponder for me in upper UHF, an Asus Tiger
>  Revision 1 fails completely, too many errors, on a Medion Quad mplayer
>  starts, but picture and sound are totally distorted and unusable
>  currently.
>
>  On the Tiger 3in1 almost all is fine, except some rare small artifacts
>  from time to time. That means the LNA works for sure.
>
>  The same goes for analog TV. It is easy to recognize if the LNA is
>  active, since else sync issues after channel switching, a black bar
>  passes the screen for a while and also some slight audio issues. Others
>  reported sometimes flashing picture and humming noise on analog without
>  correctly configured LNA.
>
>  "hg head" on this machine is:
>
>  changeset:   9575:d5e211683345
>  tag:         tip
>  parent:      9573:1251a4091b89
>  parent:      9574:2ab0045eb27b
>  user:        Mauro Carvalho Chehab <mchehab@redhat.com>
>  date:        Tue Nov 11 07:42:37 2008 -0200
>  summary:     merge: http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-backport
>
>  We are only 4 days apart, if LNA config = 2 should be broken at all
>  later.
>
>  ---
>  Few minutes later with the current v4l-dvb installed on that one.
>
>  Sorry, I seem not to be able to confirm your observation, at least the
>  Asus Tiger 3in1 is still fine on that critical transponder.
>
>  If I change the LNA config to 0, mplayer fails to start with only three
>  good and 27 bad packages. Means for me the LNA works for sure.
>
>  Cheers,
>
> Hermann
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
