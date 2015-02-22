Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpq5.tb.mail.iss.as9143.net ([212.54.42.168]:36641 "EHLO
	smtpq5.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751890AbbBVP2f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2015 10:28:35 -0500
Received: from [212.54.42.136] (helo=smtp5.tb.mail.iss.as9143.net)
	by smtpq5.tb.mail.iss.as9143.net with esmtp (Exim 4.82)
	(envelope-from <rudy@grumpydevil.homelinux.org>)
	id 1YPYSP-0003S0-E8
	for linux-media@vger.kernel.org; Sun, 22 Feb 2015 16:28:33 +0100
Received: from 5ed66c68.cm-7-7b.dynamic.ziggo.nl ([94.214.108.104] helo=imail.office.romunt.nl)
	by smtp5.tb.mail.iss.as9143.net with esmtp (Exim 4.82)
	(envelope-from <rudy@grumpydevil.homelinux.org>)
	id 1YPYSP-0004zh-BJ
	for linux-media@vger.kernel.org; Sun, 22 Feb 2015 16:28:33 +0100
Received: from [192.168.1.15] (cenedra.office.romunt.nl [192.168.1.15])
	by imail.office.romunt.nl (8.14.4/8.14.4/Debian-4) with ESMTP id t1MFSVgd015662
	for <linux-media@vger.kernel.org>; Sun, 22 Feb 2015 16:28:32 +0100
Message-ID: <54E9F59A.4070407@grumpydevil.homelinux.org>
Date: Sun, 22 Feb 2015 16:28:26 +0100
From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: DVB Simulcrypt
References: <54E8F8F4.1010601@grumpydevil.homelinux.org>
In-Reply-To: <54E8F8F4.1010601@grumpydevil.homelinux.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some more info

On 21-02-15 22:30, Rudy Zijlstra wrote:
> Dears (Hans?)
>
> My setup, where the cable operator was using only irdeto, was working 
> good. Then the cable operator merged with another, and now the 
> networks are being merged. As a result, the encryption has moved from 
> irdeto only to simulcyrpt with Irdeto and Nagra.
>
> Current status:
> - when i put the CA card in a STB, it works
> - when trying to record an encrypted channel from PC, it no longer works.
Recording system has 3 tuners. All equal, all with same permissions on 
the smartcard. On cards 0 and 2 does not work, but card 1 does work, on 
all channels tested.

>
> I suspect the problem is that the wrong keys are used: Nagra keys in 
> stead of Irdeto keys.
>
> I do not know whether:
> - kernel issue (is simulcrypt supported?)
> - API issue (is all support in place to select the right key stream?)
> - application issue (does the application allow to set the right CA?)
>
> If this is an application issue, could it be solved by setting the API 
> outside the application, to direct it to the right (Irdeto in my case) 
> encryption?
>
> The application i am using is MythTV.
>
>
> Cheers
>
>
> Rudy
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

