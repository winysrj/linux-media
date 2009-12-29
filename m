Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:53312 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbZL2MWU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2009 07:22:20 -0500
Received: by iwn1 with SMTP id 1so7824458iwn.33
        for <linux-media@vger.kernel.org>; Tue, 29 Dec 2009 04:22:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B39DD6D.3030308@waechter.wiz.at>
References: <8cd7f1780912290138q1a58d3a5xa444a9cdcd577cfd@mail.gmail.com>
	 <4B39DD6D.3030308@waechter.wiz.at>
Date: Tue, 29 Dec 2009 20:22:19 +0800
Message-ID: <8cd7f1780912290422mc24d24el48f6b27fa8be0c53@mail.gmail.com>
Subject: Re: MANTIS / STB0899 / STB6100 card ( Twinhan VP-1041): problems
	locking to transponder
From: Leszek Koltunski <leszek@koltunski.pl>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A few specific questions:

1. Am I right thinking that 'dvbstream -c 1 -f 1190000 -s 27500 ...'
should just work? ( i.e. there's no additinal LNB / 22Khz / tone /
voltage magic to do? )
2. Assuming that I am right about the above, do you think it is
dvbstream, stb6100, stb0899 or mantis problem?
3. I can see that the stb0899 and stb6100 can be loaded with the
'verbose' parameter ( at least that's what modinfo says ) . I've tried
loading them with 'verbose=1' 'verbose=2' up to '4' but I can see no
additional debugging output in dmesg or kern.log. So how do I enable
debugging?
