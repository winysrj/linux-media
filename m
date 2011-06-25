Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:60294 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751930Ab1FYAiU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2011 20:38:20 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: Linux Media Mailing List <linux-media@vger.kernel.org>
To: Simon Liddicott <simon@liddicott.com>
Subject: Re: [DVB] Octopus driver status
Date: Sat, 25 Jun 2011 02:37:58 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?iso-8859-15?q?S=E9bastien_RAILLARD?= (COEXSI) <sr@coexsi.fr>
References: <017201cc31ec$de287ce0$9a7976a0$@coexsi.fr> <4E047B9C.1010308@redhat.com> <BANLkTinzBGMxwd7AmxPhG3Q1pCx0EsUxvA@mail.gmail.com>
In-Reply-To: <BANLkTinzBGMxwd7AmxPhG3Q1pCx0EsUxvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201106250237.59401@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday 24 June 2011 14:44:50 Simon Liddicott wrote:
> Do you have a Terratec Cinergy 2400i? It belongs to the ngene family but has
> PLL tuners. http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_2400i_DVB-T
> 
> There are some drivers floating on the net that I have got to work in Ubuntu
> 8.04 but the current ngene drivers has moved on a long way and left it
> behind.

Sorry, I do not have this device, and I have no plans to work on it.
Terratec did not contribute in any way to the ngene driver. [1]

As always, patches are welcome.

CU
Oliver

[1] Some time ago I had a look at that driver, and found that it could
    not be added to the kernel, due to an GPL-incompatible proprietary
    license for some files.

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
