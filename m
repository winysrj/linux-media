Return-path: <mchehab@pedra>
Received: from smtp1.infomaniak.ch ([84.16.68.89]:53368 "EHLO
	smtp1.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab0IUIn4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Sep 2010 04:43:56 -0400
Received: from ams-thkernen-8714.cisco.com (64-103-25-233.cisco.com [64.103.25.233])
	(authenticated bits=0)
	by smtp1.infomaniak.ch (8.14.2/8.14.2) with ESMTP id o8L8hqa8001431
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 21 Sep 2010 10:43:54 +0200
Message-ID: <4C987048.2000101@deckpoint.ch>
Date: Tue, 21 Sep 2010 10:43:52 +0200
From: Thomas Kernen <tkernen@deckpoint.ch>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Hauppauge WinTV-NOVA-T-500 support
References: <4C85F654.3020505@deckpoint.ch>
In-Reply-To: <4C85F654.3020505@deckpoint.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


So I've tested a WinTV-NOVA-T-500 model 283 (SL-283-V2.0-GER) which 
according to the wiki isn't suppose to work:
http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-T-500

Anyhow, the revision I own, (WinTV-NOVA-T-500, 99101 LF, Rev D8B5) I 
seem to have no issues with support, no errors on loading the modules or 
tuning to the different DVB-T tuners. I'll go ahead and update the Wiki 
page to add a note that this revision actually does work and that the 
blanket statement claiming all model 283 are not supported.

Regards,
Thomas

On 9/7/10 10:22 AM, Thomas Kernen wrote:
>
> Hello,
>
> According to the wiki entry for the Hauppauge WinTV-NOVA-T-500 hardware:
> http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-T-500
>
> Models 289 and 287 are supported (ie: the UK sold cards), but model 283
> sold in Germany, Switzerland and maybe some other countries isn't.
>
> Is this still an accurate statement or has this situation evolved but
> hasn't been updated in the wiki entry?
>
> Regards,
> Thomas
> --
