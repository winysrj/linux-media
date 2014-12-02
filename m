Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:59459 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaLBLXC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Dec 2014 06:23:02 -0500
Received: by mail-oi0-f42.google.com with SMTP id v63so9012993oia.1
        for <linux-media@vger.kernel.org>; Tue, 02 Dec 2014 03:23:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141201105235.5cacf881@recife.lan>
References: <CA+QJwyh2OupTtNJ89TWgyBZm0dhaHQ2Ax1XPDPjaFat-aTKsCA@mail.gmail.com>
	<20141201072028.6466a2b3@recife.lan>
	<CA+QJwyh-3YL1UCR7Q1d3jy8z49YM2yqNp_WmiD3zXLRzEuC-Uw@mail.gmail.com>
	<20141201105235.5cacf881@recife.lan>
Date: Tue, 2 Dec 2014 12:23:01 +0100
Message-ID: <CA+QJwygCJgPkFhAWzKKRD0Y-MMazByGf4R1_HJ+S3gTWhjp+HQ@mail.gmail.com>
Subject: Re: Kernel 3.17.0 broke xc4000-based DTV1800h
From: =?UTF-8?B?SXN0dsOhbiwgVmFyZ2E=?= <istvan_v@mailbox.hu>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2014-12-01 13:52 GMT+01:00 Mauro Carvalho Chehab <mchehab@osg.samsung.com>:
> Em Mon, 01 Dec 2014 13:24:50 +0100
> "István, Varga" <istvan_v@mailbox.hu> escreveu:
>> I am not sure if those are responsible for the
>> I2C errors, or
>> simply the lack of the analog firmwares. Perhaps the latter if the errors do not
>> occur with the (currently DVB-only) PCTV 340e.
>
> Maybe.

The driver searches for the firmware image that matches the selected analog TV
standard the best, and if the firmware file does not include any, then
it currently
attempts to load whatever else is found (for example, the base firmware).
This problem should perhaps be fixed, although the ideal solution is
to provide a
complete firmware file.
