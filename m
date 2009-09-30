Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback3.mail.ru ([94.100.176.58]:54280 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbZI3Rmh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Sep 2009 13:42:37 -0400
Received: from mx27.mail.ru (mx27.mail.ru [94.100.176.41])
	by fallback3.mail.ru (mPOP.Fallback_MX) with ESMTP id A71424A0A58
	for <linux-media@vger.kernel.org>; Wed, 30 Sep 2009 21:42:40 +0400 (MSD)
Date: Wed, 30 Sep 2009 21:43:57 +0400
From: Goga777 <goga777@bk.ru>
To: Jiri Dobry <jirik@kaznejov.cz>, linux-media@vger.kernel.org
Subject: Re: record DVB-S2 stream into file
Message-ID: <20090930214357.1b19a872@bk.ru>
In-Reply-To: <4AC1DBBD.2060006@kaznejov.cz>
References: <4AC1CFF1.7050907@kaznejov.cz>
	<200909291201.14623.hftom@free.fr>
	<4AC1DBBD.2060006@kaznejov.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > Kaffeine 0.8.8 supports DVB-S2 and you can record a whole TS by setting a 
> > channel with videoPid=0 and audioPid=8192.
> > Hope this helps.
> >
> >
> >   
> Thanks, but I need command line tool. Is it possible use kaffeine 
> without XORG? I thing no.
> 
> But many thanks, it is solution but i forget wrote that I need command 
> line tool.

in first console you can run szap-s2 which support s2 api
in second console you can run dvbstream

dvbstream -o 8192 > dump.ts

I hope it will help

Goga

