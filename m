Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:50804 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbZDKMrN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Apr 2009 08:47:13 -0400
Received: by an-out-0708.google.com with SMTP id d14so1284155and.1
        for <linux-media@vger.kernel.org>; Sat, 11 Apr 2009 05:47:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a3ef07920904101559me72e8f7xa288b99bcc4a058@mail.gmail.com>
References: <621110570904100418r9d7e583j5ae4982a77e9dba9@mail.gmail.com>
	 <49DF9CB7.5080802@ewetel.net>
	 <621110570904101437g5843eb21h8a0c894cc9bb48d@mail.gmail.com>
	 <a3ef07920904101559me72e8f7xa288b99bcc4a058@mail.gmail.com>
Date: Sat, 11 Apr 2009 14:47:10 +0200
Message-ID: <621110570904110547v6b22ad5fv4db760816cb67338@mail.gmail.com>
Subject: Re: [linux-dvb] SkyStar HD2 (TwinHan VP-1041/Mantis) S2API support
From: Dave Lister <foceni@gmail.com>
To: VDR User <user.vdr@gmail.com>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/4/11 VDR User <user.vdr@gmail.com>:
> There is a new mantis tree being uploaded at:
> http://jusst.de/hg/mantis-v4l
>
> Please try this tree.  The upload should finish within 2 hours and is
> using DVB api 5 (aka s2api).
>
> Cheers
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

The compilation seemed perfect, but this appeared near the middle:

CC [M]  /n/data/src/mantis-v4l/v4l/hopper_cards.o
/n/data/src/mantis-v4l/v4l/hopper_cards.c:20:24: error: mantis_pci.h:
No such file or directory
/n/data/src/mantis-v4l/v4l/hopper_cards.c: In function 'hopper_pci_probe':
/n/data/src/mantis-v4l/v4l/hopper_cards.c:154: error: implicit
declaration of function 'mantis_pci_init'
/n/data/src/mantis-v4l/v4l/hopper_cards.c:214: error: implicit
declaration of function 'mantis_pci_exit'
/n/data/src/mantis-v4l/v4l/hopper_cards.c:200: warning: label 'fail5'
defined but not used
make[3]: *** [/n/data/src/mantis-v4l/v4l/hopper_cards.o] Error 1

There was no mantis_pci.[ch]. I copied these two files from the old
http://jusst.de/hg/mantis tree. Compilation OK, but then, after a bit
I got this:

CC [M]  ./mantis-v4l/v4l/mantis_ca.o
make[3]: *** No rule to make target
`./mantis-v4l/v4l/mantis_pcmcia.o', needed by
`./mantis-v4l/v4l/tda18271.o'.  Stop.
make[2]: *** [_module_./mantis-v4l/v4l] Error 2

Again, I copied mantis_pcmcia.c from the old tree and the compilation
finished. Later when I tried updating my copy, the files were there -
somebody fixed this as I was writing this mail, so I recompiled with
new files. :)

RESULTS (using "s2" dvb-apps):
- scanning DVB-S works
- scanning DVB-S2 doesn't work
- zapping DVB-S is fast

BUT there is a big problem now; even when I have FE_HAS_LOCK,
/dev/dvb/adapter0/dvr0 is dead; trying to read dvr0 blocks as if there
was no lock! Any suggestions? I'd really like to make this work - this
driver seems the best of both worlds! :)


-- 
David Lister
