Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:36671 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbbJTJBy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2015 05:01:54 -0400
Received: by lbcao8 with SMTP id ao8so10044698lbc.3
        for <linux-media@vger.kernel.org>; Tue, 20 Oct 2015 02:01:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <562576E1.6070400@cogweb.net>
References: <562576E1.6070400@cogweb.net>
From: Michael Stilmant <stilmant.michael.rovi@gmail.com>
Date: Tue, 20 Oct 2015 11:01:32 +0200
Message-ID: <CABXgeUEdXMvkPQXyV6uf3Zeh024VN3RTMnWOdEib9zhxxSX8yw@mail.gmail.com>
Subject: Re: Brazilian television capture device
To: David Liontooth <lionteeth@cogweb.net>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, David

I'm in the same process that you are. I'm also on remote (Europe) but
I have some laptop in Brazil where I can do some test using remote
shell. I don't talk Brazilian/Portuguese so it is also hard to find
Local Linux groups certainly discussing about it

I have also that reference.
http://www.isdb-t.com/usb-isdb-t-full-seg-digital-usb-tv-stick-use-for-pc-philippines-japan-chile-vcan1012/
  I don't know neither if this could be working.  Not yet purchased

My contact purchased
http://www.netserv19.com/ecommerce_site/produto_103630_1598_Visus-Tv-Radicale-Receptor-Tv-Digital-Fullhd-Alta-Definicao-FULL-SEG
I will need to test it coming days
but dvbsnoop -s feinfo allready return:

Device: /dev/dvb/adapter0/frontend0

Basic capabilities:
    Name: "DiBcom 8000 ISDB-T"
    Frontend-type:       OFDM (DVB-T)
    Frequency (min):     45000.000 kHz
    Frequency (max):     860000.000 kHz
    Frequency stepsiz:   62.500 kHz
    Frequency tolerance: 0.000 kHz


Which is not a bad sign.

Please share you finding, it would be appreciated.

Regards,

Michael




On Tue, Oct 20, 2015 at 1:04 AM, David Liontooth <lionteeth@cogweb.net> wrote:
>
> Does anyone know of a tv capture device for Brazil (ISDB-T) that is
> supported in Linux and available for sale?
>
> I'm having a hard time finding any of the devices listed under
> http://www.linuxtv.org/wiki/index.php/ISDB-T_USB_Devices or ISDB-T PCIe
> devices --
>
> * Pixelview SBTVD
> (http://www.kabum.com.br/produto/6784/receptor-de-tv-digital-pixelview-playtv-usb-2-0-sbtvd-full-seg-pv-d231urn-f)
> is out of stock
> * Geniatech/MyGica X8507 PCI-Express Hybrid Card
> (http://www.linuxtv.org/wiki/index.php/Geniatech/MyGica_X8507_PCI-Express_Hybrid_Card)
>
> I see the Aver3d Hybrid Volar Xpro (H869 --
> http://avertv.avermedia.com/avertv/Upload/ProductImages/DS_H869_EN_140415.pdf)
> at americanas.com
> (http://www.americanas.com.br/produto/9869979/placa-captura-de-tv-aver3d-hybrid-volar-xpro)
> -- is it supported?
>
> I'm advising friends remotely, so I can't just purchase it and try it out.
>
> Cheers,
> Dave
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
