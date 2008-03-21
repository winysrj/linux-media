Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.155])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1Jchwm-0002MJ-50
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 15:10:17 +0100
Received: by fg-out-1718.google.com with SMTP id 22so1095064fge.25
	for <linux-dvb@linuxtv.org>; Fri, 21 Mar 2008 07:09:55 -0700 (PDT)
Message-ID: <ea4209750803210709r63fb8dc5y1cfa11229150472e@mail.gmail.com>
Date: Fri, 21 Mar 2008 15:09:55 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: hfvogt@gmx.net
In-Reply-To: <ea4209750803210459i3fe6fddan103931bda885435e@mail.gmail.com>
MIME-Version: 1.0
References: <200803211152.26870.hfvogt@gmx.net>
	<ea4209750803210459i3fe6fddan103931bda885435e@mail.gmail.com>
Cc: Felix Apitzsch <F.Apitzsch@soz.uni-frankfurt.de>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] PATCH Pinnacle 320cx Terratec Cinergy HT USB XE -
	Draft 2
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1777227618=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1777227618==
Content-Type: multipart/alternative;
	boundary="----=_Part_13547_2860514.1206108595125"

------=_Part_13547_2860514.1206108595125
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hey Hans, I'm spending some time, because right now I've not been able to
make my card working with your patch. Everything seems ok, but no channels
detected and no video at all... strange. Did you checked that it was working
ok?

2008/3/21, Albert Comerma <albert.comerma@gmail.com>:
>
> Perfect!! it seems great, now I will check it (sorry, I was very busy last
> two days). I also will add support for Felix's card and the two cards I have
> pending (just add device id and small modifications), so it will be easier
> for patrick to add the different patches to the current source. Just one
> comment, how you generated the patch? because mauro suggested it's better to
> use hg diff. In a minutes I will send the modified patch (I hope it will be
> the last version).
>
> Albert
>
> 2008/3/21, Hans-Frieder Vogt <hfvogt@gmx.net>:
> >
> > Hi Albert,
> >
> > I have slightly changed the stk7700ph_frontend_attach GPIO sequence to
> > be in line with the Windows behaviour and also add
> > the demod-value in stk7700ph_xc3028_ctrl, to make the driver load the
> > right SCODE file (which seems to have no effect,
> > though). Also, I removed the unused and unneeded xc3028_bw_config_12mhz
> > structure.
> > In addition, I followed Mauro's request for coding style changes and
> > also add some more kernel style changes that
> > checkpatch highlighted (I only introduced changes where they seemed
> > sensible, there are many, many other
> > areas in the file dib0700_devices.c where it does not follow the strict
> > coding guidelines as well).
> >
> > Can you please confirm that I included your changes for the Pinnacle
> > 320cx correctly and perhaps also add a signoff-line?
> > Thanks very much.
> >
> > Hans-Frieder
> >
> > --
> >
> > --
> > Hans-Frieder Vogt                 e-mail: hfvogt <at> gmx .dot. net
> >
> >
>

------=_Part_13547_2860514.1206108595125
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hey Hans, I&#39;m spending some time, because right now I&#39;ve not been able to make my card working with your patch. Everything seems ok, but no channels detected and no video at all... strange. Did you checked that it was working ok?<br>
<br><div><span class="gmail_quote">2008/3/21, Albert Comerma &lt;<a href="mailto:albert.comerma@gmail.com">albert.comerma@gmail.com</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Perfect!! it seems great, now I will check it (sorry, I was very busy last two days). I also will add support for Felix&#39;s card and the two cards I have pending (just add device id and small modifications), so it will be easier for patrick to add the different patches to the current source. Just one comment, how you generated the patch? because mauro suggested it&#39;s better to use hg diff. In a minutes I will send the modified patch (I hope it will be the last version).<br>

<br>Albert<br><br><div><span class="gmail_quote">2008/3/21, Hans-Frieder Vogt &lt;<a href="mailto:hfvogt@gmx.net" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">hfvogt@gmx.net</a>&gt;:</span><div>
<span class="e" id="q_118d134d6b6d906e_1"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi Albert,<br> <br> I have slightly changed the stk7700ph_frontend_attach GPIO sequence to be in line with the Windows behaviour and also add<br> the demod-value in stk7700ph_xc3028_ctrl, to make the driver load the right SCODE file (which seems to have no effect,<br>

 though). Also, I removed the unused and unneeded xc3028_bw_config_12mhz structure.<br> In addition, I followed Mauro&#39;s request for coding style changes and also add some more kernel style changes that<br> checkpatch highlighted (I only introduced changes where they seemed sensible, there are many, many other<br>

 areas in the file dib0700_devices.c where it does not follow the strict coding guidelines as well).<br> <br> Can you please confirm that I included your changes for the Pinnacle 320cx correctly and perhaps also add a signoff-line?<br>

 Thanks very much.<br> <br> Hans-Frieder<br> <br> --<br> <br>--<br> Hans-Frieder Vogt&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; e-mail: hfvogt &lt;at&gt; gmx .dot. net<br> <br></blockquote></span></div></div><br>
</blockquote></div><br>

------=_Part_13547_2860514.1206108595125--


--===============1777227618==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1777227618==--
