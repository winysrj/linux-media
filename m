Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:44260 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbZJTEEb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 00:04:31 -0400
Received: by fxm18 with SMTP id 18so5935820fxm.37
        for <linux-media@vger.kernel.org>; Mon, 19 Oct 2009 21:04:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4ADD3341.3050202@yahoo.co.jp>
References: <340263.68846.qm@web25604.mail.ukl.yahoo.com>
	 <4ADD3341.3050202@yahoo.co.jp>
Date: Tue, 20 Oct 2009 06:04:34 +0200
Message-ID: <d9def9db0910192104q7bb6b46fi4782456274350b98@mail.gmail.com>
Subject: Re: ISDB-T tuner
From: Markus Rechberger <mrechberger@gmail.com>
To: Akihiro TSUKADA <tskd2@yahoo.co.jp>
Cc: Romont Sylvain <psgman24@yahoo.fr>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 20, 2009 at 5:49 AM, Akihiro TSUKADA <tskd2@yahoo.co.jp> wrote:
>> My tuner card is a Pixela PIXDT090-PE0
>
> Hi Romont,
>
> As you might know, all Japanese DTV programs are scrambled with BCAS.
> BCAS scrambling algorithm itself is opend in the standard,
> but in addition to that, PC devices have to encrypt received data
> locally in order to get authorized for BCAS.
> So most DTV devices sold in Japan cannot be used in Linux.
>
> Some self-started vendors have sold their devices without BCAS
> authentication (thus without local encryption).
> They don't/can't include a BCAS PC-card necessary for descrambling,
> and users must bring it from elsewhere, which is against the EULA
> with the exclusive and private card issuer organization,
> or just live with qcif-sized non scrambled 'one seg.' programs in TS.
>
> This is why so few ISDB-T/S devices are supported in Linux.
> And Pixela is one of the major vendors with BCAS authentication.
> So I'm afraid there is almost no possibility to be supported in Linux.
>
> And just  for you information, in addition to EarthSoft PT1,
> there is a driver for 'Friio' ISDB-T USB receiver (which I wrote;) ,
> and it is already included in the main repository.
> Dibcom is maybe for Brazil and may or may not work in Japan.
> (Some of the SKnet HDUS series USB receivers are known to be
>  hack-able to avoid local encryption, but of course it's underground.)

We are able to handle this legally already. The decryption is directly
implemented into our driver. The driver runs entirely in Userspace and
does not need
any additional kernel modules, our current devices are based on Empia ICs.

The installation is exactly the same as for our ATSC/DVB-T/DVB-C/ATV
Hybrid devices
http://support.sundtek.de/index.php/topic,4.0.html

Another topic are Applications which can handle MPEG4/AAC properly,
1Seg also requires
a dedicated player since none of the available players can handle it correctly.

I'm just adding this so people can get an idea what's currently going
on in the Linux
area for ISDB-T. Everyone's free to make his own decision about buying
devices in
the end.

Best Regards,
Markus Rechberger
