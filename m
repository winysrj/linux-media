Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50677 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687Ab3BYVHT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Feb 2013 16:07:19 -0500
Received: by mail-wi0-f172.google.com with SMTP id ez12so4000920wid.5
        for <linux-media@vger.kernel.org>; Mon, 25 Feb 2013 13:07:18 -0800 (PST)
Message-ID: <512BD285.9010802@gmail.com>
Date: Mon, 25 Feb 2013 22:07:17 +0100
From: Geert Hedde Bosman <geert.hedde.bosman@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Please update DVB-T frequency list 'dvb-t/nl-All'
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
in summer 2012 in the Netherlands major frequency changes took place in 
DVB-t broadcast. Some new frequencies were added as well. Therefore the 
frequency-file dvb/dvb-t/nl-All is no longer actual. Could someone (i 
believe Cristoph P. is one of the maintainers) please update this file? 
The website http://radio-tv-nederland.nl/ provides an up to date 
frequency list.
As an example: i had to add the following line to the file 'nl-All' to 
get the FTA tv-stations in the north of the Netherlands as it was missing:
T 674000000 8MHz 1/2 NONE QAM64 8k 1/4 NONE

regards
GHB

