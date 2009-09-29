Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp19.orange.fr ([80.12.242.1]:31359 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbZI2KAu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Sep 2009 06:00:50 -0400
From: Christophe Thommeret <hftom@free.fr>
To: Jiri Dobry <jirik@kaznejov.cz>
Subject: Re: record DVB-S2 stream into file
Date: Tue, 29 Sep 2009 12:01:14 +0200
Cc: linux-media@vger.kernel.org
References: <4AC1CFF1.7050907@kaznejov.cz>
In-Reply-To: <4AC1CFF1.7050907@kaznejov.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200909291201.14623.hftom@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le Tuesday 29 September 2009 11:14:25 Jiri Dobry, vous avez écrit :
> Hello,
>
> I would like to record DVB-S2 complete stream into file. For DVB-S I can
> use dvbstream tool.
> But on this time it not support DVB_S2.
>
> Do somebody have patch or another tip how to save stream into file.
>
> Jiri
>
> PS: I don't need only one program/service but complete stream with all
> PIDs.

Kaffeine 0.8.8 supports DVB-S2 and you can record a whole TS by setting a 
channel with videoPid=0 and audioPid=8192.
Hope this helps.


-- 
Christophe Thommeret


