Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:49257 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780Ab2JRQkm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Oct 2012 12:40:42 -0400
Received: by mail-gh0-f174.google.com with SMTP id g15so2455325ghb.19
        for <linux-media@vger.kernel.org>; Thu, 18 Oct 2012 09:40:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <507FE801.7040102@googlemail.com>
References: <507FE801.7040102@googlemail.com>
Date: Thu, 18 Oct 2012 18:40:41 +0200
Message-ID: <CAMyVd1oiDbfA6yGL-1ogHN1sEc11-=Vybr41TxMEF3OjRVHW_A@mail.gmail.com>
Subject: Re: [PATCH] Add Fujitsu Siemens Amilo Pi 2530 to gspca upside down table
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/10/18 Gregor Jasny <gjasny@googlemail.com>:
> Hello,
>
> I've got an webcam upside down report for the following system:
>
>     System Information
>             Manufacturer: FUJITSU SIEMENS
>             Product Name: AMILO Pi 2530
>             Version:
>             Serial Number:
>             UUID: <removed>
>             Wake-up Type: Power Switch
>             SKU Number: Not Specified
>             Family: Not Specified
>
>     Base Board Information
>             Manufacturer: FUJITSU SIEMENS
>             Product Name: F42
>             Version: 00030D0000000001
>             Serial Number: <removed>
>
> Currently an entry in the gspca/m5602 quirk table is missing. Please add the
> attached patch to the DVB kernel tree.
>
> Thanks,
> Gregor

Acked-by: Erik Andrén <erik.andren@gmail.com>
