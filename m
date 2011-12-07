Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42689 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758473Ab1LGVyh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 16:54:37 -0500
Received: by qcqz2 with SMTP id z2so844499qcq.19
        for <linux-media@vger.kernel.org>; Wed, 07 Dec 2011 13:54:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EDFB746.8010309@redhat.com>
References: <4EDE27A0.8060406@gmail.com>
	<4EDF6640.801@redhat.com>
	<4EDF6E7E.30200@gmail.com>
	<4EDF762A.9030604@redhat.com>
	<4EDF7DF3.1080007@gmail.com>
	<4EDF80AF.5060709@redhat.com>
	<4EDF8A22.6020201@gmail.com>
	<4EDF8B68.1040009@gmail.com>
	<4EDF9291.2030703@redhat.com>
	<4EDFA19E.7090608@gmail.com>
	<4EDFB746.8010309@redhat.com>
Date: Wed, 7 Dec 2011 22:54:37 +0100
Message-ID: <CAL7owaDDDUx=rAw+7YRLVvw8LF6WWLhtoXOaXy-hGXJD8TWDTQ@mail.gmail.com>
Subject: Re: [PATCH 0/1] xc3028: force reload of DTV7 firmware in VHF band
 with Zarlink demodulator
From: Christoph Pfister <christophpfister@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: gennarone@gmail.com, linux-media list <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/12/7 Mauro Carvalho Chehab <mchehab@redhat.com>:
<snip>
> Several channels in Italy are marked as if they are using 8MHz for VHF (the
> auto-Italy is
> the most weird one, as it defines all VHF frequencies with both 7MHz and
> 8MHz).

Well, auto-Italy is a superset of the it-* files. For example "T
177500000 7MHz" exists in some files (Modena, Montevergina) and "T
177500000 8MHz" in others (Sassari), so both possibilities have to
appear in auto-Italy (similar for other VHF frequencies, it simply
doesn't seem to be regulated). There's nothing to fix there,
auto-Italy exists exactly because of these irregularities.

<snip>

Christoph
