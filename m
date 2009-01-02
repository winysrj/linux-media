Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <ea4209750901020701q11e34b42p3440c33e366fcb35@mail.gmail.com>
Date: Fri, 2 Jan 2009 16:01:20 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: "roshan karki" <roshan@olenepal.org>
In-Reply-To: <73e59df30901020653v5ec9b923mb5c6f4b186bb18de@mail.gmail.com>
MIME-Version: 1.0
References: <495A0E02.1030307@olenepal.org>
	<412bdbff0812300702l7f6333d0qa094332fc20f163@mail.gmail.com>
	<73e59df30901020653v5ec9b923mb5c6f4b186bb18de@mail.gmail.com>
Cc: pb@linuxtv.org, don@syst.com.br, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] YUAN High-Tech STK7700PH problem
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0235997492=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0235997492==
Content-Type: multipart/alternative;
	boundary="----=_Part_103503_30633503.1230908480701"

------=_Part_103503_30633503.1230908480701
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all, sorry for the delay, I didn't noticed the first mail. I added this
patch, but I don't own any of this cards; the status was quite strange. One
of the testers said that it was working perfectly while the other (there was
not much people with that model) said it didn't work. So, I'm not sure if
there is more than one hardware version with the same ID or something
similar...

Albert

2009/1/2 roshan karki <roshan@olenepal.org>

> Here is the usbsnoop I had taken when I had Windows with me,
> http://pastebin.com/m49cacaba
>
>
>
> On Tue, Dec 30, 2008 at 8:47 PM, Devin Heitmueller <
> devin.heitmueller@gmail.com> wrote:
>
>> I looked at the annotation of the patch you sent, and indeed I think
>> you have the correct patch.  I also checked to see if there was a
>> subsequent change to the GPIO configuration that might have broken
>> your card, and there doesn't appear to have been one.
>>
>> You can try emailing Patrick Boettcher and see if he has any advice,
>> since he is driver maintainer for dib0700.
>>
>> Also, if you could get a usbsnoop from a Windows system that includes
>> plugging in the device and starting a capture, I can check to see if
>> the GPIOs are correct.
>>
>> Devin
>>
>> On Tue, Dec 30, 2008 at 7:03 AM, Roshan Karki <roshan@olenepal.org>
>> wrote:
>> > -----BEGIN PGP SIGNED MESSAGE-----
>> > Hash: SHA1
>> >
>> > Hi,
>> >
>> > I've found this, this matches my usb id. Is there anything you can do,
>> > or should I try to contact the author?
>> > http://linuxtv.org/hg/v4l-dvb/rev/0dc9cba480ba
>> >
>> > On Sat, Dec 20, 2008 at 6:25 AM, Roshan Karki <roshan@olenepal.org>
>> wrote:
>> >> > Hello,
>> >> >
>> >> > I have tv-tuner with may laptop. I downloaded the source from
>> >> > linuxtv.org and installed it. It asked for two files
>> >> > dvb-usb-dib0700-1.20.fw and xc3028-v27.fw. which I copied from
>> internet.
>> >> >
>> >> > I cant however scan for any channels. I have added dump_stack to
>> >> > dib0700_core.c and here is the dmesg output.
>> >> >
>> >> > http://pastebin.com/d77534a37
>> >> >
>> >> > snippet from irc
>> >> > <roxan> devinheitmueller: does it look if my hardware is damaged?
>> >> > <devinheitmueller> Well, the dib7000p demodulator is not answering
>> the
>> >> > very first i2c command it is sent, which usually means the chip is
>> >> > totally non-functional.
>> >> >
>> >> > Please help.
>> >> > --
>> >> > Regards,
>> >> > Roshan Karki
>> >
>> > To elaborate on Roshan's situation (since I spent an hour debugging it
>> > this morning with him on #linuxtv), basically his problem is the
>> > dib7000p is not responding to even the i2c query for the vendor info
>> > (which is the first request sent to the chip).  I suspect that perhaps
>> > the GPIOs are not setup properly and the chip is being held in reset.
>> >
>> > I had him rule out faulty hardware by having him boot into Windows and
>> > successfully perform a capture.
>> >
>> > Does anyone know who did the driver work for the "YUAN High-Tech
>> > STK7700PH" product?  I will dig through the hg history if nobody
>> > speaks up...
>> >
>> > Also, there were some bugs in the dib0700 exception handling that made
>> > this harder to debug than it should have been.  I will send Patrick
>> > some patches next week if I have time (I found three or four issues).
>> >
>> > Devin
>> >
>> >  = Below is the dump_stack() results I had him add so we could see
>> > where the i2c error was coming from =
>> >
>> > [<f8c36afd>] dib0700_i2c_xfer+0x44d/0x470 [dvb_usb_dib0700]
>> > [<f8acb5c9>] i2c_transfer+0x69/0xa0 [i2c_core]
>> >  [<f8bf7143>] dib7000p_read_word+0x63/0xc0 [dib7000p]
>> > [<f8bf7ebc>] dib7000p_identify+0x2c/0x130 [dib7000p]
>> > [<f8bf8088>] dib7000p_i2c_enumeration+0xc8/0x270 [dib7000p]
>> > [<f8c37609>] stk7700ph_frontend_attach+0x119/0x1c0 [dvb_usb_dib0700]
>> > [<f8bb207b>] dvb_usb_adapter_frontend_init+0x1b/0x100 [dvb_usb]
>> > [<f8bb1917>] dvb_usb_device_init+0x387/0x600 [dvb_usb]
>> > [<f8c36b75>] dib0700_probe+0x55/0x80 [dvb_usb_dib0700]
>> > [<f88df4e7>] usb_probe_interface+0xa7/0x140 [usbcore]
>> > [<c0201107>] ? sysfs_create_link+0x17/0x20
>> > [<c02c3d4e>] really_probe+0xee/0x190
>> > [<f88de8a9>] ? usb_match_id+0x49/0x60 [usbcore]
>> > [<c02c3e33>] driver_probe_device+0x43/0x60
>> > [<c02c3ec9>] __driver_attach+0x79/0x80
>> > [<c02c3593>] bus_for_each_dev+0x53/0x80
>> > [<c02c3b6e>] driver_attach+0x1e/0x20
>> > [<c02c3e50>] ? __driver_attach+0x0/0x80
>> > [<c02c2f37>] bus_add_driver+0x1b7/0x230
>> > [<c02c409e>] driver_register+0x6e/0x150
>> > [<f88df7bc>] usb_register_driver+0x7c/0xf0 [usbcore]
>> > [<f8991000>] ? dib0700_module_init+0x0/0x55 [dvb_usb_dib0700]
>> > [<f8991000>] ? dib0700_module_init+0x0/0x55 [dvb_usb_dib0700]
>> > [<f8991035>] dib0700_module_init+0x35/0x55 [dvb_usb_dib0700]
>> > [<c0101120>] _stext+0x30/0x160
>> > [<c014c604>] ? __blocking_notifier_call_chain+0x14/0x70
>> > [<c015c208>] sys_init_module+0x88/0x1b0
>> > [<c0103f7b>] sysenter_do_call+0x12/0x2f
>> >
>> > - --
>> > Devin J. Heitmueller
>> > http://www.devinheitmueller.com
>> > AIM: devinheitmueller
>> > -----BEGIN PGP SIGNATURE-----
>> > Version: GnuPG v1.4.9 (GNU/Linux)
>> > Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org
>> >
>> > iEUEARECAAYFAklaDfwACgkQWFF7kkN08jtYyACfYK1gYeyu6UbK1+TmHcIVAd5F
>> > v4EAmILjXFCY/1t0TIdUf+40t0oovBc=
>> > =Pcn+
>> > -----END PGP SIGNATURE-----
>> >
>> >
>>
>>
>>
>> --
>> Devin J. Heitmueller
>> http://www.devinheitmueller.com
>> AIM: devinheitmueller
>>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_103503_30633503.1230908480701
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all, sorry for the delay, I didn&#39;t noticed the first mail. I added this patch, but I don&#39;t own any of this cards; the status was quite strange. One of the testers said that it was working perfectly while the other (there was not much people with that model) said it didn&#39;t work. So, I&#39;m not sure if there is more than one hardware version with the same ID or something similar...<br>
<br>Albert<br><br><div class="gmail_quote">2009/1/2 roshan karki <span dir="ltr">&lt;<a href="mailto:roshan@olenepal.org">roshan@olenepal.org</a>&gt;</span><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Here is the usbsnoop I had taken when I had Windows with me, <br><a href="http://pastebin.com/m49cacaba" target="_blank">http://pastebin.com/m49cacaba</a><br><br><br><br><div class="gmail_quote">On Tue, Dec 30, 2008 at 8:47 PM, Devin Heitmueller <span dir="ltr">&lt;<a href="mailto:devin.heitmueller@gmail.com" target="_blank">devin.heitmueller@gmail.com</a>&gt;</span> wrote:<br>

<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
I looked at the annotation of the patch you sent, and indeed I think<br>
you have the correct patch. &nbsp;I also checked to see if there was a<br>
subsequent change to the GPIO configuration that might have broken<br>
your card, and there doesn&#39;t appear to have been one.<br>
<br>
You can try emailing Patrick Boettcher and see if he has any advice,<br>
since he is driver maintainer for dib0700.<br>
<br>
Also, if you could get a usbsnoop from a Windows system that includes<br>
plugging in the device and starting a capture, I can check to see if<br>
the GPIOs are correct.<br>
<font color="#888888"><br>
Devin<br>
</font><div><div></div><div><br>
On Tue, Dec 30, 2008 at 7:03 AM, Roshan Karki &lt;<a href="mailto:roshan@olenepal.org" target="_blank">roshan@olenepal.org</a>&gt; wrote:<br>
&gt; -----BEGIN PGP SIGNED MESSAGE-----<br>
&gt; Hash: SHA1<br>
&gt;<br>
&gt; Hi,<br>
&gt;<br>
&gt; I&#39;ve found this, this matches my usb id. Is there anything you can do,<br>
&gt; or should I try to contact the author?<br>
&gt; <a href="http://linuxtv.org/hg/v4l-dvb/rev/0dc9cba480ba" target="_blank">http://linuxtv.org/hg/v4l-dvb/rev/0dc9cba480ba</a><br>
&gt;<br>
&gt; On Sat, Dec 20, 2008 at 6:25 AM, Roshan Karki &lt;<a href="mailto:roshan@olenepal.org" target="_blank">roshan@olenepal.org</a>&gt; wrote:<br>
&gt;&gt; &gt; Hello,<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; I have tv-tuner with may laptop. I downloaded the source from<br>
&gt;&gt; &gt; <a href="http://linuxtv.org" target="_blank">linuxtv.org</a> and installed it. It asked for two files<br>
&gt;&gt; &gt; dvb-usb-dib0700-1.20.fw and xc3028-v27.fw. which I copied from internet.<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; I cant however scan for any channels. I have added dump_stack to<br>
&gt;&gt; &gt; dib0700_core.c and here is the dmesg output.<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; <a href="http://pastebin.com/d77534a37" target="_blank">http://pastebin.com/d77534a37</a><br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; snippet from irc<br>
&gt;&gt; &gt; &lt;roxan&gt; devinheitmueller: does it look if my hardware is damaged?<br>
&gt;&gt; &gt; &lt;devinheitmueller&gt; Well, the dib7000p demodulator is not answering the<br>
&gt;&gt; &gt; very first i2c command it is sent, which usually means the chip is<br>
&gt;&gt; &gt; totally non-functional.<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; Please help.<br>
&gt;&gt; &gt; --<br>
&gt;&gt; &gt; Regards,<br>
&gt;&gt; &gt; Roshan Karki<br>
&gt;<br>
&gt; To elaborate on Roshan&#39;s situation (since I spent an hour debugging it<br>
&gt; this morning with him on #linuxtv), basically his problem is the<br>
&gt; dib7000p is not responding to even the i2c query for the vendor info<br>
&gt; (which is the first request sent to the chip). &nbsp;I suspect that perhaps<br>
&gt; the GPIOs are not setup properly and the chip is being held in reset.<br>
&gt;<br>
&gt; I had him rule out faulty hardware by having him boot into Windows and<br>
&gt; successfully perform a capture.<br>
&gt;<br>
&gt; Does anyone know who did the driver work for the &quot;YUAN High-Tech<br>
&gt; STK7700PH&quot; product? &nbsp;I will dig through the hg history if nobody<br>
&gt; speaks up...<br>
&gt;<br>
&gt; Also, there were some bugs in the dib0700 exception handling that made<br>
&gt; this harder to debug than it should have been. &nbsp;I will send Patrick<br>
&gt; some patches next week if I have time (I found three or four issues).<br>
&gt;<br>
&gt; Devin<br>
&gt;<br>
&gt; &nbsp;= Below is the dump_stack() results I had him add so we could see<br>
&gt; where the i2c error was coming from =<br>
&gt;<br>
&gt; [&lt;f8c36afd&gt;] dib0700_i2c_xfer+0x44d/0x470 [dvb_usb_dib0700]<br>
&gt; [&lt;f8acb5c9&gt;] i2c_transfer+0x69/0xa0 [i2c_core]<br>
&gt; &nbsp;[&lt;f8bf7143&gt;] dib7000p_read_word+0x63/0xc0 [dib7000p]<br>
&gt; [&lt;f8bf7ebc&gt;] dib7000p_identify+0x2c/0x130 [dib7000p]<br>
&gt; [&lt;f8bf8088&gt;] dib7000p_i2c_enumeration+0xc8/0x270 [dib7000p]<br>
&gt; [&lt;f8c37609&gt;] stk7700ph_frontend_attach+0x119/0x1c0 [dvb_usb_dib0700]<br>
&gt; [&lt;f8bb207b&gt;] dvb_usb_adapter_frontend_init+0x1b/0x100 [dvb_usb]<br>
&gt; [&lt;f8bb1917&gt;] dvb_usb_device_init+0x387/0x600 [dvb_usb]<br>
&gt; [&lt;f8c36b75&gt;] dib0700_probe+0x55/0x80 [dvb_usb_dib0700]<br>
&gt; [&lt;f88df4e7&gt;] usb_probe_interface+0xa7/0x140 [usbcore]<br>
&gt; [&lt;c0201107&gt;] ? sysfs_create_link+0x17/0x20<br>
&gt; [&lt;c02c3d4e&gt;] really_probe+0xee/0x190<br>
&gt; [&lt;f88de8a9&gt;] ? usb_match_id+0x49/0x60 [usbcore]<br>
&gt; [&lt;c02c3e33&gt;] driver_probe_device+0x43/0x60<br>
&gt; [&lt;c02c3ec9&gt;] __driver_attach+0x79/0x80<br>
&gt; [&lt;c02c3593&gt;] bus_for_each_dev+0x53/0x80<br>
&gt; [&lt;c02c3b6e&gt;] driver_attach+0x1e/0x20<br>
&gt; [&lt;c02c3e50&gt;] ? __driver_attach+0x0/0x80<br>
&gt; [&lt;c02c2f37&gt;] bus_add_driver+0x1b7/0x230<br>
&gt; [&lt;c02c409e&gt;] driver_register+0x6e/0x150<br>
&gt; [&lt;f88df7bc&gt;] usb_register_driver+0x7c/0xf0 [usbcore]<br>
&gt; [&lt;f8991000&gt;] ? dib0700_module_init+0x0/0x55 [dvb_usb_dib0700]<br>
&gt; [&lt;f8991000&gt;] ? dib0700_module_init+0x0/0x55 [dvb_usb_dib0700]<br>
&gt; [&lt;f8991035&gt;] dib0700_module_init+0x35/0x55 [dvb_usb_dib0700]<br>
&gt; [&lt;c0101120&gt;] _stext+0x30/0x160<br>
&gt; [&lt;c014c604&gt;] ? __blocking_notifier_call_chain+0x14/0x70<br>
&gt; [&lt;c015c208&gt;] sys_init_module+0x88/0x1b0<br>
&gt; [&lt;c0103f7b&gt;] sysenter_do_call+0x12/0x2f<br>
&gt;<br>
&gt; - --<br>
&gt; Devin J. Heitmueller<br>
&gt; <a href="http://www.devinheitmueller.com" target="_blank">http://www.devinheitmueller.com</a><br>
&gt; AIM: devinheitmueller<br>
&gt; -----BEGIN PGP SIGNATURE-----<br>
&gt; Version: GnuPG v1.4.9 (GNU/Linux)<br>
&gt; Comment: Using GnuPG with Mozilla - <a href="http://enigmail.mozdev.org" target="_blank">http://enigmail.mozdev.org</a><br>
&gt;<br>
&gt; iEUEARECAAYFAklaDfwACgkQWFF7kkN08jtYyACfYK1gYeyu6UbK1+TmHcIVAd5F<br>
&gt; v4EAmILjXFCY/1t0TIdUf+40t0oovBc=<br>
&gt; =Pcn+<br>
&gt; -----END PGP SIGNATURE-----<br>
&gt;<br>
&gt;<br>
<br>
<br>
<br>
</div></div>--<br>
<div><div></div><div>Devin J. Heitmueller<br>
<a href="http://www.devinheitmueller.com" target="_blank">http://www.devinheitmueller.com</a><br>
AIM: devinheitmueller<br>
</div></div></blockquote></div><br>
<br>_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br></blockquote></div><br>

------=_Part_103503_30633503.1230908480701--


--===============0235997492==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0235997492==--
