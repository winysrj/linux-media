Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41366 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab0HBIaM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 04:30:12 -0400
Received: by pvc7 with SMTP id 7so1263172pvc.19
        for <linux-media@vger.kernel.org>; Mon, 02 Aug 2010 01:30:11 -0700 (PDT)
Message-ID: <4C56820E.6060506@gmail.com>
Date: Mon, 02 Aug 2010 18:30:06 +1000
From: O&M Ugarcina <mo.ucina@gmail.com>
Reply-To: mo.ucina@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: TeVii S470 periodically fails to tune/lock - needs poweroff
References: <B17A774B76B64B25A20875E6A0F875A0@telstraclear.tclad> <6C14F26AEE154C61B43A699ABC57CE67@telstraclear.tclad>
In-Reply-To: <6C14F26AEE154C61B43A699ABC57CE67@telstraclear.tclad>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Guys,

I have been using my TeVii S470 DVBS2 card for about one month . I am 
using it with mythtv on fedora 12 using latest kernel , and compiled the 
latest v4l drivers . The sensitivity and picture is very good both on 
dvbs and dvbs2 transponders , very happy with that . However several 
times already when trying to watch live tv on myth the channel failed to 
tune . Usually happens in the morning after box was running 24x7 for a 
few days . The only way to restore functionality is to do a power off 
and wait a couple of mins . If I just do a reboot , this does not help . 
Strange thing is that I see nothing in the mythtv logs or dmesg or 
messages log . When the card is in this no-lock state , it will not tune 
into any channel even when I run scandvb . After power off everything 
works again for a few more days . Any info welcome .

Best Regards

Milorad
