Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [212.57.247.218] (helo=mail.glcweb.co.uk)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michael.curtis@glcweb.co.uk>) id 1KZkF9-0006iO-P4
	for linux-dvb@linuxtv.org; Sun, 31 Aug 2008 12:33:16 +0200
From: "Michael J. Curtis" <michael.curtis@glcweb.co.uk>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Date: Sun, 31 Aug 2008 11:32:40 +0100
Message-ID: <3C276393607085468A28782D978BA5EE71D2BA8175@w2k8svr1.glcdomain8.local>
References: <48B8400A.9030409@linuxtv.org> <48B98914.1020800@w3z.co.uk>
	<48B98B89.80803@linuxtv.org>
	<d9def9db0808302057u25e7ce5yfb2967c893255df0@mail.gmail.com>
In-Reply-To: <d9def9db0808302057u25e7ce5yfb2967c893255df0@mail.gmail.com>
Content-Language: en-US
MIME-Version: 1.0
Subject: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation support
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

All

Firstly, I would like to thank ALL contributors for their time and effort so far in furthering the development of DVB-S2 on Linux, in particular the TT3200-S2 card

I will confirm that the Multiproto route has been a very frustrating experience for me over the two years, I think? that I have had this card!!

Each attempt to get this to work has introduced new and different 'challenges' and has frustrated my aim to have this work with MythTV

Any attempt to rationalize where we are now and publish attainable goals with support for mainstream applications will get my support

Kind regards

Michael Curtis

> -----Original Message-----
> From: linux-dvb-bounces@linuxtv.org [mailto:linux-dvb-
> bounces@linuxtv.org] On Behalf Of Markus Rechberger
> Sent: 31 August 2008 04:58
> To: Steven Toth; Linux Kernel Mailing List; Greg KH
> Cc: mrechberger@sundtek.com; linux-dvb@linuxtv.org
> Subject: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation
> support
>
> On Sat, Aug 30, 2008 at 8:03 PM, Steven Toth <stoth@linuxtv.org> wrote:
> > Charles Price wrote:
> >>> If you also feel frustrated by the multiproto situation and agree
> in
> >>> principle with this new approach, and the overall direction of the
> API
> >>> changes, then we welcome you and ask you to help us.
> >>>
> >>
> >> I wholeheartedly agree.
> >>
> >> Although I can't offer any programming input, I do have a variety of
> DVB
> >> hardware and different architectures on which I can test your
> creations.
> >>
> >> Happy to help.
> >
>
> not reading the parts above, but saying this is Steven, not caring
> about the main people who work on something.
>
> There's a split between a few people here (including myself) and other
> people from that scene who just don't care about anything.
>
> Manu and the others put in alot work, why screw what he wrote (code)
> he has been on vacation (I know he married a few weeks ago - since I
> got the invitation) Hauppauge people (Michael Krufky and Steven Toth)
> are running their personal own game .. sorry to say that but it's that
> way.
>
> I have logs and mails here where Steven and Mike wrote hey that would
> be a cool idea about compatibility but when "I" mentioned it again and
> spent work on it it was like hey we're linux only (I don't only care
> about linux since I also work alot with commercial companies in that
> area look at the dibcom website - Job requirement 'independent' code
> neither do I want to depend on Windows nor Linux but having something
> that works on both in case of hardware is fine - especially I2C is
> trivial to realize for everything).
>
> Rethink your position and try to get people onboard but don't try to
> screw people and run your own game.
>
> Seeing the comments Acked-By: xyz - I cannot review neither contribute
> code but I can provide webspace .. hilarious. get down on earth again
> Steven, Mike expecially Mauro - try to get Manufacturers onboard
> instead working against you.
> I talked alot with Manu he has good connections and is avoing to work
> together just as I am because of certain Monopoly and copyright
> infringements which you are building here (I see Mauro using leaked
> code here!) . Mauro is spreading foo, Manu has the specs for xyz. I
> fully understand Manu's point since Mauro did the same with me,
> however .. I better don't comment it.
>
> Let's put another thing in here: Greg Kroah Hartman Linux Guy reverted
> my patch in favour of supporting the binary Firmware upload tool of
> Dell (I fully support Dell here too) although claiming to be
> opensource but still running after someone (please comment this one -
> it confused me at 'your' position). It was just like ok let's revert
> it but not asking why?!
> I'm just getting up with this just because I saw following yesterday:
> 21:07 < pmp> hmm: request_firmware(&fw, CX24116_DEFAULT_FIRMWARE,
> &state->i2c->dev) ?
> 21:08 < pmp> the &state->i2c->dev looks strange and the kernel is
> saying that about it: kobject_add failed
>              for i2c-1 with -EEXIST, don't try to re....
> 21:09 < pmp> other fe-driver have a callback in their config-struct...
> 21:09 < pmp> I start to believe there is a reason ;)
>
> I better cut it now.
>
> Markus
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
> No virus found in this incoming message.
> Checked by AVG - http://www.avg.com
> Version: 8.0.138 / Virus Database: 270.6.14/1643 - Release Date:
> 30/08/2008 17:18

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
