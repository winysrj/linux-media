Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+0c317467cf5bb4e87def+1897+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1KwVF2-0001kc-G7
	for linux-dvb@linuxtv.org; Sun, 02 Nov 2008 06:11:12 +0100
Date: Sun, 2 Nov 2008 03:11:02 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Markus Rechberger" <mrechberger@gmail.com>
Message-ID: <20081102031102.361d4ffd@pedra.chehab.org>
In-Reply-To: <d9def9db0811011046t58a03e3aj612cdcb06d042ca1@mail.gmail.com>
References: <490B7EE5.5030701@powercraft.nl> <490C2432.40804@free.fr>
	<d9def9db0811011046t58a03e3aj612cdcb06d042ca1@mail.gmail.com>
Mime-Version: 1.0
Cc: akpm@osdl.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	em28xx@mcentral.de, greg@kroah.com, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] em28xx merge process issues with linuxtv and
 upstream kernel
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

On Sat, 1 Nov 2008 18:46:40 +0100
"Markus Rechberger" <mrechberger@gmail.com> wrote:

> > The last attempt was rejected because the patches were adding duplicate drivers rather than improving the existing ones.
> > In the same project, 2 drivers managing the same hardware is not correct.
> > Markus (or another people, why Markus may be the only person to do that?) should propose patches of the existing drivers, without breaking the v4l-dvb APIs.
> > - First, the tuners and video decoders modifications shall be merged since they are used by several existing drivers.
> > - Then the em28xx driver shall be improved.
> > And this is what Markus started (thanks for this initiative) but this is hard to spend time on these minor things while supporting problems because of being out-of-kernel.
> >
> 
> In case of the cx25843 I discussed it with Hans Verkuil, there's more
> or less no option since it collides with the existing inkernel driver
> and disables support for other
> cx25843 drivers, so as for the kernel it should be merged to the
> existing one yes.

The same kind of collision exists if we keep both the upstream and your version
of the em28xx driver. This is also true for xc5000 and xc3028 drivers.

> The em28xx driver, the one in the kernel has taken a few patches from
> my repository, and it has some additional custom patches, it would
> make more sense to work those
> few patches into the new em28xx driver which is tested with most devices
> 
> (compared with the driver which is in the kernel which is likely
> tested with 5-10% of the devices which are in the cardlist).

The patches should be generated against the upstream driver, not against the
out-of-tree.

You might use an strategy of first patching the out-of-tree, then patching back the
upstream. This may eventually be used as an intermediate step, but I suspect it
will just make things harder.

Anyway, no matter what process used to generate the patchset, it should be
generated in a way that it won't cause regressions upstream, and submitted as
incremental patches properly describing what each patch of the series is doing
(and not just a diff <version a> <version b>).

> As for some reasons why not to merge it back then:
> * the driver relied on reverse engineered code, which made some
> devices extremly hot (not even xc3028/xc3028L related). Wrong gpio
> settings also enable the device to draw more power and affect the
> signal strength for analog TV/dvb-t, those settings can be custom for
> every designed device. I have had one pinnacle device which had a
> slightly melted package because of that mess.

The gpio logic is just a very few lines of code. A simple patch probably can
fix the issues.

> There are additional em28xx based chipdrivers which only work with
> em28xx based devices (eg. videology cam).

A patch adding videology cam support would add this functionality upstream.

> The input layer actually fully works although I disabled it because it
> needs a redesign and shouldn't be exposed to userland like this, also
> the polling code shouldn't be used (linux timing causes
> alot trouble at low intervals - especially the deinitialization of
> such timers, I sent an email to the ML about a possible race condition
> in ir-kbd-i2c a couple of months ago.
> netBSD developers discovered that interrupt polling works fine even
> for remote controls. Practically since I worked alot with remote
> controls during the last half year returning keyboard input keys
> to userland is a mess, there was a discussion also with netbsd people
> about a more generic interface because the IR support of the device
> should be seen as RC5/RC6/NEC/.. protocol support
> and not as one interface where the device is bound to a certain remote
> and only supporting that remote control.
> (that's just the reason why IR support is disabled :)

Since it is disabled, there's no sense on currently trying to merge your IR
code. This would be a regression.

> > v4l-dvb people and Markus would be glad to see his drivers in the mainstream kernel.
> >
> >> I am going to ask for understanding of both the side of Markus that
> >> worked very hard on his code, and that of the upstream developers. There
> >> are both valid reasons on how they did there things.
> >>
> >> But we need a solution to get all the code back into the upstream
> >> project so it can go into the kernel project and eventually be delivered
> >> at the Linux distributions and all there users, so no custom compiling,
> >> custom package install are required and non transparent bug reports can
> >> be stopped.
> >>
> >> Is it possible for an upstream developer to step forward and take on the
> >> task of merging the code of Markus back into mainstream, all questions
> >> on the code can be discuses on several mailing-list [2] of choice.
> >>
> > Well, I would say: "Make it so!" ;)
> >
> >> Current the situation is kind of a hold-of, the issues are not being
> >> discussed, the problem is not addressed, so no process is made and
> >> during this time users are suffering from non working nor good supported
> >> devices for there hybrid dvb-t/analog broadcast experiences under Linux.
> >>
> >> I hope this lead to a productive discussion that will get the code to
> >> the end users through there main distribution systems.
> >>
> > I hope so, just to stop these useless discussions that do not discuss on patches.
> >
> 
> the code is there :-)

If you are comfortable of having people converting your code on incremental
patches and submitting upstream, please stop making personal attacks to the
ones that are actually doing that ;)

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
