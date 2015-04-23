Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:53366 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758255AbbDWWHv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 18:07:51 -0400
Message-ID: <55396D32.7010801@southpole.se>
Date: Fri, 24 Apr 2015 00:07:46 +0200
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 12/12] rtl2832: add support for GoTView MasterHD 3 USB
 tuner
References: <1429823471-21835-1-git-send-email-olli.salonen@iki.fi> <1429823471-21835-12-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1429823471-21835-12-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/23/2015 11:11 PM, Olli Salonen wrote:
> GoTView MasterHD 3 is a DVB-T2/C USB 2.0 tuner.
>
> It's based on the following components:
> - USB bridge: RTL2832P (contains also DVB-T demodulator)
> - Demodulator: Si2168-A30
> - Tuner: Si2148-A20
>
[...]
>
> For some reason, the old I2C write method sporadically failed. Thus the
> need for an option to only use the new I2C write method supported by the
> RTL2832.

Hi, I also experienced this with the Astrometa stick. I guess the 
new_i2c_write flag should be set on those devices also.

Do you plan on adding pid filter support also? I posted a non working 
rfc patch you could base it on.

MvH
Benjamin Larsson


