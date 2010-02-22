Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp19.orange.fr ([80.12.242.17]:41775 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab0BVI3Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 03:29:24 -0500
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] TechnoTrend S1500 DVBs / CI can not read Irdeto Cam
Date: Mon, 22 Feb 2010 09:29:33 +0100
References: <33c8ba441002212159x6671ccedjd951dcf1453e1f2@mail.gmail.com>
In-Reply-To: <33c8ba441002212159x6671ccedjd951dcf1453e1f2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002220929.33770.hftom@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le lundi 22 février 2010 06:59:35, Ahmad Issa a écrit :
> Hi,
> 
> 
> 
> I am testing TechnoTrend DVBS 1500 with CI. Everything is working fine when
> i use KeyFly Cam, but when i use Irdeto Cam im getting the below error:
> 
> 
> 
> error: cannot write to CAM device (Input/output error)
> 
> error: en50221_Init: couldn't send TPDU on slot 0
> 
> debug: en50221_Poll: resetting slot 0
> 
> 
> 
> i testing the card using DVBLast and also when i use VLC i get same results
> 
> 
> 
> i have installed the latest DVB driver from www.linuxtv.org
> 
> 
> 
> #lspci
> 
> 0f:04.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
> 
> 
> 
> 
> 
> # lsmod | grep dvb
> 
> dvb_ttpci             125216  0
> 
> saa7146_vv             59560  1 dvb_ttpci
> 
> saa7146                22800  4 budget_ci,budget_core,dvb_ttpci,saa7146_vv
> 
> ttpci_eeprom            2792  2 budget_core,dvb_ttpci
> 
> dvb_core              120724  5
> stv0299,budget_ci,budget_core,dvb_ttpci,b2c2_flexcop
> 
> 
> 
> Any Help?
> 
> 
> 
> Thanks Alot
> 
> 
> 
> 
> 
> Ahmad
> 

See http://www.linuxtv.org/wiki/index.php/TechnoTrend_TT-budget_S-1500

-- 
Christophe Thommeret


