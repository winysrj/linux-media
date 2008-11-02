Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1KwVNj-0002uZ-Oh
	for linux-dvb@linuxtv.org; Sun, 02 Nov 2008 06:20:13 +0100
Received: by ey-out-2122.google.com with SMTP id 25so654127eya.17
	for <linux-dvb@linuxtv.org>; Sat, 01 Nov 2008 22:20:08 -0700 (PDT)
Date: Sun, 2 Nov 2008 06:20:00 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: linux-dvb@linuxtv.org
Message-ID: <alpine.DEB.2.00.0811020532490.14582@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1274729070-1225603203=:14582"
Subject: [linux-dvb] Updates to scanfiles for Germany in November
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1274729070-1225603203=:14582
Content-Type: TEXT/PLAIN; charset=US-ASCII

Moin moin,

During the month of November 2008, there will be some changes
made in several areas of Germany to the DVB-T transmitters,
including switching over some remaining analogue transmitters,
but also some shuffling of frequencies to agree to the Geneve
2006 international frequency coordination.

Before the end of this (coming) week, on 05.11.2008, one existing
scanfile for Stuttgart (Baden-Wuerttemberg) will be completely
incorrect.  For this, I submit a new scanfile that should
replace the existing one sometime this week -- exactly when
will determine what sort of period of limbo users will
suffer, depending how they get their scanfile...

In any case, also affected is Heidelberg, for which there
exists no scanfile.  Therefore, I've decided to create an
initial scanfile for all of Baden-Wuerttemberg to cover
all frequencies as of 05.11, and to address the issue of
additional nearby frequencies which can be received -- near
Heidelberg, one likely also sees signals from Hessen and
Rheinland-Pfalz, at least.

I hope to post that much longer scanfile in time for the
frequency changes, and try to do the same for other
Bundeslaender (Rheinland-Pfalz a week later; Bayern near
the end of the month).

Even with such an all-encompassing scanfile, I still think
de-Stuttgart should continue to exist, being a large city
with its own transmitter and no nearby transmitters with any
additional programming, for people who know they are in
Stuttgart but have no idea what Bundesland it is.

However, de-Baden-Baden, de-Freiburg, de-Loerrach, and
de-Ravensburg should disappear, being better served (in
my opinion) by the combined all-encompassing all-dancing
regional scanfile...

As I'll submit it, the regional scanfile will by default
scan all 16 frequencies (one of which will be obsolete
after some months) used by all trasmitters, and will
allow power-users to customise it to uncomment nearby
frequencies, assuming they know where they are.  If,
though, it's better to by default scan all possibly
nearby frequencies, be they from Hessen or Austria,
I could uncomment them, roughly tripling frequencies
and greatly increasing scan time.  Your call...


thanks,
barry bouwsma

--8323328-1274729070-1225603203=:14582
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=de-Stuttgart
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.00.0811020620000.14582@ybpnyubfg.ybpnyqbznva>
Content-Description: New frequencies 05.Nov Stuttgart
Content-Disposition: attachment; filename=de-Stuttgart

IyBEVkItVCBTdHV0dGdhcnQgKGZyb20gMDUuMTEuMjAwOCkNCiMgYnkgSm9l
cmcgTWFyaGVua2UgKGpvZXJnLm1hcmhlbmtlQHVuaS11bG0uZGUpDQoNClQg
NDkwMDAwMDAwIDhNSHogMi8zIE5PTkUgUUFNMTYgOGsgMS80IE5PTkUJIyBL
MjMgWkRGbW9iaWwNClQgNTE0MDAwMDAwIDhNSHogMi8zIE5PTkUgUUFNMTYg
OGsgMS80IE5PTkUJIyBLMjYgQVJEDQpUIDcwNjAwMDAwMCA4TUh6IDIvMyBO
T05FIFFBTTE2IDhrIDEvNCBOT05FCSMgSzUwIFNXUg0K

--8323328-1274729070-1225603203=:14582
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--8323328-1274729070-1225603203=:14582--
