Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110602.mail.gq1.yahoo.com ([67.195.13.193]:35016 "HELO
	web110602.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752510Ab0ATPf5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 10:35:57 -0500
Message-ID: <928666.55792.qm@web110602.mail.gq1.yahoo.com>
References: <4B167A32.7000509@deckpoint.ch> <4B1E2243.2070306@waechter.wiz.at> <4B1E551C.6090307@deckpoint.ch> <4B1E6BD4.2060204@rbsworldpay.com> <4B1FC1F5.60109@deckpoint.ch> <4B2107A3.6010004@rbsworldpay.com>
Date: Wed, 20 Jan 2010 07:29:16 -0800 (PST)
From: Dominic Fernandes <dalf198@yahoo.com>
Subject: Re: TBS 6980 Dual DVB-S2 PCIe card
To: Ian Richardson <ian.richardson@rbsworldpay.com>,
	Thomas Kernen <tkernen@deckpoint.ch>
Cc: =?iso-8859-1?Q?Matthias_W=E4chter?= <matthias@waechter.wiz.at>,
	linux-media@vger.kernel.org
In-Reply-To: <4B2107A3.6010004@rbsworldpay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I just got a new card the TBS 8920 DVB-S2 PCI version.  And having problems with MythTV.
I'm running Mythbutu 9.10 with MythTV0.22 and the TBS supplied drivers.  I have generated a channels.conf file using scan and can view channels using mplayer dvb:// command.

Now I want to import my channels.conf into Mythtv, I gone through the steps of specfying the card in Mythtv backend setup, DiSEqC set to LNB, specified path and file to import channels.conf file /home/tv/channels.conf.  It then starts to do a Scan, but timesout and no channels are found.  I tried increasing the timeout values but I get the same result.  

Can you tell me if I'm missing a step?  or how you approached the scanning of channels in MythTV

Thanks,
Dominic





----- Original Message ----
From: Ian Richardson <ian.richardson@rbsworldpay.com>
To: Thomas Kernen <tkernen@deckpoint.ch>
Cc: Matthias Wächter <matthias@waechter.wiz.at>; linux-media@vger.kernel.org
Sent: Thu, December 10, 2009 2:37:23 PM
Subject: Re: TBS 6980 Dual DVB-S2 PCIe card

On 2009-12-09 15:27, Thomas Kernen wrote:
> Ian Richardson wrote:
>> On 2009-12-08 13:31, Thomas Kernen wrote:
>>> Matthias Wächter wrote:
>>>> Hallo Thomas!
>>>> 
>>>> Am 02.12.2009 15:31, schrieb Thomas Kernen:
>>>>> Is someone already working on supporting the TBS 6980 Dual DVB-S2 PCIe
>>>>> card? http://www.tbsdtv.com/english/product/6980.html

I can now confirm it works fine with MythTV 0.22 and at least their version of V4L. I tripped up on the known backend defect where you can't obviously select the DiSEqC config. See https://bugs.launchpad.net/mythtv/+bug/452894 for more info, and the workaround.

Thanks,

Ian

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



      
