Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:63012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733Ab1FDK1x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Jun 2011 06:27:53 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p54ARrWc001865
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 4 Jun 2011 06:27:53 -0400
Received: from [10.11.10.29] (vpn-10-29.rdu.redhat.com [10.11.10.29])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p54ARq7I029896
	for <linux-media@vger.kernel.org>; Sat, 4 Jun 2011 06:27:52 -0400
Message-ID: <4DEA08A7.2090509@redhat.com>
Date: Sat, 04 Jun 2011 07:27:51 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Fwd: XC4000: code cleanup
References: <4DE8DD94.5040609@redhat.com>
In-Reply-To: <4DE8DD94.5040609@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 03-06-2011 10:11, Mauro Carvalho Chehab escreveu:
> 
> 
> -------- Mensagem original --------
> Assunto: XC4000: code cleanup
> Data: Fri, 03 Jun 2011 12:02:15 +0200
> De: istvan_v@mailbox.hu <istvan_v@mailbox.hu>
> Para: Devin Heitmueller <dheitmueller@kernellabs.com>
> CC: Dmitri Belimov <d.belimov@gmail.com>,        Mauro Carvalho Chehab <mchehab@redhat.com>, thunder.m@email.cz,        linux-dvb@linuxtv.org
> 
> This is the first of a set of patches that update the original xc4000
> sources to my modified version. It removes some unused code, and makes
> a few minor formatting changes.
> 
> Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>
> 

This patch broke compilation:

drivers/media/common/tuners/xc4000.c: In function ‘xc_tune_channel’:
drivers/media/common/tuners/xc4000.c:497: error: ‘XC_TUNE_ANALOG’ undeclared (first use in this function)
drivers/media/common/tuners/xc4000.c:497: error: (Each undeclared identifier is reported only once
drivers/media/common/tuners/xc4000.c:497: error: for each function it appears in.)
drivers/media/common/tuners/xc4000.c: In function ‘xc4000_set_params’:
drivers/media/common/tuners/xc4000.c:1232: error: ‘XC_TUNE_DIGITAL’ undeclared (first use in this function)
drivers/media/common/tuners/xc4000.c: In function ‘xc4000_set_analog_params’:
drivers/media/common/tuners/xc4000.c:1323: error: ‘XC_TUNE_ANALOG’ undeclared (first use in this function)
make[3]: ** [drivers/media/common/tuners/xc4000.o] Erro 1

I've re-added XC_TUNE_ANALOG/XC_TUNE_DIGITAL defines to it.

Cheers,
Mauro
