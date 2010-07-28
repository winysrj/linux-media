Return-path: <linux-media-owner@vger.kernel.org>
Received: from imsm058.netvigator.com ([218.102.48.211]:43759 "EHLO
	imsm058.netvigator.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab0G1ENP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 00:13:15 -0400
Received: from khiatani.ath.cx ([219.78.29.165])
          by imsm058dat.netvigator.com
          (InterMail vM.7.05.01.01 201-2174-106-103-20060222) with ESMTP
          id <20100728035429.DCTT27715.imsm058dat.netvigator.com@khiatani.ath.cx>
          for <linux-media@vger.kernel.org>;
          Wed, 28 Jul 2010 11:54:29 +0800
Received: from localhost (localhost [127.0.0.1])
	by khiatani.ath.cx (Postfix) with ESMTP id 1708D624771
	for <linux-media@vger.kernel.org>; Wed, 28 Jul 2010 11:54:29 +0800 (HKT)
Received: from khiatani.ath.cx ([127.0.0.1])
	by localhost (khiatani.ath.cx [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LQHh0Zb69slH for <linux-media@vger.kernel.org>;
	Wed, 28 Jul 2010 11:54:28 +0800 (HKT)
Received: from localhost (localhost [127.0.0.1])
	by khiatani.ath.cx (Postfix) with ESMTP id F14FD624775
	for <linux-media@vger.kernel.org>; Wed, 28 Jul 2010 11:54:27 +0800 (HKT)
Received: from localhost (localhost [127.0.0.1])
	(Authenticated sender: sunil@khiatani.ath.cx)
	by khiatani.ath.cx (Postfix) with ESMTP id 78A3B624771
	for <linux-media@vger.kernel.org>; Wed, 28 Jul 2010 11:54:27 +0800 (HKT)
Message-ID: <20100728115427.139030h04q7895wk@khiatani.ath.cx>
Date: Wed, 28 Jul 2010 11:54:27 +0800
From: Sunil Khiatani <sunil@khiatani.ath.cx>
To: linux-media@vger.kernel.org
Subject: Analog support for X8558
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I would like to try to add support to the mygica X8558. Digital TV is  
already supported for this hardware in the linux kernel but analog  
support isn't.  I haven't done kernel development before but the  
chipset it contains, cx23885, seems to be widely supported.

The spec sheets for the tuner used, maxim 2165E, seems to be available  
on website.  I'm having trouble deciding whether it is possible to  
enable analog support on this card.  It seems that there are two  
tuners for digital tv, but only one cx23885.  Will it be possible to  
support two analog tuners along with the tuners with only one cx23885?  
Is there a source code I can use? What information should I try to  
obtain to help answer this question so I can start coding for it?


Regards,

Sunil



----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.


