Return-path: <linux-media-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:42715 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760293AbZAUSJo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jan 2009 13:09:44 -0500
Received: by nf-out-0910.google.com with SMTP id d3so582204nfc.21
        for <linux-media@vger.kernel.org>; Wed, 21 Jan 2009 10:09:42 -0800 (PST)
Subject: Re: [linux-dvb] SAA716x
From: Martin Pauly <madmufflon@googlemail.com>
To: linux-media@vger.kernel.org
In-Reply-To: <8103ad500901210243i5d6669desf0f336ac4d359b40@mail.gmail.com>
References: <496CB23D.6000606@libertysurf.fr> <496D7204.6030501@rogers.com>
	 <4976E3F5.3060703@libertysurf.fr>
	 <8103ad500901210243i5d6669desf0f336ac4d359b40@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 19:09:37 +0100
Message-Id: <1232561377.6908.2.camel@martin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, den 21.01.2009, 12:43 +0200 schrieb Konstantin Dimitrov:
> VP6090 output from lspci -vvv and lspci -vvvn is here:
> 
> http://www.interlink.com.au/rad/quattros/
> 
> On Wed, Jan 21, 2009 at 10:59 AM, Catimimi <catimimi@libertysurf.fr> wrote:
> > Hi all,
> >
> > I'm trying to add my Pinnacle 3010i to the driver found here :
> > http://jusst.de/hg/saa716x
> > I already got some preliminary results but in order to understand what
> > I'm doing it would be
> > great to get the result of "lspci -vvxxx" for at least one of the
> > supported cards :
> >
> > - Twinhan/Azurewave VP-6090
> > - Avermedia HC82
> > - Avermedia H788
> >
> > I didn't find this test in the WIKI, so thanks in advance for posting
> > this information.
> > Michel.
> >
> >
> >
> >
> >
> >
> > _______________________________________________
> > linux-dvb users mailing list
> > For V4L/DVB development, please use instead linux-media@vger.kernel.org
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
> 
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

hi,
unfortunately at last for me and some other guys the HC82 is not working
with the 716x driver. but you can find my lspci output at:
http://www.linuxtv.org/wiki/index.php/AVerMedia_AVerTV_Hybrid_NanoExpress_(HC82)
martin

