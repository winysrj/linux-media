Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:50510 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520Ab2CET7s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2012 14:59:48 -0500
Received: by dadp12 with SMTP id p12so5537984dad.11
        for <linux-media@vger.kernel.org>; Mon, 05 Mar 2012 11:59:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOD=uF4+UZ7Lr=RkvV-zpy4wOSCCM+RXDBHeqUf60fOzYH9EFw@mail.gmail.com>
References: <CAOD=uF4+UZ7Lr=RkvV-zpy4wOSCCM+RXDBHeqUf60fOzYH9EFw@mail.gmail.com>
Date: Tue, 6 Mar 2012 01:29:47 +0530
Message-ID: <CAOD=uF6MPenj7z1_DOJ-3-dNBcvNhomw-g1CN07-zKOTab1eJg@mail.gmail.com>
Subject: Re: [media] dvb: Buffer Overfolow in cx24110_set_fec
From: santosh prasad nayak <santoshprasadnayak@gmail.com>
To: mchehab@infradead.org
Cc: lucas.demarchi@profusion.mobi, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Can anyone comment on it ?

Is  "FEC_AUTO" should be moved up as shown below ?

 typedef enum fe_code_rate {
        ........
        FEC_6_7,
                      ,    // Should "FEC_AUTO,"  be placed here ?
        FEC_7_8,
        FEC_8_9,
                      ,   // At present FEC_AUTO is here
         .....
          ....
 } fe_code_rate_t;


     OR

 Should   rate[fec],  g1[fec],and  g2[fec]  be initialized for
"FEC_6_7 <  fec  <  FEC_AUTO"  ??
  If yes, what should be the initial values ?


Regards
Santosh





On Sun, Mar 4, 2012 at 7:11 PM, santosh prasad nayak
<santoshprasadnayak@gmail.com> wrote:
> Hi,
>
> I am getting following error:
>
> "drivers/media/dvb/frontends/cx24110.c:210 cx24110_set_fec() error:
> buffer overflow 'rate' 7 <= 8"
>
>  In cx24110_set_fec, arrays " rate[] , g1[], g2[]"  have only 7 values.
>
>
> typedef enum fe_code_rate {
>        ........
>        FEC_6_7,   // index 7
>        FEC_7_8,   // index 8
>        FEC_8_9,
>        FEC_AUTO,
>         .....
>          ....
> } fe_code_rate_t;
>
>
> For     "FEC_6_7 <  fec  <  FEC_AUTO"  , rate[fec]. g1[fec], g2[fec]
> values are not defined initially.
> Is it expected or bug ?
>
>
> regards
> Santosh
