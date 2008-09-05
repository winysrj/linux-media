Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.229])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <makosoft@googlemail.com>) id 1KbiKW-0002UQ-P8
	for linux-dvb@linuxtv.org; Fri, 05 Sep 2008 22:54:58 +0200
Received: by rv-out-0506.google.com with SMTP id b25so584880rvf.41
	for <linux-dvb@linuxtv.org>; Fri, 05 Sep 2008 13:54:51 -0700 (PDT)
Message-ID: <c8b4dbe10809051354r2747b42atf15b3b6f9346987c@mail.gmail.com>
Date: Fri, 5 Sep 2008 21:54:51 +0100
From: "Aidan Thornton" <makosoft@googlemail.com>
To: "Greg KH" <greg@kroah.com>
In-Reply-To: <20080831042115.GA21622@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <48B8400A.9030409@linuxtv.org> <48B98914.1020800@w3z.co.uk>
	<48B98B89.80803@linuxtv.org>
	<d9def9db0808302057u25e7ce5yfb2967c893255df0@mail.gmail.com>
	<20080831042115.GA21622@kroah.com>
Cc: mrechberger@sundtek.com, linux-dvb@linuxtv.org,
	Kernel Mailing List <linux-kernel@vger.kernel.org>
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

On Sun, Aug 31, 2008 at 5:21 AM, Greg KH <greg@kroah.com> wrote:
> On Sun, Aug 31, 2008 at 05:57:46AM +0200, Markus Rechberger wrote:
>> Let's put another thing in here: Greg Kroah Hartman Linux Guy reverted
>
> If you're going to spell my full last name out, please get it right, you
> forgot a '-' :)
>
>> my patch in favour of supporting the binary Firmware upload tool of
>> Dell (I fully support Dell here too) although claiming to be
>> opensource but still running after someone (please comment this one -
>> it confused me at 'your' position). It was just like ok let's revert
>> it but not asking why?!
>
> What patch specifically are you referring to here?
>
> And what does this have to do with v4l and DVB issues?
>
> thanks,
>
> greg k-h

Hi,

Markus submitted a patch to the firmware loader code that fixed a
sysfs filename collision by appending a suffix to the sysfs filename
it used. This bug broke the use of the firmware loader from i2c device
drivers (specifically, the drivers for the xc3028 TV tuner chip) with
certain (not particularly unusual) kernel configurations - IIRC, it
affected kernels with I2C compiled as a module and a particular value
of some option related to sysfs depreciated support. The patch was
reverted by you because it broke binary-only firmware upload tools for
Dell hardware, screwing over normal desktop users in the process.

See, for example, http://lkml.org/lkml/2008/4/26/319 - this is fairly
typical. IIRC, the only drivers for the xc3028 that aren't affected
are Markus' recent ones, since they compile the firmware into the
driver (ugh). This may have been fixed since, but I'm not sure.

(Incidentally, looking at the conversation, I believe your remark that
"the i2c devices can fix things by changing their module names so this
collision doesn't happen :)" may be inaccurate. The firmware loader
copies the name it uses from the device passed to it, so I'm not sure
how much can be done, short of hacking around the issue by creating a
fake device to pass to the firmware loader or making potentially
compatibility-breaking changes to either the i2c core or the firmware
loader. Of course, I haven't looked at the issue that closely, so I
may be wrong.)

Aidan

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
