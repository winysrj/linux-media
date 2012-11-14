Return-path: <linux-media-owner@vger.kernel.org>
Received: from ks358065.kimsufi.com ([91.121.151.38]:34031 "EHLO
	ks358065.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab2KNIsJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 03:48:09 -0500
From: =?iso-8859-15?q?Fr=E9d=E9ric?= <fma@gbiloba.org>
To: Patrice Chotard <patrice.chotard@sfr.fr>
Subject: Re: Support for Terratec Cinergy 2400i DT in kernel 3.x
Date: Wed, 14 Nov 2012 09:48:00 +0100
Cc: linux-media@vger.kernel.org
References: <201211131040.22114.fma@gbiloba.org> <50A2C0C4.9040607@sfr.fr>
In-Reply-To: <50A2C0C4.9040607@sfr.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201211140948.00913.fma@gbiloba.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le mardi 13 novembre 2012, Patrice Chotard a écrit :

> Two patches have been already submitted and are available since v3.7-rc1
> 
> media] ngene: add support for Terratec Cynergy 2400i Dual DVB-T  :
> 397e972350c42cbaf3228fe2eec23fecf6a69903
> 
> and
> 
> media] dvb: add support for Thomson DTT7520X :
> 5fb67074c6657edc34867cba78255b6f5b505f12

I had a look at your patches. I don't see the '.fw_version' param anymore in the 'ngene_info' 
structure... Is it normal?

-- 
   Frédéric
