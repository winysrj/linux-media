Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:52378 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377AbZEVRfO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 13:35:14 -0400
Received: by bwz22 with SMTP id 22so1766922bwz.37
        for <linux-media@vger.kernel.org>; Fri, 22 May 2009 10:35:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <72748420-1243012937-cardhu_decombobulator_blackberry.rim.net-428520223-@bxe1214.bisx.prod.on.blackberry>
References: <72748420-1243012937-cardhu_decombobulator_blackberry.rim.net-428520223-@bxe1214.bisx.prod.on.blackberry>
Date: Fri, 22 May 2009 21:35:14 +0400
Message-ID: <1a297b360905221035ra3ddfe3vb3be4d2029865a39@mail.gmail.com>
Subject: Re: [linux-dvb] Most stable DVB-S2 PCI Card?
From: Manu Abraham <abraham.manu@gmail.com>
To: linux-media@vger.kernel.org, bobi@brin.com
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 22, 2009 at 9:23 PM, Bob Ingraham <bobi@brin.com> wrote:
> Hello,
>
> What is the most stable DVB-S2 PCI card?
>
> I've read through the wiki DVB-2 PCI section, but am not confident after reading this what the answer is.
>
> Running Fedora Core 10 at the moment, but am willing to upgrade to 11 or perform custom patches to get something going.
>
> No need for CI or DiSEQ support, just highly stable/reliable DVB-2 tuning/reception under Linux.
>
> Any recommendations would be most appreciated!
>


If you don't need the CI part, The TT S2-1600 is a 2nd generation DVB-S2 PCI
card with great performance (supports Symbol rates upto 60MSPS), with support
out of the box from the v4l-dvb tree.

Regards,
Manu
