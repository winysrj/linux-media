Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web23201.mail.ird.yahoo.com ([217.146.189.56])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <newspaperman_germany@yahoo.com>) id 1Kd3d0-0005Jl-Pr
	for linux-dvb@linuxtv.org; Tue, 09 Sep 2008 15:51:36 +0200
Date: Tue, 9 Sep 2008 13:49:58 +0000 (GMT)
From: Newsy Paper <newspaperman_germany@yahoo.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <1220829058l.6056l.1l@manu-laptop>
MIME-Version: 1.0
Message-ID: <898909.47709.qm@web23201.mail.ird.yahoo.com>
Subject: Re: [linux-dvb] Re :  Re : TT S2-3200 driver
Reply-To: newspaperman_germany@yahoo.com
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

Hi manu!


Are you talking about DVB-S or DVB-s2 are we talking about the same problem.

I experienced those problems on a dvb-s2 transponder with a SR of 30000 and=
 FEC 3/4 currently used on Thor 1=B0W by Canal Digital Nordic on some of th=
eir HD packages.

When I set Sr to 29998 I even get lock, but the stream is totaly corrupted.

kind regards


Newsy


--- manu <eallaud@yahoo.fr> schrieb am Mo, 8.9.2008:

> Von: manu <eallaud@yahoo.fr>
> Betreff: [linux-dvb] Re :  Re : TT S2-3200 driver
> An: linux-dvb@linuxtv.org
> Datum: Montag, 8. September 2008, 1:10
> Le 07.09.2008 17:01:43, Manu Abraham a =E9crit :
> > crow wrote:
> > > Hi,
> > > I am also tryint to compile multiproto_plus on
> kernel 2.6.26-3
> > (sidux
> > > 2008-02) but no luck.
> > > Kernel: Linux vdrbox 2.6.26-3.slh.4-sidux-amd64
> #1 SMP PREEMPT Wed
> > Sep
> > > 3 19:39:11 UTC 2008 x86_64 GNU/Linux
> > > I tryed it this way:
> > > I downloaded dvb driver from:
> > > apt-get update
> > > apt-get install mercurial
> > > cd /usr/src/
> > > hg clone http://jusst.de/hg/multiproto_plus
> > > mv multiproto dvb
> > > ln -vfs /usr/src/linux-headers-`uname -r` linux
> > > cd /usr/src/dvb/linux/include/linux/
> > > ln -s /usr/src/linux/include/linux/compiler.h
> compiler.h
> > > cd /usr/src/dvb/
> > > and i am trying make and get this problem :
> > > ............
> > >   CC [M]  /usr/src/dvb/v4l/ivtv-gpio.o
> > >   CC [M]  /usr/src/dvb/v4l/ivtv-i2c.o
> > > /usr/src/dvb/v4l/ivtv-i2c.c: In function
> 'ivtv_i2c_register':
> > > /usr/src/dvb/v4l/ivtv-i2c.c:171: error:
> 'struct i2c_board_info' has
> > no
> > > member named 'driver_name'
> > > make[3]: *** [/usr/src/dvb/v4l/ivtv-i2c.o] Error
> 1
> > > make[2]: *** [_module_/usr/src/dvb/v4l] Error 2
> > > make[2]: Leaving directory
> `/usr/src/linux-headers-2.6.26-3.slh.4-
> > sidux-amd64'
> > > make[1]: *** [default] Error 2
> > > make[1]: Leaving directory `/usr/src/dvb/v4l'
> > > make: *** [all] Error 2
> > > root@vdrbox:/usr/src/dvb#
> > > =

> > > I wanna try this patch to as i am also TT S2-3200
> user.
> > > Any help welcome.
> > =

> > =

> > That tree is being updated and being pushed, you can
> either wait for =

> > a
> > little while till that tree is populated, or you can
> pull the
> > multiproto
> > tree as well.
> =

> Bye any chance, di you get some time to see my posts about
> TT-S 3200 =

> ([BUG]: stb6100 getting carrier but stb0899
> unable to get data (on a transponder that is emitting
> normally) where I describe my problem: basically I can get
> the carrier =

> but search_data fails for a DVB-S transponder with 5/6 FEC
> and 30MS/s =

> whereas all other transp lock OK, they only have a
> different FEC: 3/4.
> Hope you can help me.
> BTW: looking at a mantis driver (coming from their website)
> I saw it =

> was pretty close to yours though with some differences,
> specially for =

> init values. Is there any consolidation possible here to
> get stb0899 =

> going?
> Bye
> Manu
> =

> =

> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

__________________________________________________
Do You Yahoo!?
Sie sind Spam leid? Yahoo! Mail verf=FCgt =FCber einen herausragenden Schut=
z gegen Massenmails. =

http://mail.yahoo.com =


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
