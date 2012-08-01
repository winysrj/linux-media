Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:36844 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754227Ab2HAOUY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2012 10:20:24 -0400
Message-ID: <50193B24.8070700@gmx.de>
Date: Wed, 01 Aug 2012 16:20:20 +0200
From: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: set default protocol for  TerraTec Cinergy XXS  to "nec"
References: <50047814.20701@gmx.de> <5016B29F.4080605@redhat.com>
In-Reply-To: <5016B29F.4080605@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/30/2012 06:13 PM, Mauro Carvalho Chehab wrote:
> Em 16-07-2012 17:22, Toralf Förster escreveu:
>> /me wonders whether "nec" should be set as the default for this key in kernel or not
> 
> It makes sense to patch it to use the nec protocol. If not all keys are working, it also makes
> sense to fix the kernel table to handle all codes, or to point to a new table where all
> Terratec keys are defined.

With this command :

$> ir-keytable --protocol=nec --sysdev=`ir-keytable 2>&1 | head -n 1 | cut -f5 -d'/'` -w /etc/rc_keymaps/dib0700_nec 

I get it to working.


FWIW it is the USB_PID_TERRATEC_CINERGY_T_XXS_2 (ID 0ccd:00ab TerraTec Electronic GmbH) id.


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
