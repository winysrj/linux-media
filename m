Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <kknull0@gmail.com>) id 1KRZq0-0003LV-BJ
	for linux-dvb@linuxtv.org; Fri, 08 Aug 2008 23:49:33 +0200
Received: by yx-out-2324.google.com with SMTP id 8so279459yxg.41
	for <linux-dvb@linuxtv.org>; Fri, 08 Aug 2008 14:49:27 -0700 (PDT)
Message-ID: <57ed08da0808081449m598af353n7edf908551753318@mail.gmail.com>
Date: Fri, 8 Aug 2008 23:49:27 +0200
From: Xaero <kknull0@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Pinnacle pctv hybrid pro stick 340e support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1637909068=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1637909068==
Content-Type: multipart/alternative;
	boundary="----=_Part_52963_16612312.1218232167853"

------=_Part_52963_16612312.1218232167853
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
I'm trying to make the 340e card work. (This is a reply to Gerard post, I've
just subscribed to this list and I didn't know how to reply, sorry :D)
I have the same lsusb output as Gerard. but I can't get more information
from dmesg:
I get only

usb 6-8: new high speed USB device using ehci_hcd and address 8
usb 6-8: configuration #1 chosen from 1 choice

when the card is plugged. (maybe I have to configure some kernel options?)

Btw, I tried the dib0770 modules (following Albert's instructions) , and no
dvb devices are created, so i don't think they'rer the right drivers (I'm
not sure again, dmesg doesn't write anything)...
Suggestion?
Thanks.
KKnull

------=_Part_52963_16612312.1218232167853
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Hi, <br>I&#39;m trying to make the 340e card work. (This is a reply to Gerard post, I&#39;ve just subscribed to this list and I didn&#39;t know how to reply, sorry :D)<br>I have the same lsusb output as Gerard. but I can&#39;t get more information from dmesg:<br>
I get only <br><br>usb 6-8: new high speed USB device using ehci_hcd and address 8<br>usb 6-8: configuration #1 chosen from 1 choice<br><br>when the card is plugged. (maybe I have to configure some kernel options?)<br><br>
Btw, I tried the dib0770 modules (following Albert&#39;s instructions) , and no dvb devices are created, so i don&#39;t think they&#39;rer the right drivers (I&#39;m not sure again, dmesg doesn&#39;t write anything)...<br>
Suggestion?<br>Thanks.<br>KKnull<br></div>

------=_Part_52963_16612312.1218232167853--


--===============1637909068==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1637909068==--
