Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1JQnFi-0007ha-OA
	for linux-dvb@linuxtv.org; Sun, 17 Feb 2008 18:24:34 +0100
Received: by fg-out-1718.google.com with SMTP id 22so1070779fge.25
	for <linux-dvb@linuxtv.org>; Sun, 17 Feb 2008 09:24:34 -0800 (PST)
Message-ID: <ea4209750802170924w3517283el96a3c196e9c8d077@mail.gmail.com>
Date: Sun, 17 Feb 2008 18:24:34 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: hfvogt@gmx.net
In-Reply-To: <200802171732.36144.hfvogt@gmx.net>
MIME-Version: 1.0
References: <200802112223.11129.hfvogt@gmx.net>
	<ea4209750802170414n6e4f82dam4c6908536b695033@mail.gmail.com>
	<ea4209750802170506o55b8b751u5c189f15bd140f44@mail.gmail.com>
	<200802171732.36144.hfvogt@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] support Cinergy HT USB XE (0ccd:0058)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0741585001=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0741585001==
Content-Type: multipart/alternative;
	boundary="----=_Part_19690_32414409.1203269074450"

------=_Part_19690_32414409.1203269074450
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Hans, with this configuration it does not work. As I commented it seems
that it does not work if GPIO6 is set to 1. If I change to 0 it works fine.
Just one comment, GPIO0 for sure is the LED output of my card. :P

Albert

2008/2/17, Hans-Frieder Vogt <hfvogt@gmx.net>:
>
> Albert,
>
> I am happy to hear that your TV-card finally works.
> However, I am still a bit unsure about these GPIO settings. Initially, I
> just copied the GPIO-settings from another entry and
> then left it because it seemed to work. Now, I have digged a little bit
> into this issue and found, that under Windows my
> STK7700PH-based stick gets the GPIO set in a different way.
> Could you please try the following modified stk7700ph_frontend_attach
> routine (in dib0700_devices.c) and tell me
> whether this works for your card as well?
>
>
> static int stk7700ph_frontend_attach(struct dvb_usb_adapter *adap)
>
> {
>
>         dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 1);
>
>         msleep(20);
>
>         dib0700_set_gpio(adap->dev, GPIO9, GPIO_OUT, 1);
>
>         dib0700_set_gpio(adap->dev, GPIO4, GPIO_OUT, 1);
>         dib0700_set_gpio(adap->dev, GPIO7, GPIO_OUT, 1);
>
>         dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 0);
>         msleep(10);
>
>         dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 1);
>
>         msleep(20);
>
>         dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 1);
>
>         msleep(10);
>
>
>         dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
> &stk7700ph_dib7700_xc3028_config);
>
>         adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80,
>                                 &stk7700ph_dib7700_xc3028_config);
>
>         return adap->fe == NULL ? -ENODEV : 0;
> }
>
>
> By the way, I also experience the same problem with the missing SNR info,
> on two different dib0700-based USB cards.
>
> Regards,
> Hans-Frieder
>
> Am Sonntag, 17. Februar 2008 schrieb Albert Comerma:
>
> > I got it!!!! I remembered that on PCTV DVB-T 72e they had a similar
> problem,
> > which was solved leaving GPIO6 to 0. Doing this the tuning seems to work
> > fine. SNR is always reported as 0% but I think this is not a problem,
> now I
> > can scan and tune dvb-t channels. Firmware is 1.10 and xc3028-v27 with
> that
> > modification. Thanks a lot for your help. Next step would be analog.
> >
> > Albert
> >
>
>
>
>
> --
>
> --
> Hans-Frieder Vogt                 e-mail:  hfvogt <at> gmx .dot. net
>

------=_Part_19690_32414409.1203269074450
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Hans, with this configuration it does not work. As I commented it seems that it does not work if GPIO6 is set to 1. If I change to 0 it works fine. Just one comment, GPIO0 for sure is the LED output of my card. :P<br><br>
Albert<br><br><div><span class="gmail_quote">2008/2/17, Hans-Frieder Vogt &lt;<a href="mailto:hfvogt@gmx.net">hfvogt@gmx.net</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Albert,<br> <br> I am happy to hear that your TV-card finally works.<br> However, I am still a bit unsure about these GPIO settings. Initially, I just copied the GPIO-settings from another entry and<br> then left it because it seemed to work. Now, I have digged a little bit into this issue and found, that under Windows my<br>
 STK7700PH-based stick gets the GPIO set in a different way.<br> Could you please try the following modified stk7700ph_frontend_attach routine (in dib0700_devices.c) and tell me<br> whether this works for your card as well?<br>
 <br><br> static int stk7700ph_frontend_attach(struct dvb_usb_adapter *adap)<br> <br>{<br> <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;dib0700_set_gpio(adap-&gt;dev, GPIO6, GPIO_OUT, 1);<br> <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;msleep(20);<br> <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;dib0700_set_gpio(adap-&gt;dev, GPIO9, GPIO_OUT, 1);<br>
 <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;dib0700_set_gpio(adap-&gt;dev, GPIO4, GPIO_OUT, 1);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;dib0700_set_gpio(adap-&gt;dev, GPIO7, GPIO_OUT, 1);<br> <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;dib0700_set_gpio(adap-&gt;dev, GPIO10, GPIO_OUT, 0);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;msleep(10);<br>
 <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;dib0700_set_gpio(adap-&gt;dev, GPIO10, GPIO_OUT, 1);<br> <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;msleep(20);<br> <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;dib0700_set_gpio(adap-&gt;dev, GPIO0, GPIO_OUT, 1);<br> <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;msleep(10);<br> <br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;dib7000p_i2c_enumeration(&amp;adap-&gt;dev-&gt;i2c_adap, 1, 18, &amp;stk7700ph_dib7700_xc3028_config);<br>
 <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;adap-&gt;fe = dvb_attach(dib7000p_attach, &amp;adap-&gt;dev-&gt;i2c_adap, 0x80,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&amp;stk7700ph_dib7700_xc3028_config);<br> <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;return adap-&gt;fe == NULL ? -ENODEV : 0;<br>
 }<br> <br> <br>By the way, I also experience the same problem with the missing SNR info, on two different dib0700-based USB cards.<br> <br> Regards,<br> Hans-Frieder<br> <br> Am Sonntag, 17. Februar 2008 schrieb Albert Comerma:<br>
 <br>&gt; I got it!!!! I remembered that on PCTV DVB-T 72e they had a similar problem,<br> &gt; which was solved leaving GPIO6 to 0. Doing this the tuning seems to work<br> &gt; fine. SNR is always reported as 0% but I think this is not a problem, now I<br>
 &gt; can scan and tune dvb-t channels. Firmware is 1.10 and xc3028-v27 with that<br> &gt; modification. Thanks a lot for your help. Next step would be analog.<br> &gt;<br> &gt; Albert<br> &gt;<br> <br> <br> <br> <br>--<br>
 <br>--<br> Hans-Frieder Vogt&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; e-mail:&nbsp;&nbsp;hfvogt &lt;at&gt; gmx .dot. net<br> </blockquote></div><br>

------=_Part_19690_32414409.1203269074450--


--===============0741585001==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0741585001==--
