Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:48252 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbZLYNPa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Dec 2009 08:15:30 -0500
Received: from mail01.m-online.net (mail.m-online.net [192.168.3.149])
	by mail-out.m-online.net (Postfix) with ESMTP id 5B70C1C15CE0
	for <linux-media@vger.kernel.org>; Fri, 25 Dec 2009 14:15:27 +0100 (CET)
Received: from localhost (dynscan2.mnet-online.de [192.168.1.215])
	by mail.m-online.net (Postfix) with ESMTP id EBEF7902F3
	for <linux-media@vger.kernel.org>; Fri, 25 Dec 2009 14:15:27 +0100 (CET)
Received: from mail.mnet-online.de ([192.168.3.149])
	by localhost (dynscan2.mnet-online.de [192.168.1.215]) (amavisd-new, port 10024)
	with ESMTP id XWKnDS+1iwIt for <linux-media@vger.kernel.org>;
	Fri, 25 Dec 2009 14:15:26 +0100 (CET)
Received: from [192.168.1.5] (ppp-88-217-19-215.dynamic.mnet-online.de [88.217.19.215])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.mnet-online.de (Postfix) with ESMTP
	for <linux-media@vger.kernel.org>; Fri, 25 Dec 2009 14:15:26 +0100 (CET)
Message-ID: <4B34BAEE.4040104@a-city.de>
Date: Fri, 25 Dec 2009 14:15:26 +0100
From: TAXI <taxi@a-city.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Bad image/sound quality with Medion MD 95700
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

BOUWSMA Barry schrieb:
> > Das Problem ist, der Treiber erwartet BULK Datei, nicht ISOC, aber
> > das Kistchen liefert ISOC (isochronous) Datei.  Deswegen kommt es
> > zu Probleme.
> >
> > Or, the thing is, Linux is expecting to be seeing bulk data on
> > this particular alternate interface (6).  If the receiver is not
> > delivering this, but is instead delivering isochronous data, it's
> > not in the same format and isn't properly handled by the driver.
> >
> > Changing it so that the driver reads from alternate interface 0
> > results in all my hacked versions being able to read the data
> > properly.  Even before reading isoc data through hubs was fixed
> > sometime around or before 2.6.18-ish.
und diese verwechslung verursacht die bild-/tonfehler?

and this confusion causes the image/sound issues?

> > Hast Du die 2.6.32 Quellkode?  Kannst Du aus `patches' etwas
> > schaffen, und dabei die beide Moeglichkeiten testen?
> >
> > (Are you able to build a new kernel to test my patches to see
> > if they solve your problem?)

Ja habe ich. Leichte patch anpassungen bekomme ich meist auchnoch hin.
Wirklich programmieren kann ich aber nicht.

Yes I have. I have little skills in patch adjustments (very little). But
I'm not a developer so I have no coding skills.

Vielen Dank im vorraus für deine Hilfe.
Thank you in advance for your help.

P.S. a few words in my text are google translated  ;)



//forgotten to set the mailer in CC ;)
