Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59412 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab1HOKxa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2011 06:53:30 -0400
Received: by bke11 with SMTP id 11so2914359bke.19
        for <linux-media@vger.kernel.org>; Mon, 15 Aug 2011 03:53:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E42FD4F.8070904@crans.ens-cachan.fr>
References: <CAPpMX7Sw5bO8fiYq+u_Zdv8BBsS6qahQ0Rw+_CjD+ikXH5-w3g@mail.gmail.com>
	<4E42FD4F.8070904@crans.ens-cachan.fr>
Date: Mon, 15 Aug 2011 15:23:28 +0430
Message-ID: <CAPpMX7Rv3VF+NEr0PeSzS+VbiAU0SpNrvuDkLE9c_guvQgvjfA@mail.gmail.com>
Subject: Re: Structure of DiSEqC Command
From: Nima Mohammadi <nima.irt@gmail.com>
To: DUBOST Brice <dubost@crans.ens-cachan.fr>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 11, 2011 at 2:21 AM, DUBOST Brice
<dubost@crans.ens-cachan.fr> wrote:
> Hello
>
> I'm the upstream author of MuMuDVB (http://mumudvb.braice.net)
>
> The diseqc related code is here
> http://gitweb.braice.net/gitweb?p=mumudvb;a=blob;f=src/tune.c
>
> On the document
>
> http://www.eutelsat.com/satellites/pdf/Diseqc/associated%20docs/applic_info_LNB_switchers.pdf
>
> Page 7 (page 10 of the PDF) the band is the LSB and the table
> is organized in increasing binary data
>
> But in
> http://www.eutelsat.com/satellites/pdf/Diseqc/associated%20docs/update_recomm_for_implim.pdf
>
> page 33 (35 in the PDF)
>
> The LSB SEEMS to be the polarization, but it's still the band, the table
> is just organized in a strange way
>
> If you look deeply into the code of scan
>  http://www.linuxtv.org/hg/dvb-apps/file/36a084aace47/util/scan/diseqc.c
>
> You'll see that the table is organized as in the second document and the
> code addresses the table for making the message but there is no mistake
> in the real data since it's f0,f2,f1 etc ...
>
> So the difference is if the diseqc data is wrote directly (as in
> MuMuDVB) or taken from a table organised as in the specification (as in
> scan)
>
> Hope it's clear and it helps
>
> Regards
>
> --
> Brice
>

Thanks for the response. It really helped :)

-- Nima Mohammadi
