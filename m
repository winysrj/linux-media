Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.224])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JsvD4-00053L-NI
	for linux-dvb@linuxtv.org; Mon, 05 May 2008 09:34:07 +0200
Received: by rv-out-0506.google.com with SMTP id b25so1902647rvf.41
	for <linux-dvb@linuxtv.org>; Mon, 05 May 2008 00:34:00 -0700 (PDT)
Message-ID: <617be8890805050034q5ce1734dq3b10c5af3aac3ac7@mail.gmail.com>
Date: Mon, 5 May 2008 09:34:00 +0200
From: "Eduard Huguet" <eduardhc@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Finally got Avermedia A700 (DVB-S Pro) working!
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0022974189=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0022974189==
Content-Type: multipart/alternative;
	boundary="----=_Part_10444_18477667.1209972840754"

------=_Part_10444_18477667.1209972840754
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
    Just a quick note: the Avermedia DVB-S Pro (A700) is yet working on my
computer, finally. I'm using your lastest patch set (from May 2), but what
really did the trick was using an enhanced frequency file for Astra 19.2
(got it from http://joshyfun.peque.org/transponders/kaffeine.html), instead
of the standard one provided in /usr/share/dvb/dvb-s/Astra 19.2.

   With the standard file the driver didn't work, as usual. However, as the
driver seemed to be working for other people I spent some time googling for
problems related to DVB-S, Kaffeine, etc..., and I found that page which
provides an extensive reference for the satellites our there in Kaffeine
format. I just tried the one for Astra 19.2, and to my surprise it worked
perfectly :D !

   So: the driver works, I suppose this is good news :D for you, Matthias.
However, as I'm a complete noob regarding DVB-S I don't know if the driver
SHOULD work and detect all available channels using only the default Astra
19.2 file, or else really that file is incomplete and should not be used.

   Tonight I'll move the card to my MythTV computer and try the driver in
it. This one is running Gentoo 64, so I'll provide feedback on that arch
too. By now, the card is running perfectly on x86, Gentoo kernel 2.6.24 and
Kaffeine.

   Just a little note: the lastest patch doesn't compile "as is": in
saa7134-dvb.c, the function "mt312_attach()" is called and it's not defined
anywhere. I figured out the correct one was "vp310_mt312_attach()" so I
changed it. Now the driver compiles and works fine :D.

You really did a great job, Matthias
  Eduard

------=_Part_10444_18477667.1209972840754
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi, <br>&nbsp;&nbsp;&nbsp; Just a quick note: the Avermedia DVB-S Pro (A700) is yet working on my computer, finally. I&#39;m using your lastest patch set (from May 2), but what really did the trick was using an enhanced frequency file for Astra 19.2 (got it from <a href="http://joshyfun.peque.org/transponders/kaffeine.html">http://joshyfun.peque.org/transponders/kaffeine.html</a>), instead of the standard one provided in /usr/share/dvb/dvb-s/Astra 19.2.<br>
<br>&nbsp;&nbsp; With the standard file the driver didn&#39;t work, as usual. However, as the driver seemed to be working for other people I spent some time googling for problems related to DVB-S, Kaffeine, etc..., and I found that page which provides an extensive reference for the satellites our there in Kaffeine format. I just tried the one for Astra 19.2, and to my surprise it worked perfectly :D !<br>
<br>&nbsp;&nbsp; So: the driver works, I suppose this is good news :D for you, Matthias. However, as I&#39;m a complete noob regarding DVB-S I don&#39;t know if the driver SHOULD work and detect all available channels using only the default Astra 19.2 file, or else really that file is incomplete and should not be used.<br>
<br>&nbsp;&nbsp; Tonight I&#39;ll move the card to my MythTV computer and try the driver in it. This one is running Gentoo 64, so I&#39;ll provide feedback on that arch too. By now, the card is running perfectly on x86, Gentoo kernel 2.6.24 and Kaffeine.<br>
<br>&nbsp;&nbsp; Just a little note: the lastest patch doesn&#39;t compile &quot;as is&quot;: in saa7134-dvb.c, the function &quot;mt312_attach()&quot; is called and it&#39;s not defined anywhere. I figured out the correct one was &quot;vp310_mt312_attach()&quot; so I changed it. Now the driver compiles and works fine :D.<br>
<br>You really did a great job, Matthias<br>&nbsp; Eduard<br><br><br>

------=_Part_10444_18477667.1209972840754--


--===============0022974189==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0022974189==--
