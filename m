Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Tue, 6 Jan 2009 15:18:48 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Gregoire Favre <gregoire.favre@gmail.com>
Message-ID: <20090106151848.3f9ec44c@pedra.chehab.org>
In-Reply-To: <20090106170002.GC3403@gmail.com>
References: <20090104113738.GD3551@gmail.com>
	<1231097304.3125.64.camel@palomino.walls.org>
	<20090105130720.GB3621@gmail.com>
	<1231202800.3110.13.camel@palomino.walls.org>
	<20090106144917.736584e7@pedra.chehab.org>
	<20090106170002.GC3403@gmail.com>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] s2-lipliandvb oops (cx88) -> cx88 maintainer ?
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

On Tue, 6 Jan 2009 18:00:02 +0100
Gregoire Favre <gregoire.favre@gmail.com> wrote:

> On Tue, Jan 06, 2009 at 02:49:17PM -0200, Mauro Carvalho Chehab wrote:
> 
> Hello,
> 
> > Could you please provide you your SOB?
> 
> I know that's not a question for me, but what stand SOB for ?
> http://www.acronymfinder.com/SOB.html I guess it should be Signed-Off-By
> right ?

Yes. Please read the README.patches file at the tree for more details.

> > IMO, the proper fix would be to add some locking at cx88 init. I suspect that
> > this breakage (and other similar ones) are tue to the absense of KBL on newer kernels.
> 
> Oh, and is there a way to fix those ?

By adding mutex locks during device init. This should be done with care to
avoid other troubles. 

> > What kernel version are you using?
> 
> As seen in my headers : 2.6.28-gentoo, but I also tested S2API with
> 2.6.27 (different revision).

Ok. For sure 2.6.28 came without KBL. I'm not sure if 2.6.27 also doesn't lock
during device init.

> > Better to add here:
> > 	core->dvbdev = NULL;
> 
> Are you sending a patch which will finally make HVR-4000 usable with
> S2API ?
> I would really like this since vdr now is based upon this API ;-)
> 
> Thank you very much,

Sorry, but I don't have any HVR-4000 here for testing. I was thinking that this
device were already working fine with S2.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
