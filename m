Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail1.syd.koalatelecom.com.au ([123.108.76.140])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <peter_s_d@fastmail.com.au>) id 1JQaCX-0007B6-Ec
	for linux-dvb@linuxtv.org; Sun, 17 Feb 2008 04:28:26 +0100
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail1.syd.koalatelecom.com.au (Postfix) with ESMTP id 82B57A68051
	for <linux-dvb@linuxtv.org>; Sun, 17 Feb 2008 14:28:22 +1100 (EST)
Received: from mail1.syd.koalatelecom.com.au ([127.0.0.1])
	by localhost (mail1.syd.koalatelecom.com.au [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id HAUtRVVyuK2x for <linux-dvb@linuxtv.org>;
	Sun, 17 Feb 2008 14:28:14 +1100 (EST)
Received: from on_board.home.invalid (unknown [202.10.85.133])
	by mail1.syd.koalatelecom.com.au (Postfix) with ESMTP id 6CEBDA68106
	for <linux-dvb@linuxtv.org>; Sun, 17 Feb 2008 14:28:12 +1100 (EST)
From: "Peter D." <peter_s_d@fastmail.com.au>
To: linux-dvb@linuxtv.org
Date: Sun, 17 Feb 2008 14:28:10 +1100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802171428.10859.peter_s_d@fastmail.com.au>
Subject: [linux-dvb] auto detection of Flytv duo/hybrid and pci/cardbus
	confusion
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi, 

I've finally gotten around to reading the code and trying to get my 
PCI MSI TV@nywhere A/D card auto detected. 

First clarification, duo versus hybrid.  
Are "duo" cards equipped with two independent tuners that can both be 
used at the same time?  
Are "hybrid" cards necessarily equipped with digital and analogue tuners?  
Can a two tuner card be both a duo and a hybrid, if one tuner is digital 
the other is analogue and they can both be used at the same time?  

Second clarification, PCI versus cardbus.  
They don't look anything like each other, but can they be logically 
interchangeable?  If the code for a cardbus tuner happens to work for 
a PCI tuner is there anything wrong with referring to the PCI tuner 
as a cardbus device?  

Looking at <http://www.linuxtv.org/wiki/index.php/DVB-T_PCMCIA_Cards> 
there does not appear to be any such thing as a 
SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS, despite the entry (number 94) 
in saa7134.h.  Looking at 
<http://www.linuxtv.org/wiki/index.php/DVB-T_PCI_Cards#LifeView> 
there is a PCI version - but there is no PCI version in saa7134.h.  

Should 
"SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS" be changed to 
"SAA7134_BOARD_FLYDVBT_HYBRID"?

It appears that both PCI and cardbus versions of the Flytv duo exist 
and are listed in saa7134.h - despite slightly inconsistent punctuation; 
SAA7134_BOARD_FLYDVBTDUO versus 
SAA7134_BOARD_FLYDVBT_DUO_CARDBUS.  

Should 
"SAA7134_BOARD_FLYDVBTDUO" be changed to 
"SAA7134_BOARD_FLYDVBT_DUO"?

I have an MSI TV@nywhere A/D PCI card that works with the option card=94

There appears to not be an entry in struct pci_device_id saa7134_pci_tbl[] 
in saa7134-cards.c for my card.  There is a reference to a 
"TV@nywhere DUO" which I guess is a valid entry for a different card.  

Is the entry; 

          {
                .vendor       = PCI_VENDOR_ID_PHILIPS,
                .device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
                .subvendor    = 0x4e42,
                .subdevice    = 0x3502,
                .driver_data  = SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS
        },

supposed to be;

           {
                .vendor       = PCI_VENDOR_ID_PHILIPS,
                .device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
                .subvendor    = 0x4E42,         /* MSI */
                .subdevice    = 0x3306,         /* TV@nywhere Hybrid A/D */
                driver_data  = SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS,
        },

with the subdevice changed, or possibly;

           {
                .vendor       = PCI_VENDOR_ID_PHILIPS,
                .device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
                .subvendor    = 0x4E42,         /* MSI */
                .subdevice    = 0x3306,         /* TV@nywhere Hybrid A/D */
                driver_data  = SAA7134_BOARD_FLYDVBT_HYBRID,
        },

with the subdevice and driver_data changed, or should there be an extra 
entry in the list?  

Thank you.  


-- 
sig goes here...
Peter D.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
