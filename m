Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:20601 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaJaTx6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 15:53:58 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NEB00KFGR9XWH20@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 Oct 2014 15:53:57 -0400 (EDT)
Date: Fri, 31 Oct 2014 17:53:53 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Akihiro TSUKADA <tskd08@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 3/7] v4l-utils/libdvbv5: add support for ISDB-S scanning
Message-id: <20141031175353.4b1dec17.m.chehab@samsung.com>
In-reply-to: <54539EC6.8090001@gmail.com>
References: <1414323983-15996-1-git-send-email-tskd08@gmail.com>
 <1414323983-15996-4-git-send-email-tskd08@gmail.com>
 <20141027124650.522d394b.m.chehab@samsung.com> <54539EC6.8090001@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 31 Oct 2014 23:37:58 +0900
Akihiro TSUKADA <tskd08@gmail.com> escreveu:

> On 2014年10月27日 23:46, Mauro Carvalho Chehab wrote:
> 
> > Always right circular polarization? I guess I read something at the specs
> > sometime ago about left polarization too. Not sure if this is actually used.
> 
> Currently all transponders of ISDB-S use right polarization.
> but I modifed this part and removed POLARIZATION prop from ISDB-S in v3.

Hmm... Is this due to a spec definition, or is it just how satellite
operators decided?

If ARIB spec doesn't allow polarization set, we should remove it from the
Kernel DocBook. 

Btw, how does the PT1 driver handle those parameters? If it just uses
frequency (it seems so), then the only valid parameters for ISDB-S are
	DTV_FREQUENCY
and
	DTV_STREAM_ID

(and, eventually, polarization, if ARIB spec allows it)

right?

Could you please send us a patch fixing it at the Kernel DocBook:
	Documentation/DocBook/media/dvb/dvbproperty.xml

Thanks!
Mauro
