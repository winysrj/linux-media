Return-path: <linux-media-owner@vger.kernel.org>
Received: from thor.websupport.sk ([195.210.28.15]:23347 "EHLO
	thor.websupport.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab2AWN6d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 08:58:33 -0500
Message-ID: <4F1D6793.8090605@maindata.sk>
Date: Mon, 23 Jan 2012 14:58:43 +0100
From: Marek Ochaba <ochaba@maindata.sk>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Christian_Pr=E4hauser?= <cpraehaus@cosy.sbg.ac.at>
CC: linux-media@vger.kernel.org,
	Konstantin Dimitrov <kosio.dimitrov@gmail.com>,
	"statelov@maindata.sk" <statelov@maindata.sk>
Subject: Re: DVB-S2 multistream support
References: <loom.20111227T105753-96@post.gmane.org> <4F181BCD.5080008@maindata.sk> <FD47BCF3-7867-4296-A3CB-FB31DA6021E0@cosy.sbg.ac.at>
In-Reply-To: <FD47BCF3-7867-4296-A3CB-FB31DA6021E0@cosy.sbg.ac.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Christian & Konstantin,
we look forward for your patch. Here are some hints, what we want to do.

Now we read TS packets from standard userspace API (/dev/dvb/adapter0/dvr0,
for video data processing) or use libdvbapi/dvbnet.h (for IP over DVB data,
MPE decapsulation). In future we want to receive ACM/GSE data. So we plan
to read whole BBFrame data and decapsulate it. But if there will be GSE
decapsulation in linuxtv.org kernel layer, then we don't need whole BBFrame.

It would be nice to have acces to some usefull data from BBF headers
particularly: TS/GS field, SIS/MIS flag, CCM/ACM flag, it should be
statical value throught several BBF. Other usefull data which is diffrent
from more BBF is Imput stream ID (ISI). Can it be accesible as list of
received values ?
This values could be accessible throught standard S2API sytem call
ioctl(FE_GET_PROPERTY, struct dtv_property)
or if whole BBFrame/BBFheader will be accessible, we can read it ourself
from BBF header.

BTW: We have GPL source code for GSE decapsulation from Karsten Siebert. If
you don't have implement yet, this one can be used, it is in "kernel space"
compatible format.

--
Marek Ochaba
