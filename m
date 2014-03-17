Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f193.google.com ([209.85.192.193]:44228 "EHLO
	mail-pd0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbaCQSNE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Mar 2014 14:13:04 -0400
Received: by mail-pd0-f193.google.com with SMTP id x10so2415461pdj.4
        for <linux-media@vger.kernel.org>; Mon, 17 Mar 2014 11:13:03 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 17 Mar 2014 18:13:03 +0000
Message-ID: <CALZGuP3taz9pbaBXh4+SSaY0tWi7+t_c+KBL4+vdPNeUyrUdvw@mail.gmail.com>
Subject: blackgold bgt3620 (saa7231 + cxd2820)
From: wab bit <wabbitb01@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

After giving up on my PCTV 340e usb stick, got myself a blackgold
bgt3620, as, supposedly, had a fully functional linux support.
Unfortunately, I'm using kernel 3.12 (and 3.13). This means that the
driver supplied by manufacturer doesn't compile as it does in kubuntu
13.10 (haven't confirmed nor intend to). After some dirty hacks got
the driver to compile and almost works. It doesn't provide bandwidth
and signal strength is always 0 (zero).

Found CrazyCat's repo in bitbucket which contains support for this
card and I'm currently porting that code to 3.13, but don't know the
DVB drivers' current API and haven't found any recent info on that.

What can I use as template/guidelines to help on adding support for this card?

Are the dvb_frontend.{c,h} files to be updated in the near future? eg:
in CrazyCats's code, the struct dvb_tuner_ops and struct
dvb_frontend_tune_settings contain a new member: struct
dvb_frontend_parameters. Is this to be included on future updates of
dvb_frontend.h?


Cheers
