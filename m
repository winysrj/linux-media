Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40001 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab1F2TIp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 15:08:45 -0400
Received: by wyg8 with SMTP id 8so1085299wyg.19
        for <linux-media@vger.kernel.org>; Wed, 29 Jun 2011 12:08:44 -0700 (PDT)
From: Bogdan Cristea <cristeab@gmail.com>
To: Christoph Pfister <christophpfister@gmail.com>
Subject: Re: Patch proposition for DVB-T configuration file for Paris area
Date: Wed, 29 Jun 2011 21:05:46 +0200
References: <201106282147.03423.cristeab@gmail.com> <BANLkTim5eH6sSaK0tL98MrZaRgR2++M67Q@mail.gmail.com>
In-Reply-To: <BANLkTim5eH6sSaK0tL98MrZaRgR2++M67Q@mail.gmail.com>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106292105.46819.cristeab@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday 29 June 2011 10:33:32 you wrote:
> > I would like to propose the attached patch for de DVB-T configuration
> > file for Paris area (found in openSUSE 11.4 in this location)
> > /usr/share/dvb/dvb-t/fr-Paris
> 
> http://linuxtv.org/hg/dvb-apps/file/148ede2a6809/util/scan/dvb-t/fr-Paris
> - last change: november 2008.
> 
> Christoph

Just checked the file you updated 2 days ago. With the following command:

scan fr-Paris.new -o zap

In Versailles, where I live, only 5 channels are detected.

-- 
Bogdan
