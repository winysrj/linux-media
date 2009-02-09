Return-path: <linux-media-owner@vger.kernel.org>
Received: from 246-113.netfront.net ([202.81.246.113]:43353 "EHLO akbkhome.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296AbZBIOKh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Feb 2009 09:10:37 -0500
Message-ID: <49902EBC.8020500@akbkhome.com>
Date: Mon, 09 Feb 2009 21:25:16 +0800
From: Alan Knowles <mailinglist@akbkhome.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dib0700 "buggy sfn workaround" or equivalent
References: <e021c7c00902090411j4df14a69me568a6022a5bc4d2@mail.gmail.com> <e021c7c00902090413l12af9229t8a4db36f7c4ce160@mail.gmail.com>
In-Reply-To: <e021c7c00902090413l12af9229t8a4db36f7c4ce160@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Not sure if it's the same issue, but we had the similar problem with the 
ASUS 3100 mycinema DVB-TH card

killing off this function appeared to fix it..

int dvb_usb_remote_init(struct dvb_usb_device *d)
{
        struct input_dev *input_dev;
	return 0;
}

Regards
Alan

Brett wrote:
> Hello,
>
> I have a dvb_usb_dib0700 (Nova 500 dual) card and it shows similar
> issues to the dvb_usb_dib3000mc card, ie:
>
> "This card has an issue (which particularly manifests itself in
> Australia where a bandwidth of 7MHz is used) with jittery reception -
> artifacts and choppy sound throughout recordings despite having full
> signal strength. Australian users will typically see this behaviour on
> SBS and ABC channels"
>
> The fix for the dib3000mc is to enable the 'buggy sfn workaround' but
> there is no such option for the dib 0700 :
>
> The buggy sfn workaround workaround does "dib7000p_write_word(state,
> 166, 0x4000);" if it is active, or "dib7000p_write_word(state, 166,
> 0x0000)" if it inactive, in the dib3000mc driver. I presume this
> tweaks a bandwidth filter or something similar for the dib3000mc, is
> there  such an equivalent feature for the dib0700 chipset ?
>
> Does anybody have specs on the dib0700 that describes registers, or
> how to set tuner bandwidth etc., during tuning ?
>
> Cheers
> Brett
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   

