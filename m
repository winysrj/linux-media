Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:35574 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754027Ab2EIR5Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2012 13:57:24 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: Re: Dazzle DVC80 under FC16
Date: Wed, 9 May 2012 19:56:59 +0200
Cc: Bruno Martins <lists@skorzen.net>, linux-media@vger.kernel.org
References: <4FAA57A3.2030701@skorzen.net> <4FAA9942.5050703@skorzen.net> <CALF0-+V7NW737+_AHdXF=DhOEpXMy+LBZRgrX+n0kjrTwMuXpA@mail.gmail.com>
In-Reply-To: <CALF0-+V7NW737+_AHdXF=DhOEpXMy+LBZRgrX+n0kjrTwMuXpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201205091957.02370.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 09 May 2012 18:54:58 Ezequiel Garcia wrote:
> Hi,
>
> Also please output lsmod with your device plugged and the list of your
> installed modules (do you know how to do this?)
>
> I may be wrong, but this device should be supported by usbvision module.

The log show that usbvision module is loaded but fails to set altsetting to 1. 
Probably because the device has two interfaces (note that the driver is also 
initialized twice).

-- 
Ondrej Zary
