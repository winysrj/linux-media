Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:44461 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab3JOSwR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 14:52:17 -0400
Message-ID: <525D8ED2.7000609@gentoo.org>
Date: Tue, 15 Oct 2013 20:52:02 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: pierigno <pierigno@gmail.com>
CC: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	Ulf <mopp@gmx.net>
Subject: Re: Hauppauge HVR-900 HD and HVR 930C-HD with si2165
References: <trinity-fe3d0cd8-edad-4308-9911-95e49b1e82ea-1376739034050@3capp-gmx-bs54> <52426BB0.60809@gentoo.org> <52444AA3.8020205@iki.fi> <524A5EDF.8070904@gentoo.org> <524AE01E.9040300@iki.fi> <52530BC1.9010200@gentoo.org> <CAN7fRVvNExBoAbXxBM0bheB2mCRsZcdKTG-FFkN9AuNdJWBXLw@mail.gmail.com>
In-Reply-To: <CAN7fRVvNExBoAbXxBM0bheB2mCRsZcdKTG-FFkN9AuNdJWBXLw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07.10.2013 22:21, pierigno wrote:
> Hi Matthias,
>
> I went through a similar path in the past, using USBLyzer on a
> virtualized windows environment, and developed this simple awk script
> to adapt the csv output of USBLyzer to usbsnoop format. Hope it helps
> :)
>
Hi pierigno,
thank you.
Yes, your script worked as far as it is possible.
But it turned out, usblyzer does not write the setup packet information 
to csv nor to xml output.
And only seeing it in the gui is not helpful for a few thousand register 
writes.

Regards
Matthias

