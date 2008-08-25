Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx00.csee.securepod.com ([66.232.128.196]
	helo=cseeapp00.csee.securepod.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <roger@beardandsandals.co.uk>) id 1KXfDU-0006aL-V6
	for linux-dvb@linuxtv.org; Mon, 25 Aug 2008 18:46:58 +0200
Received: from [192.168.10.241] (unknown [81.168.109.249])
	by smtp00.csee.securepod.com (Postfix) with ESMTP id AAD3D22C649
	for <linux-dvb@linuxtv.org>; Mon, 25 Aug 2008 17:46:19 +0100 (BST)
Message-ID: <48B2E1DC.2080605@beardandsandals.co.uk>
Date: Mon, 25 Aug 2008 17:46:20 +0100
From: Roger James <roger@beardandsandals.co.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <20080825122741.GB17421@optima.lan>
In-Reply-To: <20080825122741.GB17421@optima.lan>
Subject: Re: [linux-dvb] TT S2-3200 + CI Extension
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Martin Hurton wrote:
> Hi List,
>
> I have the TT-budget S2-3200 card with CI Extension and have problem
> to get it work with my CAM module. I have tried different CI Extensions,
> different CI cables, different CAM modules, and also different computers 
> but still without any success. I am using multiproto driver.
>
> Debugging the driver I have found the problem is in the following code:
> (budget-ci.c).
>
> 507     ci_version = ttpci_budget_debiread(&budget_ci->budget, DEBICICTL, DEBIADDR_CIVERSION, 1, 1, 0);
> 508     if ((ci_version & 0xa0) != 0xa0) {
> 509             result = -ENODEV;
> 510             goto error;
> 511     }
>
> it seems the driver expects the high nibble of ci_version to be 0xa but in my case,
> the ci_version is always zero. And because of this, the CA is not supported.
>
> Did anybody have this same problem? Or can somebody explains why this happens?
> Any help will be greatly appreciated.
>
>
>   
Martin,

I am investigating a simillar (but not the same) problem with a TT-3200
and a T-Rex/Dragon CAM (see my postings in the last week). I am
beginning to come to the conclusion that either I have a hardware
problem or the TT-3200 does not like certain CAMs, this is partially
born out by the fact the some incompatible cams are listed on the wiki
http://www.linuxtv.org/wiki/index.php/DVB_Conditional_Access_Modules . I
don't know whether this is a hardware or software (or both)
incompatibility. If it software it could be fixable. Does anyone know?

I did come across a post, which I have been unable to find again! This
referred to the fact that the Dragon CAM was asserting a line on PCMCIA
interface that said it was a low voltage device (3.5V) and that this was
outside the CI spec and causing a problem with the budget CI.

However this link says that it should work. I don't know if your CAM is
on it. I suspect this is referring to the supplied windows driver
http://www.dvbnetwork.de/index.php?option=com_fireboard&func=view&id=927&catid=2&Itemid=26

I would love to investigate further but really need some specs of the
software interface to the 3200. Can anyone point me at further info? All
I have at the momenet is the spec for the SAA7146  chip and the en50221
CI spec.

Sorry I cannot offer any direct help. But I thought you might like to
know you are not the only one fighting with this piece of hardware :-)

Roger


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
