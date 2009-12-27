Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:48621 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbZL0NP6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Dec 2009 08:15:58 -0500
Received: by fxm25 with SMTP id 25so4070064fxm.21
        for <linux-media@vger.kernel.org>; Sun, 27 Dec 2009 05:15:56 -0800 (PST)
Date: Sun, 27 Dec 2009 15:15:29 +0200
From: Dan Carpenter <error27@gmail.com>
To: linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: weird array index in zl10036.c
Message-ID: <20091227131529.GJ6075@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb/frontends/zl10036.c
   397          /* could also be one block from reg 2 to 13 and additional 10/11 */
   398          u8 zl10036_init_tab[][2] = {
   399                  { 0x04, 0x00 },         /*   2/3: div=0x400 - arbitrary value */
   400                  { 0x8b, _RDIV_REG },    /*   4/5: rfg=0 ba=1 bg=1 len=? */
   401                                          /*        p0=0 c=0 r=_RDIV_REG */
   402                  { 0xc0, 0x20 },         /*   6/7: rsd=0 bf=0x10 */
   403                  { 0xd3, 0x40 },         /*   8/9: from datasheet */
   404                  { 0xe3, 0x5b },         /* 10/11: lock window level */
   405                  { 0xf0, 0x28 },         /* 12/13: br=0xa clr=0 tl=0*/
   406                  { 0xe3, 0xf9 },         /* 10/11: unlock window level */
   407          };
   408
   409          /* invalid values to trigger writing */
   410          state->br = 0xff;
   411          state->bf = 0xff;
   412
   413          if (!state->config->rf_loop_enable)
   414                  zl10036_init_tab[1][2] |= 0x01;
 
This seems like an off by one error.  I think it maybe should say
zl10036_init_tab[1][1] |= 0x01;?

regards,
dan carpenter
