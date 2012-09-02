Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53840 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab2IBUIe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Sep 2012 16:08:34 -0400
Received: by ieje11 with SMTP id e11so2961117iej.19
        for <linux-media@vger.kernel.org>; Sun, 02 Sep 2012 13:08:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5043943E.2090802@googlemail.com>
References: <5043943E.2090802@googlemail.com>
Date: Sun, 2 Sep 2012 17:08:33 -0300
Message-ID: <CALF0-+UqPu3Pw74XCtFwfZHOp_WS775y77xmEXisnbx8pzG2ew@mail.gmail.com>
Subject: Re: gspca_pac7302 driver broken ?
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org, moinejf@free.fr, hdegoede@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Frank,

On Sun, Sep 2, 2012 at 2:15 PM, Frank Schäfer
<fschaefer.oss@googlemail.com> wrote:
> Hi,
>
> can anyone who owns such a device confirm that the gspca_pac7302 driver
> (kernel 3.6.0-rc1+) is fine ?
>

It's working here with latest media-tree kernel.

Driver Info:
	Driver name   : gspca_pac7302
	Card type     : USB Camera (093a:2625)
	Bus info      : usb-0000:00:12.0-1
	Driver version: 3.6.0
	Capabilities  : 0x85000001
		Video Capture
		Read/Write
		Streaming
		Device Capabilities
	Device Caps   : 0x05000001
		Video Capture
		Read/Write
		Streaming

Hope this helps,
Ezequiel.
