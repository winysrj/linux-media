Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54125 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbZGCXxy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jul 2009 19:53:54 -0400
Message-ID: <4A4E9A12.9080802@iki.fi>
Date: Sat, 04 Jul 2009 02:53:54 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jelle de Jong <jelledejong@powercraft.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Ralink RTL2831U
References: <4A448634.7000209@powercraft.nl>
In-Reply-To: <4A448634.7000209@powercraft.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moi Jelle,

On 06/26/2009 11:26 AM, Jelle de Jong wrote:
> Question for Antti if he had any luck with the devices (rtl2831-r2) I send?

I have been busy with other drivers, but now I have time for this.

It was a little bit tricky to take sniffs from Windows because sniffer 
crashed very easily with this device :o But after testing about all 
drivers I found and after countless blue-screens I finally got one good 
sniff. From sniff I see this device is rather simple to program. And 
device you send have MT2060 tuner.

With a any luck and without other summer activities (I am still hoping 
warm weather and beach activities :) it will not take many days to get 
picture. After that I will move relevant parts from the current Ralink 
driver to the new driver... I will keep informed about driver status.

regards
Antti
-- 
http://palosaari.fi/
