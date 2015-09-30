Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:33332 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933067AbbI3KEO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Sep 2015 06:04:14 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Cc: "kernel-mentors\@selenic.com" <kernel-mentors@selenic.com>,
	Linux Media <linux-media@vger.kernel.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, m.chehab@samsung.com
Subject: Re: H264 headers generation for driver
References: <CAM_ZknUEP73dQ2eEtVM_A_psAwcovKeiCDhpNgW+Fo96RRKM2w@mail.gmail.com>
Date: Wed, 30 Sep 2015 11:55:33 +0200
In-Reply-To: <CAM_ZknUEP73dQ2eEtVM_A_psAwcovKeiCDhpNgW+Fo96RRKM2w@mail.gmail.com>
	(Andrey Utkin's message of "Tue, 29 Sep 2015 21:59:51 +0300")
Message-ID: <m38u7oz0x6.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andrey Utkin <andrey.utkin@corp.bluecherry.net> writes:

[H.264 headers]
> I guess that one acceptable way is to pre-generate all headers for all
> needed cases and ship them inlined; for correctness checking purpose,
> it is possible to ship also a script or additional source code file
> which is able to generate same headers.

I think these are good ideas.
BTW the SOLO6110 at the moment also has pregenerated SPS/PPS headers
(whole NALs actually).
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
