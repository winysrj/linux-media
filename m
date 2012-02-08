Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58578 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774Ab2BHMYV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2012 07:24:21 -0500
Received: by qcqw6 with SMTP id w6so244350qcq.19
        for <linux-media@vger.kernel.org>; Wed, 08 Feb 2012 04:24:20 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 8 Feb 2012 13:24:20 +0100
Message-ID: <CAO+60fyyvqbO6NQ6f4EQ88+DQFEkqTogiNQi5WddfNW_o6Jg0w@mail.gmail.com>
Subject: Issue with Afatech AF9015 DVB-T USB
From: =?UTF-8?Q?Mile_Davidovi=C4=87?= <mile.davidovic@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
I am currently trying to use Afatech AF9015 DVB-T USB card. Generaly
it is working fine on my PC and MIPS SoC.

Except one part which is currently blocking me:

Currently I am trying to record whole TS using dvbsnoop or dvbstream tool.
It seems that I am unable to stream whole TS using following cmd:
dvbstream 8192

Also: dvbsnoop -s ts -tsraw -crc does not work.
It seems that dvbsnoop is blocked in read ...

I make quick check and it seems that DVB_USB_ADAP_HAS_PID_FILTER is
enabled for this card.

Has anyone succeeded in making Afatech card working in necessary mode?

Thanks in advance
MD
