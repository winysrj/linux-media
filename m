Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.229])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1KZe4V-0004Dz-BZ
	for linux-dvb@linuxtv.org; Sun, 31 Aug 2008 05:57:53 +0200
Received: by wx-out-0506.google.com with SMTP id h27so386371wxd.17
	for <linux-dvb@linuxtv.org>; Sat, 30 Aug 2008 20:57:46 -0700 (PDT)
Message-ID: <d9def9db0808302057u25e7ce5yfb2967c893255df0@mail.gmail.com>
Date: Sun, 31 Aug 2008 05:57:46 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Steven Toth" <stoth@linuxtv.org>,
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
	"Greg KH" <greg@kroah.com>
In-Reply-To: <48B98B89.80803@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <48B8400A.9030409@linuxtv.org> <48B98914.1020800@w3z.co.uk>
	<48B98B89.80803@linuxtv.org>
Cc: mrechberger@sundtek.com, linux-dvb@linuxtv.org
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

On Sat, Aug 30, 2008 at 8:03 PM, Steven Toth <stoth@linuxtv.org> wrote:
> Charles Price wrote:
>>> If you also feel frustrated by the multiproto situation and agree in
>>> principle with this new approach, and the overall direction of the API
>>> changes, then we welcome you and ask you to help us.
>>>
>>
>> I wholeheartedly agree.
>>
>> Although I can't offer any programming input, I do have a variety of DVB
>> hardware and different architectures on which I can test your creations.
>>
>> Happy to help.
>

not reading the parts above, but saying this is Steven, not caring
about the main people who work on something.

There's a split between a few people here (including myself) and other
people from that scene who just don't care about anything.

Manu and the others put in alot work, why screw what he wrote (code)
he has been on vacation (I know he married a few weeks ago - since I
got the invitation) Hauppauge people (Michael Krufky and Steven Toth)
are running their personal own game .. sorry to say that but it's that
way.

I have logs and mails here where Steven and Mike wrote hey that would
be a cool idea about compatibility but when "I" mentioned it again and
spent work on it it was like hey we're linux only (I don't only care
about linux since I also work alot with commercial companies in that
area look at the dibcom website - Job requirement 'independent' code
neither do I want to depend on Windows nor Linux but having something
that works on both in case of hardware is fine - especially I2C is
trivial to realize for everything).

Rethink your position and try to get people onboard but don't try to
screw people and run your own game.

Seeing the comments Acked-By: xyz - I cannot review neither contribute
code but I can provide webspace .. hilarious. get down on earth again
Steven, Mike expecially Mauro - try to get Manufacturers onboard
instead working against you.
I talked alot with Manu he has good connections and is avoing to work
together just as I am because of certain Monopoly and copyright
infringements which you are building here (I see Mauro using leaked
code here!) . Mauro is spreading foo, Manu has the specs for xyz. I
fully understand Manu's point since Mauro did the same with me,
however .. I better don't comment it.

Let's put another thing in here: Greg Kroah Hartman Linux Guy reverted
my patch in favour of supporting the binary Firmware upload tool of
Dell (I fully support Dell here too) although claiming to be
opensource but still running after someone (please comment this one -
it confused me at 'your' position). It was just like ok let's revert
it but not asking why?!
I'm just getting up with this just because I saw following yesterday:
21:07 < pmp> hmm: request_firmware(&fw, CX24116_DEFAULT_FIRMWARE,
&state->i2c->dev) ?
21:08 < pmp> the &state->i2c->dev looks strange and the kernel is
saying that about it: kobject_add failed
             for i2c-1 with -EEXIST, don't try to re....
21:09 < pmp> other fe-driver have a callback in their config-struct...
21:09 < pmp> I start to believe there is a reason ;)

I better cut it now.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
