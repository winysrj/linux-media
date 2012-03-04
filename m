Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:43958 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab2CDNlb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Mar 2012 08:41:31 -0500
MIME-Version: 1.0
Date: Sun, 4 Mar 2012 19:11:30 +0530
Message-ID: <CAOD=uF4+UZ7Lr=RkvV-zpy4wOSCCM+RXDBHeqUf60fOzYH9EFw@mail.gmail.com>
Subject: [media] dvb: Buffer Overfolow in cx24110_set_fec
From: santosh prasad nayak <santoshprasadnayak@gmail.com>
To: mchehab@infradead.org
Cc: lucas.demarchi@profusion.mobi, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am getting following error:

"drivers/media/dvb/frontends/cx24110.c:210 cx24110_set_fec() error:
buffer overflow 'rate' 7 <= 8"

 In cx24110_set_fec, arrays " rate[] , g1[], g2[]"  have only 7 values.


typedef enum fe_code_rate {
        ........
        FEC_6_7,   // index 7
        FEC_7_8,   // index 8
        FEC_8_9,
        FEC_AUTO,
         .....
          ....
} fe_code_rate_t;


For     "FEC_6_7 <  fec  <  FEC_AUTO"  , rate[fec]. g1[fec], g2[fec]
values are not defined initially.
Is it expected or bug ?


regards
Santosh
