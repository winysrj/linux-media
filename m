Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63484 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab0HULtF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Aug 2010 07:49:05 -0400
Received: by ewy23 with SMTP id 23so2684192ewy.19
        for <linux-media@vger.kernel.org>; Sat, 21 Aug 2010 04:49:04 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 21 Aug 2010 16:19:03 +0430
Message-ID: <AANLkTikM_Fn_kdjYkkyBZpn8yE9KbGwZu14Wu+RaGbmm@mail.gmail.com>
Subject: Both Skystar 2 rev 2.8 and Skystar S2 on the same box
From: mehdi karamnejad <mehdi.karamnejad@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

I have a Skystar S2 card up and running using  s2-liplianin driver , I
recently have obtained a skystar 2 rev2.8 card and I'm plannig to use
both of the cards on the same box , but  when I add the skystar 2 rev
2.8 card it doesn't get detected by linux and no entry is created for
it in /dev/dvb folder (skystar S2 card is still functional) , here is
the dmesg output of my system when both cards are inserted:
http://pastebin.com/VAGaBg75
my guess is that since both cards share some kernel modules, their
shared modules should separated to  function properly, am I right? if
yes how can I for example separate cx24123 module used by Skystar S2
from the one used by  skystar 2 rev 2.8 card.
or are there any other approaches to make this work?

link to my skystar 2 rev 2.8 card:
http://cvs.linuxtv.org/wiki/index.php/TechniSat_SkyStar_2_TV_PCI_/_Sky2PC_PCI#Technisat_SkyStar_2_TV_PCI_with_FlexCopIII_Rev_2.8
link to my skystar S2 card:
http://www.linuxtv.org/wiki/index.php/TechniSat_SkyStar_S2
--
:-----:
> Mehdi Karamnejad
