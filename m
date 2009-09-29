Return-path: <linux-media-owner@vger.kernel.org>
Received: from link-v.kaznejov.cz ([89.235.36.82]:34473 "EHLO
	link-v.kaznejov.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbZI2KEr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Sep 2009 06:04:47 -0400
Received: from localhost (localhost [127.0.0.1])
	by link-v.kaznejov.cz (Postfix) with ESMTP id 64BCCE5039
	for <linux-media@vger.kernel.org>; Tue, 29 Sep 2009 12:04:51 +0200 (CEST)
Received: from link-v.kaznejov.cz ([127.0.0.1])
	by localhost (kaznejov.cz [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fe5FOfyp9fRx for <linux-media@vger.kernel.org>;
	Tue, 29 Sep 2009 12:04:45 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by link-v.kaznejov.cz (Postfix) with ESMTP id 50CD5E10E7
	for <linux-media@vger.kernel.org>; Tue, 29 Sep 2009 12:04:45 +0200 (CEST)
Message-ID: <4AC1DBBD.2060006@kaznejov.cz>
Date: Tue, 29 Sep 2009 12:04:45 +0200
From: Jiri Dobry <jirik@kaznejov.cz>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: record DVB-S2 stream into file
References: <4AC1CFF1.7050907@kaznejov.cz> <200909291201.14623.hftom@free.fr>
In-Reply-To: <200909291201.14623.hftom@free.fr>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Christophe Thommeret napsal(a):
> Le Tuesday 29 September 2009 11:14:25 Jiri Dobry, vous avez écrit :
>   
>
> Kaffeine 0.8.8 supports DVB-S2 and you can record a whole TS by setting a 
> channel with videoPid=0 and audioPid=8192.
> Hope this helps.
>
>
>   
Thanks, but I need command line tool. Is it possible use kaffeine 
without XORG? I thing no.

But many thanks, it is solution but i forget wrote that I need command 
line tool.

Jiri
