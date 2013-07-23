Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:40914 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933768Ab3GWVHB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 17:07:01 -0400
Message-ID: <51EEEFCA.9040107@schinagl.nl>
Date: Tue, 23 Jul 2013 23:04:10 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Krishna Kishore <krishna.kishore@sasken.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Prof DVB-S2 USB device
References: <bd6fa917-9510-49e2-b4ff-b280fedb320a@exgedgfz01.sasken.com>
In-Reply-To: <bd6fa917-9510-49e2-b4ff-b280fedb320a@exgedgfz01.sasken.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23-07-13 18:52, Krishna Kishore wrote:
> #Sorry for sending to individual email ids
>
> Hi,
>
>       I am trying to use Prof DVB-S2 USB device with Linux host. Device gets detected. But, I am facing the following problems.
You will need to provide much more information then that. What does 
dmesg say? lsusb? what driver are you using, what kernel version? Are 
you using it as a module? Have you enabled debugging in your kernel?

Those questions come to my mind.

>
> 1.      It takes approximately 21 minutes to get /dev/dvb/adapter0/frontend0 and /dev/dvb/adapter0/demux0 to get created. This happens every time
> 2.      After /dev/dvb/adapter0/frontend0 gets created, when I use w_scan utility to scan for channels, it does not list the channels.
> a.      In dmesg logs, I see DEMOD LOCK FAIL error continuously.
Paste your logs (or if its too much, only copy/paste the relevant parts. 
You ask for a limb, yet offer nothing.

oliver
>
>        Can you please help me?
>
>
> Regards,
> Kishore.
>
>
>
> ________________________________
>
> SASKEN BUSINESS DISCLAIMER: This message may contain confidential, proprietary or legally privileged information. In case you are not the original intended Recipient of the message, you must not, directly or indirectly, use, disclose, distribute, print, or copy any part of this message and you are requested to delete it and inform the sender. Any views expressed in this message are those of the individual sender unless otherwise stated. Nothing contained in this message shall be construed as an offer or acceptance of any offer by Sasken Communication Technologies Limited ("Sasken") unless sent with that express intent and with due authority of Sasken. Sasken has taken enough precautions to prevent the spread of viruses. However the company accepts no liability for any damage caused by any virus transmitted by this email.
> Read Disclaimer at http://www.sasken.com/extras/mail_disclaimer.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

