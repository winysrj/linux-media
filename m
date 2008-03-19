Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.157])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1JbyUp-0006Wy-Cc
	for linux-dvb@linuxtv.org; Wed, 19 Mar 2008 14:38:26 +0100
Received: by fg-out-1718.google.com with SMTP id 22so325868fge.25
	for <linux-dvb@linuxtv.org>; Wed, 19 Mar 2008 06:38:18 -0700 (PDT)
Message-ID: <ea4209750803190638l4742eb75v1c9fcda358731ddf@mail.gmail.com>
Date: Wed, 19 Mar 2008 14:38:17 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: "Felix Apitzsch" <F.Apitzsch@soz.uni-frankfurt.de>
In-Reply-To: <20080318235950.txkealw3k4k40o0o@webmail.server.uni-frankfurt.de>
MIME-Version: 1.0
References: <47DEF7DE.9080709@soz.uni-frankfurt.de>
	<ea4209750803171610u22e948fcl4812f5c873801b64@mail.gmail.com>
	<20080318235950.txkealw3k4k40o0o@webmail.server.uni-frankfurt.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Terratec Cinergy HT Express: It works!
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0818744565=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0818744565==
Content-Type: multipart/alternative;
	boundary="----=_Part_4221_29101623.1205933897803"

------=_Part_4221_29101623.1205933897803
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Good news! If you want I can add it to the patch pending, if you send me
your dib0700_devices.c and dvb-usb-ids.h.

Albert

2008/3/18, Felix Apitzsch <F.Apitzsch@soz.uni-frankfurt.de>:
>
> OK, my Terratec Cinergy HT Express now works with dvb-linux.
> I managed to apply the patch by Hans-Frieder and Albert. Thanks for
> your work! Additionally, I added my card's description to
> dvb-usb-ids.h and dib0700_devices.c . (Should I post the files?)
>
> I read the website before I posted my first email, but screwed up
> applying the patch correctly. Now I started all over to compare and
> include the new parts into today's development snapshot and it works.
>
> I could scan channels and (using MPlayer) tune and even had audio working.
>
> I was not sure about the xc3028 firmware, since my card's windows
> driver does not contain any emBDA.sys but only a XC3028.rom which
> looks different. Anyhow I did not try to extract any firmware myself.
> I just took an existing xc3028-v27.fw and copied it into
> /lib/firmware. I am not even sure it is loaded, but it works.
>
> Could someone please add the my card together with the Pinnacle 320cx
> and Terratec Cinergy HT USB XE to the dvb-linux development tree and
> the wiki?
>
> Thanks,
>
> Felix
>
> Quoting Albert Comerma <albert.comerma@gmail.com>:
>
> > To make dvb-t working (not analog), please have a look at my page;
> > http://www.comerma.net/pinnacle320cx_en.html
> > It should work for you just adding your device descriptor to
> > dvb-usb-ids.hand your card at dib0700_devices.c, I would try first to
> > use the same
> > frontend attach as other cinergy usb cards. If you think it's to
> complicated
> > I can try to add it for you, tomorrow. Please let me know.
> >
> > Albert
> >
> > 2008/3/17, Felix Apitzsch <f.apitzsch@soz.uni-frankfurt.de>:
> >>
> >> Im am trying to get my Terratec Cinergy HT Express to work with
> v4l-dvb.
> >>
> >> It's a DVB-T/analog hybrid (+radio) ExpressCard 34, but it connects
> >> via the usb interface, not the pci-e interface. To confirm what I
> >> reckoned, I openend the device to find the following:
> >>
> >> DiBcom 7700C1-ACXXa-G QH0T8 D2PRJ.1 0646-1100-C
> >>
> >> XCEIVE XC3028 AK47465,2 0620TWE3
> >>
> >> CONEXANT CX25843-24Z 61024448 0625 KOREA
> >>
> >> (I took some photos if someone is interested)
> >>
> >> The usd-id is 0ccd:0060 .
> >>
> >> For now, I would be happy to live with just DVB-T support.
> >> As far as I understand the status quo, it should be possible to get
> >> the card running, isn't it?
> >>
> >> I would need some help to get the xc3028 part compiled and running and
> >> add it to dib0700_devices.c and dvb-usb-ids.h with the right config
> >> for the DIB770C1+XC3028. Additionally, I would need some assistance
> >> with the firmware xc3028. The dib0700 firmeware should be ok.
> >>
> >> Also, I had some trouble when I tried to get the xc3028 frontend code
> >> compiled. It is not in v4l_experimental anymore, is it? Where did it
> >> go and how do I include it?
> >>
> >> Could anyone do a patch for me and pack me a .bz2, so I can do some
> >> testing?
> >>
> >> I am running a kernel 2.6.24 on a x86_64 (~amd64) gentoo system with
> >> current v4l-dvb-hg from portage.
> >>
> >> Felix
> >>
> >> _______________________________________________
> >> linux-dvb mailing list
> >> linux-dvb@linuxtv.org
> >> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >>
> >
>
>

------=_Part_4221_29101623.1205933897803
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Good news! If you want I can add it to the patch pending, if you send me your dib0700_devices.c and dvb-usb-ids.h.<br><br>Albert<br><br><div><span class="gmail_quote">2008/3/18, Felix Apitzsch &lt;<a href="mailto:F.Apitzsch@soz.uni-frankfurt.de">F.Apitzsch@soz.uni-frankfurt.de</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
OK, my Terratec Cinergy HT Express now works with dvb-linux.<br> I managed to apply the patch by Hans-Frieder and Albert. Thanks for<br> your work! Additionally, I added my card&#39;s description to<br> dvb-usb-ids.h and dib0700_devices.c . (Should I post the files?)<br>
 <br> I read the website before I posted my first email, but screwed up<br> applying the patch correctly. Now I started all over to compare and<br> include the new parts into today&#39;s development snapshot and it works.<br>
 <br> I could scan channels and (using MPlayer) tune and even had audio working.<br> <br> I was not sure about the xc3028 firmware, since my card&#39;s windows<br> driver does not contain any emBDA.sys but only a XC3028.rom which<br>
 looks different. Anyhow I did not try to extract any firmware myself.<br> I just took an existing xc3028-v27.fw and copied it into<br> /lib/firmware. I am not even sure it is loaded, but it works.<br> <br> Could someone please add the my card together with the Pinnacle 320cx<br>
 and Terratec Cinergy HT USB XE to the dvb-linux development tree and<br> the wiki?<br> <br> Thanks,<br> <br> Felix<br> <br> Quoting Albert Comerma &lt;<a href="mailto:albert.comerma@gmail.com">albert.comerma@gmail.com</a>&gt;:<br>
 <br> &gt; To make dvb-t working (not analog), please have a look at my page;<br> &gt; <a href="http://www.comerma.net/pinnacle320cx_en.html">http://www.comerma.net/pinnacle320cx_en.html</a><br> &gt; It should work for you just adding your device descriptor to<br>
 &gt; dvb-usb-ids.hand your card at dib0700_devices.c, I would try first to<br> &gt; use the same<br> &gt; frontend attach as other cinergy usb cards. If you think it&#39;s to complicated<br> &gt; I can try to add it for you, tomorrow. Please let me know.<br>
 &gt;<br> &gt; Albert<br> &gt;<br> &gt; 2008/3/17, Felix Apitzsch &lt;<a href="mailto:f.apitzsch@soz.uni-frankfurt.de">f.apitzsch@soz.uni-frankfurt.de</a>&gt;:<br> &gt;&gt;<br> &gt;&gt; Im am trying to get my Terratec Cinergy HT Express to work with v4l-dvb.<br>
 &gt;&gt;<br> &gt;&gt; It&#39;s a DVB-T/analog hybrid (+radio) ExpressCard 34, but it connects<br> &gt;&gt; via the usb interface, not the pci-e interface. To confirm what I<br> &gt;&gt; reckoned, I openend the device to find the following:<br>
 &gt;&gt;<br> &gt;&gt; DiBcom 7700C1-ACXXa-G QH0T8 D2PRJ.1 0646-1100-C<br> &gt;&gt;<br> &gt;&gt; XCEIVE XC3028 AK47465,2 0620TWE3<br> &gt;&gt;<br> &gt;&gt; CONEXANT CX25843-24Z 61024448 0625 KOREA<br> &gt;&gt;<br> &gt;&gt; (I took some photos if someone is interested)<br>
 &gt;&gt;<br> &gt;&gt; The usd-id is 0ccd:0060 .<br> &gt;&gt;<br> &gt;&gt; For now, I would be happy to live with just DVB-T support.<br> &gt;&gt; As far as I understand the status quo, it should be possible to get<br> &gt;&gt; the card running, isn&#39;t it?<br>
 &gt;&gt;<br> &gt;&gt; I would need some help to get the xc3028 part compiled and running and<br> &gt;&gt; add it to dib0700_devices.c and dvb-usb-ids.h with the right config<br> &gt;&gt; for the DIB770C1+XC3028. Additionally, I would need some assistance<br>
 &gt;&gt; with the firmware xc3028. The dib0700 firmeware should be ok.<br> &gt;&gt;<br> &gt;&gt; Also, I had some trouble when I tried to get the xc3028 frontend code<br> &gt;&gt; compiled. It is not in v4l_experimental anymore, is it? Where did it<br>
 &gt;&gt; go and how do I include it?<br> &gt;&gt;<br> &gt;&gt; Could anyone do a patch for me and pack me a .bz2, so I can do some<br> &gt;&gt; testing?<br> &gt;&gt;<br> &gt;&gt; I am running a kernel 2.6.24 on a x86_64 (~amd64) gentoo system with<br>
 &gt;&gt; current v4l-dvb-hg from portage.<br> &gt;&gt;<br> &gt;&gt; Felix<br> &gt;&gt;<br> &gt;&gt; _______________________________________________<br> &gt;&gt; linux-dvb mailing list<br> &gt;&gt; <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
 &gt;&gt; <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br> &gt;&gt;<br> &gt;<br> <br> </blockquote></div><br>

------=_Part_4221_29101623.1205933897803--


--===============0818744565==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0818744565==--
